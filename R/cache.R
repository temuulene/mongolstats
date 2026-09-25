.mongolstats_cache_env <- new.env(parent = emptyenv())
.mongolstats_cache_env$enabled <- FALSE
.mongolstats_cache_env$cache <- NULL
.mongolstats_cache_env$dir <- NULL
.mongolstats_cache_env$px_list_memo <- NULL
.mongolstats_cache_env$px_meta_memo <- NULL

#' Enable or configure caching
#'
#' Caches PXWeb catalogue listings and table metadata (codebooks) on disk to
#' speed up repeated calls, including across R sessions. Entries are keyed by
#' the PXWeb base URL, database, and language, so changing
#' `mongolstats.px_base_url` or `mongolstats.px_db` never returns another
#' server's metadata. Data fetched with [nso_data()] is not cached.
#' Optionally set a time-to-live (TTL) for cache entries.
#'
#' @param dir Directory for cache; defaults to user cache dir.
#' @param ttl Optional TTL in seconds for cached entries (applies to the
#'   disk cache). If `NULL`, entries persist until cleared.
#' @return Cache directory path (invisibly).
#' @examplesIf rlang::is_installed(c("memoise", "cachem", "rappdirs"))
#' # Enable caching in a temporary directory (for demo purposes)
#' cache_dir <- nso_cache_enable(dir = tempdir())
#'
#' # Check status
#' nso_cache_status()
#'
#' # Disable when done
#' nso_cache_disable()
#' @export
nso_cache_enable <- function(dir = NULL, ttl = NULL) {
  if (
    !requireNamespace("memoise", quietly = TRUE) ||
      !requireNamespace("cachem", quietly = TRUE) ||
      !requireNamespace("rappdirs", quietly = TRUE)
  ) {
    cli_abort(c(
      "Caching requires {.pkg memoise}, {.pkg cachem}, and {.pkg rappdirs}.",
      "i" = "Install them with {.code install.packages(c('memoise', 'cachem', 'rappdirs'))}."
    ))
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
  # `base_url` and `db` are unused in the bodies (the requests read the same
  # options); they exist so memoise includes the server in the cache key.
  .mongolstats_cache_env$px_list_memo <- memoise::memoise(
    function(paths, lang, base_url, db) .px_list(paths, lang),
    cache = cache
  )
  .mongolstats_cache_env$px_meta_memo <- memoise::memoise(
    function(paths, table, lang, base_url, db) .px_meta(paths, table, lang),
    cache = cache
  )
  .mongolstats_cache_env$enabled <- TRUE
  invisible(dir)
}

#' Disable caching
#' @return Invisibly, `TRUE`.
#' @examples
#' nso_cache_disable()
#' @export
nso_cache_disable <- function() {
  .mongolstats_cache_env$enabled <- FALSE
  invisible(TRUE)
}

#' Clear cached entries
#' @return Invisibly, `TRUE`.
#' @examples
#' nso_cache_clear()
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
#' @examples
#' nso_cache_status()
#' @export
nso_cache_status <- function() {
  list(
    enabled = isTRUE(.mongolstats_cache_env$enabled),
    dir = .mongolstats_cache_env$dir,
    has_cache = !is.null(.mongolstats_cache_env$cache)
  )
}
