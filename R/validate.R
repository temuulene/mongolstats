# Internal argument validation helpers
# These replace repeated stopifnot() patterns throughout the package.

#' @keywords internal
#' @noRd
check_tbl_id <- function(tbl_id, call = rlang::caller_env()) {
  if (!is.character(tbl_id) || length(tbl_id) != 1L) {
    cli_abort(
      "{.arg tbl_id} must be a single character string, not {.obj_type_of {tbl_id}}.",
      call = call
    )
  }
}

#' @keywords internal
#' @noRd
check_selections <- function(selections, call = rlang::caller_env()) {
  if (!is.list(selections)) {
    cli_abort(
      c(
        "{.arg selections} must be a named list of values.",
        "i" = "Use {.code list(Year = \"2023\", Sex = \"Total\")}."
      ),
      call = call
    )
  }
}

#' @keywords internal
#' @noRd
check_query <- function(query, call = rlang::caller_env()) {
  if (!is.character(query) || length(query) != 1L) {
    cli_abort(
      "{.arg query} must be a single character string, not {.obj_type_of {query}}.",
      call = call
    )
  }
}
