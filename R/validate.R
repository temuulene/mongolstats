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
  if (length(selections)) {
    nms <- names(selections)
    if (is.null(nms) || any(is.na(nms)) || any(!nzchar(nms))) {
      cli_abort(
        c(
          "All elements of {.arg selections} must be named.",
          "i" = "Use {.code list(Year = \"2023\", Sex = \"Total\")}."
        ),
        class = "mongolstats_selection_error",
        call = call
      )
    }
    dups <- unique(nms[duplicated(tolower(nms))])
    if (length(dups)) {
      cli_abort(
        c(
          "Duplicated name{?s} in {.arg selections}: {.val {dups}}.",
          "i" = "Combine values into one vector, e.g. {.code list(Year = c(\"2023\", \"2024\"))}."
        ),
        class = "mongolstats_selection_error",
        call = call
      )
    }
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
