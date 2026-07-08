# Sector-like navigation for PXWeb NSO catalog

#' List top-level categories (PXWeb NSO root)
#'
#' Queries the PXWeb API root to return the top-level statistical sectors
#' (e.g., Population, Economy, Environment). Use the returned `id` column
#' with [nso_subsectors()] to drill into sub-categories.
#'
#' @return A tibble with columns `id`, `type`, and `text`.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' sectors <- nso_sectors()
#' head(sectors)
#' @export
nso_sectors <- function() {
  kids <- tryCatch(
    .px_list_cached(character(), lang = .px_lang()),
    error = function(e) NULL
  )
  tibble::as_tibble(kids)
}

#' List children for a given path (PXWeb)
#'
#' Navigates one level deeper in the PXWeb catalogue hierarchy. Pass in a
#' path id obtained from [nso_sectors()] or a previous `nso_subsectors()`
#' call to list its children (sub-sectors or tables).
#'
#' @param subid Path id from `nso_sectors()`/`nso_subsectors()`
#'   (e.g., 'Population, household' or 'Population, household/1_Population, household').
#' @return A tibble with columns: `id`, `type`, `text`.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' sectors <- nso_sectors()
#' nso_subsectors(sectors$id[1])
#' @export
nso_subsectors <- function(subid) {
  if (!is.character(subid) || length(subid) != 1L) {
    cli_abort("{.arg subid} must be a single character string.")
  }
  paths <- if (nzchar(subid)) {
    strsplit(subid, "/", fixed = TRUE)[[1]]
  } else {
    character()
  }
  kids <- tryCatch(
    .px_list_cached(paths, lang = .px_lang()),
    error = function(e) NULL
  )
  tibble::as_tibble(kids)
}
