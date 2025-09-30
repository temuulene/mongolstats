# Table discovery endpoints

#' List available NSO tables
#'
#' Returns a tibble of table metadata with English and Mongolian names,
#' start/end periods, and period settings.
#'
#' @return tibble with columns like `list_id`, `tbl_id`, `tbl_nm`, `tbl_eng_nm`,
#'   `unit_id`, `cd_nm`, `cd_eng_nm`, `strt_prd`, `end_prd`, `prd_se`, `lst_chn_de`.
#' @export
#' @keywords internal
#' @noRd
.fetch_itms_raw <- function() {
  resp <- .nso_req("api/Itms", query = list(type = "json")) |>
    httr2::req_perform()
  txt <- httr2::resp_body_string(resp)
  tibble::as_tibble(jsonlite::fromJSON(txt, simplifyVector = TRUE))
}

#' List available NSO tables
#' @export
nso_itms <- function() .fetch_itms()

#' Get variable codes for a table
#'
#' Fetches the variable fields (e.g., CODE, CODE1, CODE2) and their allowed
#' item codes and labels for a given `tbl_id`.
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_2600_004V1").
#' @return tibble with columns `field`, `itm_id`, `up_itm_id`, `scr_mn`, `scr_eng`.
#' @export
#' @keywords internal
#' @noRd
.fetch_detail_raw <- function(tbl_id) {
  res <- .nso_get(sprintf("api/Itms/%s", tbl_id), query = list(type = "json"))
  obj <- res$obj
  if (is.null(obj) || length(obj) == 0) return(tibble::tibble())
  purrr::map_dfr(obj, function(o) {
    items <- o$itm
    if (is.null(items) || length(items) == 0) return(NULL)
    tibble::tibble(
      field = o$field %||% NA_character_,
      itm_id = vapply(items, function(i) i$itm_id %||% NA_character_, character(1)),
      up_itm_id = vapply(items, function(i) i$up_itm_id %||% NA_character_, character(1)),
      scr_mn = vapply(items, function(i) i$scr_mn %||% NA_character_, character(1)),
      scr_eng = vapply(items, function(i) i$scr_eng %||% NA_character_, character(1))
    )
  })
}

#' Get variable codes for a table
#' @param tbl_id Table identifier (e.g., "DT_NSO_2600_004V1").
#' @return tibble with columns `field`, `itm_id`, `up_itm_id`, `scr_mn`, `scr_eng`.
#' @export
nso_itms_detail <- function(tbl_id) {
  stopifnot(is.character(tbl_id), length(tbl_id) == 1L)
  .fetch_detail(tbl_id)
}

#' Search tables by keyword
#'
#' @param query Search string (case-insensitive).
#' @param fields Character vector of fields to search within.
#' @return tibble filtered to matching tables.
#' @export
nso_itms_search <- function(query, fields = c("tbl_eng_nm", "tbl_nm")) {
  stopifnot(is.character(query), length(query) == 1L)
  itms <- .fetch_itms()
  # Build combined predicate across requested fields
  pred <- Reduce(`|`, lapply(fields, function(f) {
    if (f %in% names(itms)) {
      stringr::str_detect(stringr::str_to_lower(itms[[f]]), stringr::str_to_lower(query))
    } else {
      FALSE
    }
  }))
  itms[pred %||% FALSE, , drop = FALSE]
}

#' List tables under a sector or sub-sector
#'
#' @param list_id A `list_id` from `nso_sectors()` or `nso_subsectors()`.
#' @return tibble of tables in the sector.
#' @export
nso_itms_by_sector <- function(list_id) {
  itms <- .fetch_itms()
  itms[itms$list_id == list_id, , drop = FALSE]
}

# null-coalescing helper
`%||%` <- function(x, y) if (is.null(x)) y else x
