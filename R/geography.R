# Administrative boundaries for Mongolia

#' Mongolia administrative boundaries (sf)
#'
#' Downloads Mongolia boundaries for ADM0/ADM1/ADM2 from the GeoBoundaries API
#' and returns an `sf` object. Results can be cached by the caller as needed.
#'
#' @param level One of "ADM0", "ADM1", "ADM2".
#' @return An `sf` object with polygons for the requested level.
#' @export
mn_boundaries <- function(level = c("ADM0", "ADM1", "ADM2")) {
  level <- match.arg(level)
  url <- .gb_gj_url("MNG", level)
  tmp <- tempfile(fileext = ".geojson")
  utils::download.file(url, tmp, quiet = TRUE, mode = "wb")
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
