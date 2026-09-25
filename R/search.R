# High-level search utility

# Shared predicate for catalogue searches over selected fields.
# `fixed = TRUE` treats `query` as a literal keyword; otherwise it is a
# case-insensitive regex. Rows where every searched field is NA are dropped.
.search_index <- function(itms, query, fields, fixed = FALSE) {
  if (!nrow(itms)) {
    return(itms)
  }
  # Match case-insensitively rather than lowercasing the query: lowercasing
  # a regex changes its escapes (\S "non-space" would become \s "space").
  pattern <- if (fixed) {
    stringr::fixed(query, ignore_case = TRUE)
  } else {
    stringr::regex(query, ignore_case = TRUE)
  }
  pred <- Reduce(
    `|`,
    lapply(fields, function(f) {
      if (f %in% names(itms)) {
        stringr::str_detect(itms[[f]], pattern)
      } else {
        FALSE
      }
    })
  )
  itms[pred & !is.na(pred), , drop = FALSE]
}

#' Search NSO tables
#'
#' Performs a case-insensitive regex search across the table catalogue,
#' optionally filtered to a specific sector. Searches table names in
#' English and/or Mongolian by default. For a literal keyword search use
#' [nso_itms_search()].
#'
#' @param query Search string (regex, case-insensitive).
#' @param sector Optional sector/subsector `list_id` to filter results.
#' @param fields Character vector of fields to search within.
#' @return Tibble of matching tables.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' nso_search("population")
#' @export
nso_search <- function(
  query,
  sector = NULL,
  fields = c("tbl_eng_nm", "tbl_nm")
) {
  check_query(query)
  itms <- nso_itms()
  if (!is.null(sector)) {
    itms <- itms[
      itms$px_path == sector | itms$list_id == sector, ,
      drop = FALSE
    ]
  }
  .search_index(itms, query, fields, fixed = FALSE)
}
