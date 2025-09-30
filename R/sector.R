# Sector and sub-sector discovery

#' List top-level sectors
#'
#' @return tibble with sector `list_id`, names and flags.
#' @export
nso_sectors <- function() {
  res <- .nso_get("api/Sector", query = list(type = "json"))
  tibble::as_tibble(res$value)
}

#' List sub-sectors for a sector
#'
#' @param subid Sector identifier from `nso_sectors()` `list_id`.
#' @return tibble of sub-sectors.
#' @export
nso_subsectors <- function(subid) {
  stopifnot(is.character(subid), length(subid) == 1L)
  res <- .nso_get("api/Sector", query = list(subid = subid, type = "json"))
  tibble::as_tibble(res$value)
}

