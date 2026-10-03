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
#' Searches table titles in the catalogue (see [nso_tables()]),
#' case-insensitively, in English and Mongolian by default. `query` is a
#' regular expression unless `fixed = TRUE`.
#'
#' @param query Search string (regex, case-insensitive).
#' @param sector Optional sector or sub-sector path (an `id` from
#'   [nso_sectors()] or [nso_subsectors()]); only tables in it or its
#'   sub-folders are searched.
#' @param fields Character vector of fields to search within.
#' @param fixed If `TRUE`, match `query` literally instead of as a regular
#'   expression, so characters such as `+` or `(` need no escaping.
#' @return Tibble of matching tables.
#' @examples
#' nso_search("population")
#' nso_search("infant mortality", sector = "Education, health")
#' nso_search("c++", fixed = TRUE)
#' @export
nso_search <- function(
  query,
  sector = NULL,
  fields = c("tbl_eng_nm", "tbl_nm"),
  fixed = FALSE
) {
  check_query(query)
  if (!is.logical(fixed) || length(fixed) != 1L || is.na(fixed)) {
    cli_abort("{.arg fixed} must be {.code TRUE} or {.code FALSE}.")
  }
  itms <- nso_tables()
  if (!is.null(sector)) {
    itms <- .in_sector(itms, sector)
  }
  .search_index(itms, query, fields, fixed = fixed)
}
