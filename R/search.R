# High-level search utility

#' Search NSO tables
#'
#' @param query Search string (regex, case-insensitive).
#' @param sector Optional sector/subsector `list_id` to filter results.
#' @param fields Character vector of fields to search within.
#' @return Tibble of matching tables.
#' @export
nso_search <- function(query, sector = NULL, fields = c("tbl_eng_nm", "tbl_nm")) {
  stopifnot(is.character(query), length(query) == 1L)
  itms <- nso_itms()
  if (!is.null(sector)) itms <- itms[itms$list_id == sector, , drop = FALSE]
  pred <- Reduce(`|`, lapply(fields, function(f) {
    if (f %in% names(itms)) {
      stringr::str_detect(stringr::str_to_lower(itms[[f]]), stringr::str_to_lower(query))
    } else {
      FALSE
    }
  }))
  itms[isTRUE(pred) %||% FALSE, , drop = FALSE]
}

