# Sector-like navigation for PXWeb NSO catalog

#' List top-level categories (PXWeb NSO root)
#' @return tibble with `id`, `type`, `text`
#' @export
nso_sectors <- function() {
  kids <- tryCatch(.px_list_cached(character(), lang = .px_lang()), error = function(e) NULL)
  tibble::as_tibble(kids)
}

#' List children for a given path (PXWeb)
#' @param subid Path id from `nso_sectors()`/`nso_subsectors()` (e.g., 'Population, household' or 'Population, household/1_Population, household')
#' @export
nso_subsectors <- function(subid) {
  stopifnot(is.character(subid), length(subid) == 1L)
  paths <- if (nzchar(subid)) strsplit(subid, "/", fixed = TRUE)[[1]] else character()
  kids <- tryCatch(.px_list_cached(paths, lang = .px_lang()), error = function(e) NULL)
  tibble::as_tibble(kids)
}
