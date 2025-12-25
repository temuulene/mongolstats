.mongolstats_cache_env <- new.env(parent = emptyenv())
.mongolstats_cache_env$enabled <- FALSE
.mongolstats_cache_env$cache <- NULL
.mongolstats_cache_env$dir <- NULL
.mongolstats_cache_env$fetch_itms_memo <- NULL
.mongolstats_cache_env$fetch_detail_memo <- NULL
.mongolstats_cache_env$px_list_memo <- NULL
.mongolstats_cache_env$px_meta_memo <- NULL

#' Enable or configure caching
#'
#' Caches table lists and codebooks on disk to speed up repeated calls.
#' Optionally set a time-to-live (TTL) for cache entries.
#'
#' @param dir Directory for cache; defaults to user cache dir.
#' @param ttl Optional TTL in seconds for cached entries (applies to the
#'   disk cache). If `NULL`, entries persist until cleared.
#' @return Cache directory path (invisibly).
#' @export
nso_cache_enable <- function(dir = NULL, ttl = NULL) {
  if (
    !requireNamespace("memoise", quietly = TRUE) ||
      !requireNamespace("cachem", quietly = TRUE) ||
      !requireNamespace("rappdirs", quietly = TRUE)
  ) {
    stop("Enable caching requires memoise, cachem, rappdirs packages.")
  }
  if (is.null(dir)) {
    # Namespace under mongolstats and include a cache version for safe upgrades
    dir <- file.path(rappdirs::user_cache_dir("mongolstats"), "v1")
  }
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  }
  cache <- if (is.null(ttl)) {
    cachem::cache_disk(dir)
  } else {
    cachem::cache_disk(dir, max_age = ttl)
  }
  .mongolstats_cache_env$cache <- cache
  .mongolstats_cache_env$dir <- dir
  if (exists(".fetch_itms_raw", mode = "function")) {
    .mongolstats_cache_env$fetch_itms_memo <- memoise::memoise(
      .fetch_itms_raw,
      cache = cache
    )
  }
  if (exists(".fetch_detail_raw", mode = "function")) {
    .mongolstats_cache_env$fetch_detail_memo <- memoise::memoise(
      .fetch_detail_raw,
      cache = cache
    )
  }
  # PXWeb memoized helpers if available
  if (exists(".px_list", mode = "function")) {
    .mongolstats_cache_env$px_list_memo <- memoise::memoise(
      function(paths, lang) .px_list(paths, lang),
      cache = cache
    )
  }
  if (exists(".px_meta", mode = "function")) {
    .mongolstats_cache_env$px_meta_memo <- memoise::memoise(
      function(paths, table, lang) .px_meta(paths, table, lang),
      cache = cache
    )
  }
  .mongolstats_cache_env$enabled <- TRUE
  invisible(dir)
}

#' Disable caching
#' @return No return value, called for side effects.
#' @export
nso_cache_disable <- function() {
  .mongolstats_cache_env$enabled <- FALSE
  invisible(TRUE)
}

#' Clear cached entries
#' @return No return value, called for side effects.
#' @export
nso_cache_clear <- function() {
  if (!is.null(.mongolstats_cache_env$cache)) {
    # Some environments may have restrictive permissions on cache dirs;
    # reset best-effort and suppress warnings to keep this operation silent.
    try(suppressWarnings(.mongolstats_cache_env$cache$reset()), silent = TRUE)
  }
  invisible(TRUE)
}

#' Cache status
#'
#' Report current cache configuration and basic stats.
#'
#' @return A list with `enabled`, `dir`, and `has_cache`.
#' @export
nso_cache_status <- function() {
  list(
    enabled = isTRUE(.mongolstats_cache_env$enabled),
    dir = .mongolstats_cache_env$dir,
    has_cache = !is.null(.mongolstats_cache_env$cache)
  )
}

.fetch_itms <- function() {
  if (
    isTRUE(.mongolstats_cache_env$enabled) &&
      !is.null(.mongolstats_cache_env$fetch_itms_memo)
  ) {
    .mongolstats_cache_env$fetch_itms_memo()
  } else {
    .fetch_itms_raw()
  }
}

.fetch_detail <- function(tbl_id) {
  if (
    isTRUE(.mongolstats_cache_env$enabled) &&
      !is.null(.mongolstats_cache_env$fetch_detail_memo)
  ) {
    .mongolstats_cache_env$fetch_detail_memo(tbl_id)
  } else {
    .fetch_detail_raw(tbl_id)
  }
}
