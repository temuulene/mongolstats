# Recursively list available PXWeb tables under NSO
# Returns tibble with columns: px_path, px_file, tbl_id, tbl_eng_nm, tbl_nm,
# strt_prd, end_prd, updated
nso_px_tables <- function() {
  show_progress <- .nso_progress() && interactive()
  if (show_progress) {
    cli::cli_progress_bar("Indexing NSO tables", total = NA)
  }
  # A crawl tolerates individual HTTP failures (the rest of the catalogue is
  # still worth having) but reports them together at the end. Offline mode
  # propagates: nothing can be crawled.
  failed <- character()
  try_http <- function(expr, where) {
    tryCatch(expr, mongolstats_http_error = function(e) {
      failed <<- c(failed, where)
      NULL
    })
  }
  # BFS traversal to avoid deep recursion limits
  queue <- list(character())
  out <- list()
  while (length(queue)) {
    paths <- queue[[1]]
    queue <- queue[-1]
    kids <- try_http(
      .px_list_cached(paths, lang = .px_lang()),
      if (length(paths)) paste(paths, collapse = "/") else "<root>"
    )
    if (is.null(kids) || !length(kids)) {
      next
    }
    # folders have type 'l', tables have type 't'
    is_table <- kids$type == "t"
    tables <- kids[is_table, , drop = FALSE]
    if (nrow(tables)) {
      for (i in seq_len(nrow(tables))) {
        px_file <- tables$id[i]
        where <- paste(c(paths, px_file), collapse = "/")
        meta_en <- try_http(.px_meta_cached(paths, px_file, lang = "en"), where)
        meta_mn <- try_http(.px_meta_cached(paths, px_file, lang = "mn"), where)
        title_en <- if (!is.null(meta_en)) meta_en$title else NA_character_
        title_mn <- if (!is.null(meta_mn)) meta_mn$title else NA_character_
        rng <- .px_period_range(meta_en$variables)
        out[[length(out) + 1]] <- tibble::tibble(
          px_path = paste(paths, collapse = "/"),
          px_file = px_file,
          tbl_id = sub("\\.px$", "", px_file),
          tbl_eng_nm = title_en %||% NA_character_,
          tbl_nm = title_mn %||% NA_character_,
          strt_prd = rng[1],
          end_prd = rng[2],
          updated = if (is.null(tables$updated)) {
            NA_character_
          } else {
            as.character(tables$updated[i])
          }
        )
        if (show_progress) cli::cli_progress_update()
      }
    }
    # enqueue child folders
    folders <- kids[!is_table, , drop = FALSE]
    if (nrow(folders)) {
      for (i in seq_len(nrow(folders))) {
        queue[[length(queue) + 1]] <- c(paths, folders$id[i])
      }
    }
  }
  if (length(failed)) {
    failed <- unique(failed)
    cli_warn(
      c(
        "{length(failed)} catalogue request{?s} failed; the table index is incomplete.",
        "i" = "Failed: {.val {utils::head(failed, 5)}}{if (length(failed) > 5) ', ...'}."
      ),
      class = "mongolstats_incomplete_index"
    )
  }
  idx <- dplyr::bind_rows(out)
  attr(idx, "catalogue") <- list(
    coverage = if (length(failed)) "partial" else "complete",
    failed_paths = unique(failed),
    origin = "live_crawl",
    indexed_at = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  )
  idx
}

# Earliest and latest period labels of the time dimension in `vars`, by date
# (NSO lists periods newest first, so the first and last labels are the
# wrong way round); NA when there is no dated time dimension.
.px_period_range <- function(vars) {
  periods <- .px_periods(vars)
  periods <- periods[!is.na(periods$date), , drop = FALSE]
  if (!nrow(periods)) {
    return(c(NA_character_, NA_character_))
  }
  c(periods$label[1], periods$label[nrow(periods)])
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
    return(.px_index_read(path))
  }
  tibble::tibble()
}

