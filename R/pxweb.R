## PXWeb client for data.1212.mn

.px_base_url <- function() {
  getOption("mongolstats.px_base_url", default = "https://data.1212.mn/api/v1")
}

.px_lang <- function() {
  lng <- getOption("mongolstats.lang", default = "en")
  if (!lng %in% c("en","mn")) lng <- "en"
  lng
}

.px_db <- function() {
  getOption("mongolstats.px_db", default = "NSO")
}

.px_url <- function(..., lang = .px_lang(), db = .px_db()) {
  segs <- unlist(list(...), recursive = TRUE, use.names = FALSE)
  parts <- c(.px_base_url(), lang, db, segs)
  parts <- vapply(parts, function(p) gsub("^/+|/+$", "", as.character(p)), character(1))
  if (length(parts) > 1) {
    parts[-1] <- vapply(parts[-1], curl::curl_escape, character(1))
  }
  paste(parts, collapse = "/")
}

#' List PXWeb children under a path
#' @importFrom utils head tail
#' @keywords internal
.px_list <- function(paths = character(), lang = .px_lang()) {
  url <- do.call(.px_url, as.list(c(paths, lang = lang)))
  res <- httr2::request(url) |>
    httr2::req_user_agent(.nso_user_agent()) |>
    httr2::req_timeout(.nso_timeout()) |>
    httr2::req_retry(max_tries = .nso_retry_tries(), backoff = .nso_retry_backoff()) |>
    httr2::req_perform()
  txt <- .px_strip_bom(httr2::resp_body_string(res))
  jsonlite::fromJSON(txt, simplifyVector = TRUE)
}

#' Get PXWeb table metadata
#' @keywords internal
.px_meta <- function(paths, table, lang = .px_lang()) {
  url <- .px_url(paths, table, lang = lang)
  res <- httr2::request(url) |>
    httr2::req_user_agent(.nso_user_agent()) |>
    httr2::req_timeout(.nso_timeout()) |>
    httr2::req_retry(max_tries = .nso_retry_tries(), backoff = .nso_retry_backoff()) |>
    httr2::req_perform()
  txt <- .px_strip_bom(httr2::resp_body_string(res))
  jsonlite::fromJSON(txt, simplifyVector = FALSE)
}

# Internal cached wrappers
.px_list_cached <- function(paths = character(), lang = .px_lang()) {
  if (isTRUE(.tidy1212_cache_env$enabled) && !is.null(.tidy1212_cache_env$px_list_memo)) {
    .tidy1212_cache_env$px_list_memo(paths, lang)
  } else {
    .px_list(paths, lang)
  }
}

.px_meta_cached <- function(paths, table, lang = .px_lang()) {
  if (isTRUE(.tidy1212_cache_env$enabled) && !is.null(.tidy1212_cache_env$px_meta_memo)) {
    .tidy1212_cache_env$px_meta_memo(paths, table, lang)
  } else {
    .px_meta(paths, table, lang)
  }
}

