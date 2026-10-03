# Administrative boundaries for Mongolia

# In-memory session cache: boundaries are multi-megabyte downloads and do
# not change within a session.
.mn_boundaries_env <- new.env(parent = emptyenv())

#' Mongolia administrative boundaries (sf)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `mn_boundaries()` was deprecated in mongolstats 0.3.0. Use the mongolmaps
#' package instead: [mongolmaps::mn_admin()] and its shortcuts
#' (`mn_country()`, `mn_aimags()`, `mn_soums()`, ...) ship boundaries that
#' carry NSO codes, need no download, and join to NSO tables by code with
#' [mongolmaps::mn_join()].
#'
#' `mn_boundaries()` downloads boundaries for ADM0/ADM1/ADM2 from the
#' geoBoundaries API and returns an `sf` object (the sf package must be
#' installed). Results are cached in memory for the session.
#'
#' @param level One of "ADM0", "ADM1", "ADM2".
#' @param refresh If TRUE, bypass the session cache and download again.
#' @return An `sf` object with polygons for the requested level. Failed
#'   downloads raise an error of class `mongolstats_http_error`.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet() && rlang::is_installed("sf")
#' aimags <- mn_boundaries("ADM1")
#' # ->
#' if (rlang::is_installed("mongolmaps")) {
#'   aimags <- mongolmaps::mn_aimags()
#' }
#' @export
mn_boundaries <- function(level = c("ADM0", "ADM1", "ADM2"), refresh = FALSE) {
  lifecycle::deprecate_soft("0.3.0", "mn_boundaries()", "mongolmaps::mn_admin()")
  level <- match.arg(level)
  if (!isTRUE(refresh)) {
    hit <- .mn_boundaries_env[[level]]
    if (!is.null(hit)) {
      return(hit)
    }
  }
  rlang::check_installed("sf", reason = "to read boundary files.")
  # Respect offline mode
  if (.nso_offline()) {
    cli_abort(
      "mn_boundaries() requires network access but mongolstats is in offline mode.",
      class = "mongolstats_offline_error"
    )
  }
  url <- .gb_gj_url("MNG", level)
  tmp <- tempfile(fileext = ".geojson")
  on.exit(try(unlink(tmp), silent = TRUE), add = TRUE)
  .nso_perform(.nso_request(url), path = tmp)
  g <- sf::st_read(tmp, quiet = TRUE)
  .mn_boundaries_env[[level]] <- g
  g
}

.gb_gj_url <- function(iso3, level) {
  api <- sprintf(
    "https://www.geoboundaries.org/api/current/gbOpen/%s/%s",
    iso3,
    level
  )
  res <- .nso_request(api) |>
    .nso_perform() |>
    httr2::resp_body_json()
  url <- res$gjDownloadURL
  if (!is.character(url) || length(url) != 1L || !nzchar(url)) {
    cli_abort(
      c(
        "GeoBoundaries returned no download URL for {.val {iso3}} {.val {level}}.",
        "i" = "The API response may have changed; see {.url {api}}."
      ),
      class = "mongolstats_http_error"
    )
  }
  url
}
