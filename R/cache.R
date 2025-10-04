.mongolstats_cache_env <- new.env(parent = emptyenv())
.mongolstats_cache_env$enabled <- FALSE
.mongolstats_cache_env$cache <- NULL
.mongolstats_cache_env$fetch_itms_memo <- NULL
.mongolstats_cache_env$fetch_detail_memo <- NULL
.mongolstats_cache_env$px_list_memo <- NULL
.mongolstats_cache_env$px_meta_memo <- NULL

#' Enable or configure caching
#'
#' Caches table lists and codebooks on disk to speed up repeated calls.
#' @param dir Directory for cache; defaults to user cache dir.
#' @return Cache directory path.
#' @export
nso_cache_enable <- function(dir = NULL) {
  if (!requireNamespace("memoise", quietly = TRUE) ||
      !requireNamespace("cachem", quietly = TRUE) ||
      !requireNamespace("rappdirs", quietly = TRUE)) {
    stop("Enable caching requires memoise, cachem, rappdirs packages.")
  }
  if (is.null(dir)) {
    # Namespace under mongolstats and include a cache version for safe upgrades
    dir <- file.path(rappdirs::user_cache_dir("mongolstats"), "v1")
  }
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  cache <- cachem::cache_disk(dir)
  .mongolstats_cache_env$cache <- cache
  if (exists(".fetch_itms_raw", mode = "function")) {
    .mongolstats_cache_env$fetch_itms_memo <- memoise::memoise(.fetch_itms_raw, cache = cache)
  }
  if (exists(".fetch_detail_raw", mode = "function")) {
    .mongolstats_cache_env$fetch_detail_memo <- memoise::memoise(.fetch_detail_raw, cache = cache)
  }
  # PXWeb memoized helpers if available
  if (exists(".px_list", mode = "function")) {
    .mongolstats_cache_env$px_list_memo <- memoise::memoise(function(paths, lang) .px_list(paths, lang), cache = cache)
  }
  if (exists(".px_meta", mode = "function")) {
    .mongolstats_cache_env$px_meta_memo <- memoise::memoise(function(paths, table, lang) .px_meta(paths, table, lang), cache = cache)
  }
  .mongolstats_cache_env$enabled <- TRUE
  invisible(dir)
}

#' Disable caching
#' @export
nso_cache_disable <- function() {
  .mongolstats_cache_env$enabled <- FALSE
  invisible(TRUE)
}

#' Clear cached entries
#' @export
nso_cache_clear <- function() {
  if (!is.null(.mongolstats_cache_env$cache)) .mongolstats_cache_env$cache$reset()
  invisible(TRUE)
}

.fetch_itms <- function() {
  if (isTRUE(.mongolstats_cache_env$enabled) && !is.null(.mongolstats_cache_env$fetch_itms_memo)) {
    .mongolstats_cache_env$fetch_itms_memo()
  } else {
    .fetch_itms_raw()
  }
}

.fetch_detail <- function(tbl_id) {
  if (isTRUE(.mongolstats_cache_env$enabled) && !is.null(.mongolstats_cache_env$fetch_detail_memo)) {
    .mongolstats_cache_env$fetch_detail_memo(tbl_id)
  } else {
    .fetch_detail_raw(tbl_id)
  }
}