# Recursively list available PXWeb tables under NSO
# Returns tibble with columns: px_path, px_file, tbl_id, tbl_eng_nm, tbl_nm, strt_prd, end_prd
nso_px_tables <- function() {
  # BFS traversal to avoid deep recursion limits
  queue <- list(character())
  out <- list()
  while (length(queue)) {
    paths <- queue[[1]]; queue <- queue[-1]
    kids <- tryCatch(.px_list_cached(paths, lang = .px_lang()), error = function(e) NULL)
    if (is.null(kids) || !length(kids)) next
    # folders have type 'l', tables have type 't'
    is_table <- kids$type == "t"
    tables <- kids[is_table, , drop = FALSE]
    if (nrow(tables)) {
      for (i in seq_len(nrow(tables))) {
        px_file <- tables$id[i]
        meta_en <- tryCatch(.px_meta_cached(paths, px_file, lang = "en"), error = function(e) NULL)
        meta_mn <- tryCatch(.px_meta_cached(paths, px_file, lang = "mn"), error = function(e) NULL)
        title_en <- if (!is.null(meta_en)) meta_en$title else NA_character_
        title_mn <- if (!is.null(meta_mn)) meta_mn$title else NA_character_
        # derive period range from a time-like variable when possible
        rng <- tryCatch({
          vars <- meta_en$variables
          if (length(vars)) {
            time_idx <- which(vapply(vars, function(v) isTRUE(v$time) || grepl("year|time", tolower(v$text %||% "")), logical(1)))
            if (!length(time_idx)) time_idx <- which(vapply(vars, function(v) length(v$values) && all(grepl("^20[0-9]{2}$", v$valueTexts %||% "")), logical(1)))
            if (length(time_idx)) {
              vt <- vars[[time_idx[1]]]$valueTexts %||% character()
              if (length(vt)) c(head(vt,1), tail(vt,1)) else c(NA_character_, NA_character_)
            } else c(NA_character_, NA_character_)
          } else c(NA_character_, NA_character_)
        }, error = function(e) c(NA_character_, NA_character_))
        out[[length(out)+1]] <- tibble::tibble(
          px_path = paste(paths, collapse = "/"),
          px_file = px_file,
          tbl_id = sub("\\.px$", "", px_file),
          tbl_eng_nm = title_en %||% NA_character_,
          tbl_nm = title_mn %||% NA_character_,
          strt_prd = rng[1],
          end_prd = rng[2]
        )
      }
    }
    # enqueue child folders
    folders <- kids[!is_table, , drop = FALSE]
    if (nrow(folders)) {
      for (i in seq_len(nrow(folders))) {
        queue[[length(queue)+1]] <- c(paths, folders$id[i])
      }
    }
  }
  dplyr::bind_rows(out)
}

# Get variable metadata for a PXWeb table (both languages when available)
# Returns tibble with columns: field, itm_id, scr_eng, scr_mn, px_path, px_file
nso_px_variables <- function(tbl_id) {
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) tbl_id else paste0(tbl_id, ".px")
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) stop("Table not found in PXWeb index: ", tbl_id)
  paths <- if (nzchar(row$px_path[1])) strsplit(row$px_path[1], "/", fixed = TRUE)[[1]] else character()
  meta_en <- .px_meta_cached(paths, px_file, lang = "en")
  meta_mn <- tryCatch(.px_meta_cached(paths, px_file, lang = "mn"), error = function(e) NULL)
  ve <- meta_en$variables; vm <- if (!is.null(meta_mn)) meta_mn$variables else NULL
  out <- purrr::imap_dfr(ve, function(v, i) {
      name <- .px_first_nonempty(v$text, v$code, paste0("V", i))
      tibble::tibble(
        field = name,
        itm_id = as.character(v$values %||% character()),
        scr_eng = as.character(v$valueTexts %||% character())
      )
  })
  if (!is.null(vm)) {
    out_mn <- purrr::imap_dfr(vm, function(v, i) {
      name <- .px_first_nonempty(v$text, v$code, paste0("V", i))
      tibble::tibble(
        field = name,
        itm_id = as.character(v$values %||% character()),
        scr_mn = as.character(v$valueTexts %||% character())
      )
    })
    out <- dplyr::left_join(out, out_mn, by = c("field","itm_id"))
  } else {
    out$scr_mn <- NA_character_
  }
  out$px_path <- row$px_path[1]
  out$px_file <- row$px_file[1]
  out
}

# Build/refresh PXWeb table index and memoize in package env
.mongolstats_px_env <- new.env(parent = emptyenv())
.px_index_embedded <- function() {
  # Try to load prebuilt index shipped with the package
  path <- system.file("extdata", "px_index.json", package = "mongolstats")
  if (!nzchar(path) || !file.exists(path)) {
    # also allow dev path
    path <- file.path("inst", "extdata", "px_index.json")
  }
  if (file.exists(path)) {
    df <- tryCatch({
      jsonlite::fromJSON(path, simplifyVector = TRUE)
    }, error = function(e) NULL)
    if (is.data.frame(df)) return(tibble::as_tibble(df))
  }
  tibble::tibble()
}
.px_index <- function(refresh = FALSE) {
  if (isTRUE(refresh) || is.null(.mongolstats_px_env$idx)) {
    # prefer embedded index to avoid cold-start crawl
    idx <- .px_index_embedded()
    if (!nrow(idx)) idx <- tryCatch(nso_px_tables(), error = function(e) tibble::tibble())
    .mongolstats_px_env$idx <- idx
  }
  .mongolstats_px_env$idx
}