# Keep the historical row-array file compatible with existing readers. Its
# optional sidecar describes only those exact bytes and the current service.
.px_index_read <- function(path) {
  df <- tryCatch(
    jsonlite::read_json(path, simplifyVector = TRUE),
    error = function(e) NULL
  )
  if (!is.data.frame(df)) {
    return(tibble::tibble())
  }
  out <- tibble::as_tibble(df)
  if (!file.exists(paste0(path, ".metadata.json"))) {
    return(out)
  }
  stamp <- tryCatch(
    jsonlite::read_json(paste0(path, ".metadata.json"), simplifyVector = TRUE),
    error = function(e) NULL
  )
  if (!is.list(stamp)) {
    return(out)
  }
  meta <- stamp$catalogue
  valid <- identical(stamp$schema_version, 1L) &&
    identical(
      stamp$index_sha256,
      digest::digest(file = path, algo = "sha256")
    ) &&
    identical(stamp$base_url, .px_base_url()) &&
    identical(stamp$database, .px_db()) &&
    is.list(meta) &&
    is.character(meta$coverage) &&
    length(meta$coverage) == 1L &&
    meta$coverage %in% c("complete", "partial") &&
    is.character(meta$indexed_at) &&
    length(meta$indexed_at) == 1L &&
    !is.na(meta$indexed_at) &&
    grepl("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$", meta$indexed_at) &&
    is.character(meta$origin) &&
    length(meta$origin) == 1L &&
    !is.na(meta$origin) &&
    (!length(meta$failed_paths) || is.character(meta$failed_paths))
  if (isTRUE(valid)) {
    if (!length(meta$failed_paths)) {
      meta$failed_paths <- character()
    }
    attr(out, "catalogue") <- meta
  }
  out
}
.px_index <- function(refresh = FALSE) {
  if (isTRUE(refresh) || is.null(.mongolstats_px_env$idx)) {
    # prefer embedded index to avoid cold-start crawl
    idx <- .px_index_embedded()
    if (!nrow(idx)) {
      idx <- .nso_or_offline(nso_px_tables(), tibble::tibble())
    }
    .mongolstats_px_env$idx <- idx
  }
  .mongolstats_px_env$idx
}

#' Rebuild PXWeb index and optionally write to a file
#'
#' Crawls the PXWeb API to rebuild the table index. If `path` is provided,
#' the index is written to that file; otherwise only the in-memory index is
#' refreshed.
#'
#' @param path Output path for JSON. If `NULL` (default), no file is written.
#'   For package development, use `"inst/extdata/px_index.json"`.
#'   A companion `<path>.metadata.json` file preserves coverage and build time,
#'   checked against the index's SHA-256 hash and service identity on reload.
#' @param write Whether to write JSON to `path`. Defaults to `TRUE` if `path`
#'   is provided, `FALSE` otherwise.
#' @param allow_incomplete Allow a partial crawl to replace the current index
#'   and be written to disk. Defaults to `FALSE`; incomplete crawls raise a
#'   typed error and leave the previous index and output file intact.
#' @return A tibble containing the rebuilt table index. If some catalogue
#'   requests fail, the index is built from the rest and a warning of class
#'   `mongolstats_incomplete_index` names the failed paths.
#' @examples
#' # Crawls the entire PXWeb catalogue; takes several minutes
#' \dontrun{
#' idx <- nso_rebuild_px_index()
#' head(idx)
#' }
#' @export
nso_rebuild_px_index <- function(
  path = NULL,
  write = !is.null(path),
  allow_incomplete = FALSE
) {
  if (
    !is.logical(write) ||
      length(write) != 1L ||
      is.na(write) ||
      !is.logical(allow_incomplete) ||
      length(allow_incomplete) != 1L ||
      is.na(allow_incomplete)
  ) {
    cli_abort("{.arg write} and {.arg allow_incomplete} must be logical flags.")
  }
  if (!is.null(path)) {
    .nso_manifest_path(path)
  }
  idx <- nso_px_tables()
  coverage <- attr(idx, "catalogue", exact = TRUE)
  if (identical(coverage$coverage, "partial") && !allow_incomplete) {
    cli_abort(
      "The catalogue crawl was incomplete; the previous index was retained.",
      class = "mongolstats_incomplete_index",
      failed_paths = coverage$failed_paths
    )
  }
  if (isTRUE(write) && !is.null(path)) {
    dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
    jsonlite::write_json(
      idx,
      path,
      dataframe = "rows",
      auto_unbox = TRUE,
      pretty = FALSE
    )
    jsonlite::write_json(
      list(
        schema_version = 1L,
        index_sha256 = digest::digest(file = path, algo = "sha256"),
        base_url = .px_base_url(),
        database = .px_db(),
        catalogue = coverage
      ),
      paste0(path, ".metadata.json"),
      auto_unbox = TRUE
    )
  }
  # refresh in-memory cache
  .mongolstats_px_env$idx <- tibble::as_tibble(idx)
  attr(.mongolstats_px_env$idx, "catalogue") <- coverage
  .mongolstats_px_env$idx
}
