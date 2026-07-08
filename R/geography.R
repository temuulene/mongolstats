# Administrative boundaries for Mongolia

# In-memory session cache: boundaries are multi-megabyte downloads and do
# not change within a session.
.mn_boundaries_env <- new.env(parent = emptyenv())

#' Mongolia administrative boundaries (sf)
#'
#' Downloads Mongolia boundaries for ADM0/ADM1/ADM2 from the GeoBoundaries API
#' and returns an `sf` object. Results are cached in memory for the session,
#' so repeated calls (including via [mn_join_by_name()]) do not re-download.
#'
#' @param level One of "ADM0", "ADM1", "ADM2".
#' @param refresh If TRUE, bypass the session cache and download again.
#' @return An `sf` object with polygons for the requested level.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' # Get aimag (province) boundaries
#' aimags <- mn_boundaries("ADM1")
#' head(aimags)
#' @export
mn_boundaries <- function(level = c("ADM0", "ADM1", "ADM2"), refresh = FALSE) {
  level <- match.arg(level)
  if (!isTRUE(refresh)) {
    hit <- .mn_boundaries_env[[level]]
    if (!is.null(hit)) {
      return(hit)
    }
  }
  # Respect offline mode
  if (.nso_offline()) {
    cli_abort(
      "mn_boundaries() requires network access but mongolstats is in offline mode.",
      class = "mongolstats_offline_error"
    )
  }
  url <- .gb_gj_url("MNG", level)
  tmp <- tempfile(fileext = ".geojson")
  req <- httr2::request(url) |>
    httr2::req_user_agent(.nso_user_agent()) |>
    httr2::req_timeout(.nso_timeout()) |>
    httr2::req_retry(
      max_tries = .nso_retry_tries(),
      backoff = .nso_retry_backoff()
    )
  httr2::req_perform(req, path = tmp)
  on.exit(try(unlink(tmp), silent = TRUE), add = TRUE)
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
  res <- httr2::request(api) |>
    httr2::req_user_agent(.nso_user_agent()) |>
    .nso_perform() |>
    httr2::resp_body_json()
  res$gjDownloadURL
}
