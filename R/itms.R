## Table discovery via PXWeb

#' List NSO tables
#'
#' Lists every statistical table in the National Statistics Office PXWeb
#' catalogue. The list comes from an index bundled with the package, so it
#' needs no network access; [nso_rebuild_px_index()] refreshes it from the
#' API. Tables that NSO publishes or moves after the index was built are
#' still found by the other functions, which consult the live catalogue.
#'
#' @return A tibble with one row per table and the columns `px_path`
#'   (catalogue folder), `px_file`, `tbl_id`, `tbl_eng_nm` and `tbl_nm`
#'   (English and Mongolian titles), `strt_prd` and `end_prd` (first and last
#'   period), `updated` (when NSO last updated the table, as recorded in the
#'   index) and `list_id` (same as `px_path`).
#' @seealso [nso_search()] to find tables by keyword.
#' @examples
#' tables <- nso_tables()
#' tables
#' @export
nso_tables <- function() {
  # The embedded index is held in memory for the session. It is never put
  # in the disk cache, where a stale copy would outlive package upgrades.
  idx <- .nso_or_offline(.px_index(), tibble::tibble())
  if (!nrow(idx)) {
    return(idx)
  }
  # Maintain partial compatibility: add list_id as px_path
  idx$list_id <- idx$px_path
  idx
}

#' Variables and values of a table
#'
#' Returns every dimension value of a table, with its code and its labels in
#' English and Mongolian. Use it to find the codes or labels to pass in
#' `selections`.
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_0300_001V2").
#' @return A tibble with one row per dimension value and the columns `field`
#'   (dimension name), `itm_id` (value code), `scr_eng` and `scr_mn` (English
#'   and Mongolian labels), `px_path` and `px_file`. In offline mode (see
#'   [nso_offline_enable()]) an empty tibble is returned; failed requests
#'   raise an error of class `mongolstats_http_error`.
#' @seealso [nso_dims()] for one row per dimension, [nso_dim_values()] for
#'   the values of one dimension.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' vars <- nso_variables("DT_NSO_0300_001V2")
#' vars
#' @export
nso_variables <- function(tbl_id) {
  check_tbl_id(tbl_id)
  # Table metadata is disk-cached by .px_meta_cached() when caching is on
  nso_px_variables(tbl_id)
}

#' List tables under a sector or sub-sector (PXWeb path)
#'
#' Filters the table catalogue to the tables in a given sector or
#' sub-sector, as returned by [nso_sectors()] or [nso_subsectors()],
#' including the tables in its sub-folders.
#'
#' @param list_id Path string from `nso_sectors()`/`nso_subsectors()` `id`.
#' @return A tibble of the tables in the sector and its sub-folders.
#' @examples
#' nso_itms_by_sector("Population, household")
#' @export
nso_itms_by_sector <- function(list_id) {
  if (!is.character(list_id) || length(list_id) != 1L || is.na(list_id)) {
    cli_abort(
      "{.arg list_id} must be a single character string, not {.obj_type_friendly {list_id}}."
    )
  }
  .in_sector(nso_tables(), list_id)
}

# Tables in folder `path` or any folder below it
.in_sector <- function(tables, path) {
  if (!nrow(tables)) {
    return(tables)
  }
  path <- sub("/+$", "", path)
  keep <- tables$px_path == path | startsWith(tables$px_path, paste0(path, "/"))
  tables[keep, , drop = FALSE]
}

# Superseded names -------------------------------------------------------

#' Superseded discovery functions
#'
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' These are the original names of three discovery functions. They keep
#' working, but new code should use the newer names:
#'
#' * `nso_itms()` is [nso_tables()].
#' * `nso_itms_detail()` is [nso_variables()].
#' * `nso_itms_search(query)` is [`nso_search(query, fixed = TRUE)`][nso_search()].
#'
#' @param tbl_id Table identifier.
#' @param query A single keyword, matched literally and case-insensitively.
#' @param fields Columns of [nso_tables()] to search.
#' @return As the newer functions.
#' @keywords internal
#' @name nso_itms
NULL

#' @rdname nso_itms
#' @export
nso_itms <- function() nso_tables()

#' @rdname nso_itms
#' @export
nso_itms_detail <- function(tbl_id) nso_variables(tbl_id)

#' @rdname nso_itms
#' @export
nso_itms_search <- function(query, fields = c("tbl_eng_nm", "tbl_nm")) {
  nso_search(query, fields = fields, fixed = TRUE)
}
