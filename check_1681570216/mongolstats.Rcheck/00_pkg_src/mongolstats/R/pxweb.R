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
#' @importFrom curl curl_escape
#' @keywords internal
.px_list <- function(paths = character(), lang = .px_lang()) {
  url <- do.call(.px_url, as.list(c(paths, lang = lang)))
  res <- httr2::request(url) |>
    httr2::req_user_agent(.nso_user_agent()) |>
    httr2::req_timeout(.nso_timeout()) |>
    httr2::req_retry(max_tries = .nso_retry_tries(), backoff = .nso_retry_backoff()) |>
    .nso_perform()
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
    .nso_perform()
  txt <- .px_strip_bom(httr2::resp_body_string(res))
  jsonlite::fromJSON(txt, simplifyVector = FALSE)
}

# Internal cached wrappers
.px_list_cached <- function(paths = character(), lang = .px_lang()) {
  if (isTRUE(.mongolstats_cache_env$enabled) && !is.null(.mongolstats_cache_env$px_list_memo)) {
    .mongolstats_cache_env$px_list_memo(paths, lang)
  } else {
    .px_list(paths, lang)
  }
}

.px_meta_cached <- function(paths, table, lang = .px_lang()) {
  if (isTRUE(.mongolstats_cache_env$enabled) && !is.null(.mongolstats_cache_env$px_meta_memo)) {
    .mongolstats_cache_env$px_meta_memo(paths, table, lang)
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
            if (!length(time_idx)) time_idx <- which(vapply(vars, function(v) length(v$values) && all(grepl("^20[0-9]{2}$", .px_chr(v$valueTexts) %||% "")), logical(1)))
            if (length(time_idx)) {
              vt <- .px_chr(vars[[time_idx[1]]]$valueTexts %||% character())
              if (length(vt)) c(vt[1], vt[length(vt)]) else c(NA_character_, NA_character_)
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
        itm_id = .px_chr(v$values %||% character()),
        scr_eng = .px_chr(v$valueTexts %||% character())
      )
  })
  if (!is.null(vm)) {
    out_mn <- purrr::imap_dfr(vm, function(v, i) {
      name <- .px_first_nonempty(v$text, v$code, paste0("V", i))
      tibble::tibble(
        field = name,
        itm_id = .px_chr(v$values %||% character()),
        scr_mn = .px_chr(v$valueTexts %||% character())
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

#' List dimensions for a PXWeb table
#'
#' Returns one row per dimension with basic metadata.
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_0300_001V2").
#' @return A tibble with columns: `dim` (display name), `code` (dimension code),
#'   `is_time` (logical), and `n_values` (number of values for the dimension).
#' @export
nso_dims <- function(tbl_id) {
  stopifnot(is.character(tbl_id), length(tbl_id) == 1L)
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) tbl_id else paste0(tbl_id, ".px")
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) stop("Table not found in PXWeb index: ", tbl_id)
  paths <- if (nzchar(row$px_path[1])) strsplit(row$px_path[1], "/", fixed = TRUE)[[1]] else character()
  meta_en <- tryCatch(.px_meta_cached(paths, px_file, lang = "en"), error = function(e) NULL)
  if (is.null(meta_en) || is.null(meta_en$variables)) return(tibble::tibble())
  vars <- meta_en$variables
  tibble::tibble(
    dim = vapply(vars, function(v) .px_first_nonempty(v$text, v$code, ""), character(1)),
    code = vapply(vars, function(v) as.character(v$code), character(1)),
    is_time = vapply(vars, function(v) isTRUE(v$time), logical(1)),
    n_values = vapply(vars, function(v) length(.px_chr(v$values %||% character())), integer(1))
  )
}

#' List values for a table dimension
#'
#' Returns codes and optional labels for a specific dimension.
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_0300_001V2").
#' @param dim Dimension name or code (case-insensitive; exact match preferred).
#' @param labels One of "code", "en", "mn", or "both" to control returned label columns.
#' @return A tibble with at least `code`; may include `label_en` and/or `label_mn`.
#' @export
nso_dim_values <- function(tbl_id, dim, labels = c("code", "en", "mn", "both")) {
  stopifnot(is.character(tbl_id), length(tbl_id) == 1L)
  stopifnot(is.character(dim), length(dim) == 1L)
  labels <- match.arg(labels)
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) tbl_id else paste0(tbl_id, ".px")
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) stop("Table not found in PXWeb index: ", tbl_id)
  paths <- if (nzchar(row$px_path[1])) strsplit(row$px_path[1], "/", fixed = TRUE)[[1]] else character()
  meta_en <- tryCatch(.px_meta_cached(paths, px_file, lang = "en"), error = function(e) NULL)
  if (is.null(meta_en) || is.null(meta_en$variables)) return(tibble::tibble())
  vars_en <- meta_en$variables
  # Locate the requested dimension (prefer exact code/text match, then unique partial match)
  needle <- tolower(dim)
  eq_code <- which(vapply(vars_en, function(v) tolower(as.character(v$code %||% "")) == needle, logical(1)))
  eq_text <- which(vapply(vars_en, function(v) tolower(.px_first_nonempty(v$text, v$code, "")) == needle, logical(1)))
  idxs <- unique(c(eq_code, eq_text))
  if (!length(idxs)) {
    pm <- which(vapply(vars_en, function(v) grepl(needle, tolower(.px_first_nonempty(v$text, v$code, "")), fixed = TRUE), logical(1)))
    idxs <- unique(pm)
  }
  if (!length(idxs)) {
    # helpful error listing available dimensions
    dims <- vapply(vars_en, function(v) .px_first_nonempty(v$text, v$code, ""), character(1))
    stop(sprintf("Dimension '%s' not found. Available: %s", dim, paste(dims, collapse = ", ")))
  }
  if (length(idxs) > 1) {
    dims <- vapply(vars_en[idxs], function(v) .px_first_nonempty(v$text, v$code, ""), character(1))
    stop(sprintf("Dimension '%s' is ambiguous. Candidates: %s", dim, paste(dims, collapse = ", ")))
  }
  v_en <- vars_en[[idxs[1]]]
  codes <- .px_chr(v_en$values %||% character())
  labs_en <- .px_chr(v_en$valueTexts %||% character())
  out <- tibble::tibble(code = codes)
  if (labels %in% c("en", "both")) {
    out$label_en <- if (length(labs_en) == length(codes)) labs_en else NA_character_
  }
  if (labels %in% c("mn", "both")) {
    meta_mn <- tryCatch(.px_meta_cached(paths, px_file, lang = "mn"), error = function(e) NULL)
    if (!is.null(meta_mn) && length(meta_mn$variables)) {
      vars_mn <- meta_mn$variables
      # match by dimension code to be robust across languages
      vidx_mn <- purrr::detect_index(vars_mn, function(v) identical(as.character(v$code), as.character(v_en$code)))
      if (vidx_mn) {
        v_mn <- vars_mn[[vidx_mn]]
        codes_mn <- .px_chr(v_mn$values %||% character())
        labs_mn <- .px_chr(v_mn$valueTexts %||% character())
        map_mn <- tibble::tibble(code = codes_mn, label_mn = labs_mn)
        out <- dplyr::left_join(out, map_mn, by = "code")
      } else {
        out$label_mn <- NA_character_
      }
    } else {
      out$label_mn <- NA_character_
    }
  }
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
  # Seed cookie if server uses Set-Cookie (e.g., rxid) to accept POST
  cookie <- NULL
  try({
    seed <- httr2::request(.px_url(paths, px_file, lang = lang)) |>
      httr2::req_user_agent(.nso_user_agent()) |>
      httr2::req_timeout(.nso_timeout()) |>
      httr2::req_retry(max_tries = .nso_retry_tries(), backoff = .nso_retry_backoff()) |>
      httr2::req_perform()
    setck <- tryCatch(httr2::resp_header(seed, "set-cookie"), error = function(e) NULL)
    if (!is.null(setck) && is.character(setck) && length(setck)) {
      rx <- regmatches(setck, regexpr("rxid=[^;]+", setck))
      if (length(rx) && nzchar(rx[1])) cookie <- rx[1]
    }
  }, silent = TRUE)
  # Build query: ensure every variable in the table is included.
  q <- list()
  sel_names <- tolower(names(selections))
  for (v in vars) {
    vname <- tolower(.px_first_nonempty(v$text, v$code, ""))
    vv <- .px_chr(v$values)
    vt <- .px_chr(v$valueTexts)
    if (vname %in% sel_names) {
      # User-provided selection for this variable
      vals <- as.character(selections[[which(sel_names == vname)[1]]])
      # If labels provided, map to codes (prioritize codes over labels)
      if (length(vt) && !all(vals %in% vv) && any(vals %in% vt)) {
        idxs <- match(vals, vt)
        vals <- vv[idxs]
      }
      # Validate
      if (length(vv) && !all(vals %in% vv)) {
        bad <- unique(setdiff(vals, vv))
        ex_codes <- paste(utils::head(vv, 5), collapse = ", ")
        ex_labs <- tryCatch({
          labs <- .px_chr(v$valueTexts)
          if (length(labs)) paste(utils::head(labs, 5), collapse = ", ") else NA_character_
        }, error = function(e) NA_character_)
        msg <- sprintf("Invalid selection for '%s': %s. Available codes include: %s",
                       .px_first_nonempty(v$text, v$code, vname),
                       paste(bad, collapse = ", "), ex_codes)
        if (!is.na(ex_labs)) {
          msg <- paste0(msg, "; labels include: ", ex_labs)
        }
        stop(msg)
      }
      q[[length(q)+1]] <- list(code = v$code, selection = list(filter = "item", values = I(as.character(vals))))
    } else {
      # Not specified: select all explicit codes for this variable
      q[[length(q)+1]] <- list(code = v$code, selection = list(filter = "item", values = I(as.character(vv))))
    }
  }
  body <- list(query = q, response = list(format = "json"))
  # Build pxweb-style named query for fallback
  px_query <- stats::setNames(vector("list", length(vars)), vapply(vars, function(v) v$code, character(1)))
  for (v in vars) {
    vname <- .px_first_nonempty(v$text, v$code, "")
    vv <- .px_chr(v$values)
    vt <- .px_chr(v$valueTexts)
    if (tolower(vname) %in% sel_names) {
      vals <- as.character(selections[[which(sel_names == tolower(vname))[1]]])
      if (length(vt) && !all(vals %in% vv) && any(vals %in% vt)) vals <- vv[match(vals, vt)]
      px_query[[v$code]] <- vals
    } else {
      px_query[[v$code]] <- vv
    }
  }
  url <- .px_url(paths, px_file, lang = lang)
  # Try both with and without the .px suffix as some PXWeb servers differ
  url_variants <- unique(c(url, sub("\\.px$", "", url)))
  resp <- NULL
  for (u in url_variants) {
    req <- httr2::request(u) |>
      httr2::req_user_agent(.nso_user_agent()) |>
      httr2::req_timeout(.nso_timeout()) |>
      httr2::req_retry(max_tries = .nso_retry_tries(), backoff = .nso_retry_backoff())
    if (!is.null(cookie)) {
      req <- httr2::req_headers(req, Cookie = cookie)
    }
    req <- req |> httr2::req_body_json(body)
    # Debug: log request details if verbose
    if (.nso_verbose()) {
      message("mongolstats: POST to ", u)
      message("mongolstats: Cookie: ", if (is.null(cookie)) "NULL" else cookie)
      message("mongolstats: Body: ", substr(jsonlite::toJSON(body, auto_unbox = TRUE), 1, 200))
    }
    resp <- tryCatch(.nso_perform(req), error = function(e) e)
    ok <- !(inherits(resp, "error") || (inherits(resp, "httr2_response") && !is.null(httr2::resp_status(resp)) && httr2::resp_status(resp) >= 400))
    if (ok) {
      url <- u
      break
    }
  }
  if (inherits(resp, "error") || (inherits(resp, "httr2_response") && !is.null(httr2::resp_status(resp)) && httr2::resp_status(resp) >= 400)) {
    # Capture error details for better debugging
    err_details <- if (inherits(resp, "httr2_response")) {
      status <- httr2::resp_status(resp)
      body <- tryCatch(httr2::resp_body_string(resp), error = function(e) "<unable to read>")
      sprintf("HTTP %d. Response: %s", status, substr(body, 1, 200))
    } else if (inherits(resp, "error")) {
      conditionMessage(resp)
    } else {
      "Unknown error"
    }

    if (requireNamespace("pxweb", quietly = TRUE)) {
      # Fallback via pxweb client
      px <- tryCatch(pxweb::pxweb_get(url, query = px_query), error = function(e) e)
      if (!inherits(px, "error")) {
        df <- tryCatch(pxweb::pxweb_as_data_frame(px, column.name.type = "text", variable.value.type = "code"), error = function(e) NULL)
        if (!is.null(df)) return(tibble::as_tibble(df))
      }
    }
    # If fallback not available or failed, rethrow informative error
    msg <- sprintf("PXWeb request failed; tried both .px and extensionless endpoints. %s. If 'pxweb' is installed, verify selections or try smaller subsets.", err_details)
    stop(structure(list(message = msg, call = NULL), class = c("mongolstats_http_error","error","condition")))
  }
  out <- jsonlite::fromJSON(httr2::resp_body_string(resp), simplifyVector = FALSE)
  # Flatten PXWeb response
  cols <- out$columns
  dat <- out$data
  if (length(dat) == 0) return(tibble::tibble())
  # Build data frame of keys and values
  keys <- do.call(rbind, lapply(dat, function(d) unlist(d$key)))
  vals <- vapply(dat, function(d) if (length(d$values)) d$values[[1]] else NA_character_, character(1))
  keys <- as.data.frame(keys, stringsAsFactors = FALSE)
  # Filter columns by type (cols is a list, not a data frame)
  dim_cols <- Filter(function(col) !is.null(col$type) && col$type == "d", cols)
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