#' Rebuild PXWeb index and optionally write to a file
#' @param path Output path for JSON (default 'inst/extdata/px_index.json' in dev trees)
#' @param write Whether to write JSON to `path` (default TRUE)
#' @return tibble index
#' @export
nso_rebuild_px_index <- function(path = file.path("inst","extdata","px_index.json"), write = TRUE) {
  idx <- nso_px_tables()
  if (isTRUE(write)) {
    dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
    jsonlite::write_json(idx, path, dataframe = "rows", auto_unbox = TRUE, pretty = FALSE)
  }
  # refresh in-memory cache
  .mongolstats_px_env$idx <- tibble::as_tibble(idx)
  .mongolstats_px_env$idx
}

# Fetch data from a PXWeb table
# Returns tibble with one column per dimension plus a numeric `value` column.
nso_px_data <- function(tbl_id, selections, lang = .px_lang()) {
  stopifnot(is.list(selections))
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) tbl_id else paste0(tbl_id, ".px")
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) stop("Table not found in PXWeb index: ", tbl_id)
  paths <- if (nzchar(row$px_path[1])) strsplit(row$px_path[1], "/", fixed = TRUE)[[1]] else character()
  meta <- .px_meta_cached(paths, px_file, lang = lang)
  vars <- meta$variables
  # Build query: match selections by variable text (case-insensitive)
  q <- list()
  for (nm in names(selections)) {
    target <- tolower(nm)
    vi <- purrr::detect_index(vars, function(v) tolower(.px_first_nonempty(v$text, v$code, "")) == target)
    if (!vi) stop("Variable not found in table: ", nm)
    v <- vars[[vi]]
    vals <- as.character(selections[[nm]])
    # If user provided labels, map to codes via valueTexts
    if (length(v$valueTexts) && any(vals %in% v$valueTexts)) {
      idxs <- match(vals, v$valueTexts)
      vals <- v$values[idxs]
    }
    q[[length(q)+1]] <- list(code = v$code, selection = list(filter = "item", values = vals))
  }
  body <- list(query = q, response = list(format = "JSON"))
  url <- .px_url(paths, px_file, lang = lang)
  req <- httr2::request(url) |>
    httr2::req_user_agent(.nso_user_agent()) |>
    httr2::req_timeout(.nso_timeout()) |>
    httr2::req_retry(max_tries = .nso_retry_tries(), backoff = .nso_retry_backoff()) |>
    httr2::req_body_json(body)
  resp <- .nso_perform(req)
  out <- jsonlite::fromJSON(httr2::resp_body_string(resp), simplifyVector = FALSE)
  # Flatten PXWeb response
  cols <- out$columns
  dat <- out$data
  if (length(dat) == 0) return(tibble::tibble())
  # Build data frame of keys and values
  keys <- do.call(rbind, lapply(dat, function(d) unlist(d$key)))
  vals <- vapply(dat, function(d) if (length(d$values)) d$values[[1]] else NA_character_, character(1))
  keys <- as.data.frame(keys, stringsAsFactors = FALSE)
  dim_cols <- cols[cols$type == "d"]
  dim_names <- vapply(seq_along(dim_cols), function(i) {
    nm <- .px_first_nonempty(dim_cols[[i]]$text, dim_cols[[i]]$code, paste0("dim", i))
    if (is.null(nm)) nm <- paste0("dim", i)
    nm
  }, character(1))
  dim_names <- make.unique(dim_names)
  names(keys) <- dim_names
  df <- tibble::as_tibble(cbind(keys, value = suppressWarnings(as.numeric(vals))))
  df
}
