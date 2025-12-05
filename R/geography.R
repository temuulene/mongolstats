# Administrative boundaries for Mongolia

#' Mongolia administrative boundaries (sf)
#'
#' Downloads Mongolia boundaries for ADM0/ADM1/ADM2 from the GeoBoundaries API
#' and returns an `sf` object. Results can be cached by the caller as needed.
#'
#' @param level One of "ADM0", "ADM1", "ADM2".
#' @return An `sf` object with polygons for the requested level.
#' @examples
#' \dontrun{
#' # Get aimag (province) boundaries
#' aimags <- mn_boundaries("ADM1")
#' plot(aimags["shapeName"])
#'
#' # Get soum (district) boundaries
#' soums <- mn_boundaries("ADM2")
#' }
#' @export
mn_boundaries <- function(level = c("ADM0", "ADM1", "ADM2")) {
  level <- match.arg(level)
  # Respect offline mode
  if (.nso_offline()) {
    cond <- structure(
      list(
        message = "mn_boundaries() requires network access but mongolstats is in offline mode.",
        call = NULL
      ),
      class = c("mongolstats_offline_error", "error", "condition")
    )
    stop(cond)
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
  sf::st_read(tmp, quiet = TRUE)
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
