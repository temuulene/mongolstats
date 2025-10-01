.tidy1212_cache_env <- new.env(parent = emptyenv())
.tidy1212_cache_env$enabled <- FALSE
.tidy1212_cache_env$cache <- NULL
.tidy1212_cache_env$fetch_itms_memo <- NULL
.tidy1212_cache_env$fetch_detail_memo <- NULL

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
  .tidy1212_cache_env$cache <- cache
  .tidy1212_cache_env$fetch_itms_memo <- memoise::memoise(.fetch_itms_raw, cache = cache)
  .tidy1212_cache_env$fetch_detail_memo <- memoise::memoise(.fetch_detail_raw, cache = cache)
  .tidy1212_cache_env$enabled <- TRUE
  invisible(dir)
}

#' Disable caching
#' @export
nso_cache_disable <- function() {
  .tidy1212_cache_env$enabled <- FALSE
  invisible(TRUE)
}

#' Clear cached entries
#' @export
nso_cache_clear <- function() {
  if (!is.null(.tidy1212_cache_env$cache)) .tidy1212_cache_env$cache$reset()
  invisible(TRUE)
}

.fetch_itms <- function() {
  if (isTRUE(.tidy1212_cache_env$enabled) && !is.null(.tidy1212_cache_env$fetch_itms_memo)) {
    .tidy1212_cache_env$fetch_itms_memo()
  } else {
    .fetch_itms_raw()
  }
}

.fetch_detail <- function(tbl_id) {
  if (isTRUE(.tidy1212_cache_env$enabled) && !is.null(.tidy1212_cache_env$fetch_detail_memo)) {
    .tidy1212_cache_env$fetch_detail_memo(tbl_id)
  } else {
    .fetch_detail_raw(tbl_id)
  }
}
