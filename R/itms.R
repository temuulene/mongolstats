## Table discovery via PXWeb

#' List available NSO tables (PXWeb)
#'
#' Retrieves the full catalogue of available statistical tables from the
#' National Statistics Office PXWeb API. Uses the embedded index by default
#' for fast startup; call [nso_rebuild_px_index()] to refresh from the API.
#'
#' @return A tibble with columns: `px_path`, `px_file`, `tbl_id`, `tbl_eng_nm`,
#'   `tbl_nm`, `strt_prd`, `end_prd`, `list_id`.
#' @examplesIf curl::has_internet()
#' # List all available tables
#' tables <- nso_itms()
#' head(tables)
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
#' Returns detailed variable metadata for a single table, including field
#' names, item IDs, and labels in English and Mongolian when available.
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_0300_001V2").
#' @return A tibble with variable metadata.
#' @examplesIf curl::has_internet()
#' vars <- nso_itms_detail("DT_NSO_0300_001V2")
#' vars
#' @export
nso_itms_detail <- function(tbl_id) {
  check_tbl_id(tbl_id)
  # use cached path when available
  .fetch_detail(tbl_id)
}

#' Search tables by keyword (PXWeb)
#'
#' Performs a case-insensitive keyword search across the table catalogue,
#' matching `query` against table names in English and/or Mongolian.
#'
#' @param query A single keyword string to search for (case-insensitive).
#' @param fields Character vector of column names to search within
#'   (defaults to English and Mongolian titles).
#' @return A tibble of matching tables.
#' @examplesIf curl::has_internet()
#' # Search for population tables
#' nso_itms_search("population")
#' @export
nso_itms_search <- function(query, fields = c("tbl_eng_nm", "tbl_nm")) {
  check_query(query)
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
#'
#' Filters the table catalogue to only those belonging to a given sector
#' or sub-sector path, as returned by [nso_sectors()] or [nso_subsectors()].
#'
#' @param list_id Path string from `nso_sectors()`/`nso_subsectors()` `id`.
#' @return A tibble of tables matching the specified sector path.
#' @examplesIf curl::has_internet()
#' sectors <- nso_sectors()
#' tables <- nso_itms_by_sector(sectors$id[1])
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
