## Table discovery via PXWeb

#' List available NSO tables (PXWeb)
#'
#' Returns a tibble of all available tables in the NSO PXWeb catalog.
#'
#' @return A tibble with columns: `px_path`, `px_file`, `tbl_id`, `tbl_eng_nm`,
#'   `tbl_nm`, `strt_prd`, `end_prd`, `list_id`.
#' @examples
#' \dontrun{
#' # List all available tables
#' tables <- nso_itms()
#' head(tables)
#'
#' # Filter to find specific tables
#' tables |> dplyr::filter(grepl("population", tbl_eng_nm, ignore.case = TRUE))
#' }
#' @export
nso_itms <- function() {
  # use cached path when available
  idx <- tryCatch(.fetch_itms(), error = function(e) tibble::tibble())
  if (!nrow(idx)) {
    return(idx)
  }
  # Maintain partial compatibility: add list_id as px_path
  idx$list_id <- idx$px_path
  idx
}

#' Get variable codes for a table (PXWeb)
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_0300_001V2").
#' @return A tibble with variable metadata.
#' @examples
#' \dontrun{
#' # Get variables for population table
#' vars <- nso_itms_detail("DT_NSO_0300_001V2")
#' vars
#' }
#' @export
nso_itms_detail <- function(tbl_id) {
  stopifnot(is.character(tbl_id), length(tbl_id) == 1L)
  # use cached path when available
  .fetch_detail(tbl_id)
}

#' Search tables by keyword (PXWeb)
#'
#' @param query A single keyword string to search for (case-insensitive).
#' @param fields Character vector of column names to search within
#'   (defaults to English and Mongolian titles).
#' @return A tibble of matching tables.
#' @examples
#' \dontrun{
#' # Search for infant mortality tables
#' nso_itms_search("infant mortality")
#'
#' # Search for GDP tables
#' nso_itms_search("GDP")
#' }
#' @export
nso_itms_search <- function(query, fields = c("tbl_eng_nm", "tbl_nm")) {
  stopifnot(is.character(query), length(query) == 1L)
  itms <- nso_itms()
  if (!nrow(itms)) {
    return(itms)
  }
  pred <- Reduce(
    `|`,
    lapply(fields, function(f) {
      if (f %in% names(itms)) {
        stringr::str_detect(
          stringr::str_to_lower(itms[[f]] %||% ""),
          stringr::str_to_lower(query)
        )
      } else {
        FALSE
      }
    })
  )
  itms[pred & !is.na(pred), , drop = FALSE]
}

#' List tables under a sector or sub-sector (PXWeb path)
#' @param list_id Path string from `nso_sectors()`/`nso_subsectors()` `id`.
#' @export
nso_itms_by_sector <- function(list_id) {
  itms <- nso_itms()
  itms[itms$px_path == list_id | itms$list_id == list_id, , drop = FALSE]
}

# Note: %||% operator is defined in utils.R


# Aliases ---------------------------------------------------------------

#' @rdname nso_itms
#' @export
nso_tables <- function() nso_itms()

#' @rdname nso_itms_detail
#' @export
nso_variables <- function(tbl_id) nso_itms_detail(tbl_id)
