# Query builder and fetch helpers

#' Create a PXWeb query object
#'
#' Builds a lightweight query object that records a table id and selections.
#' Use [nso_fetch()] to execute it, or [as_px_query()] to inspect the
#' underlying PXWeb body.
#'
#' @param tbl_id Table identifier, e.g. "DT_NSO_0300_001V2".
#' @param selections Named list mapping dimension labels (e.g., Year, Sex)
#'   to desired codes or labels.
#' @return An object of class `nso_query`.
#' @examples
#' # Create a query object (does not require network)
#' q <- nso_query("DT_NSO_0300_001V2", list(Year = "2023", Sex = "Total"))
#' print(q)
#' @export
nso_query <- function(tbl_id, selections = list()) {
  check_tbl_id(tbl_id)
  check_selections(selections)
  structure(list(tbl_id = tbl_id, selections = selections), class = "nso_query")
}

#' Print an nso_query object
#'
#' Displays a human-readable summary of the query, including the table
#' identifier and the first few dimension selections.
#'
#' @param x An `nso_query` object created by [nso_query()].
#' @param ... Additional arguments passed to print methods (ignored).
#' @return `x`, invisibly.
#' @keywords internal
#' @export
print.nso_query <- function(x, ...) {
  cat("<nso_query>\n", sep = "")
  cat("  tbl_id    : ", x$tbl_id, "\n", sep = "")
  nsel <- length(x$selections)
  cat(
    "  selections: ",
    nsel,
    if (nsel == 1) " dimension\n" else " dimensions\n",
    sep = ""
  )
  if (nsel) {
    prev <- utils::head(names(x$selections), 5)
    for (nm in prev) {
      vals <- as.character(utils::head(x$selections[[nm]], 3))
      cat(
        "    - ",
        nm,
        ": ",
        paste(vals, collapse = ", "),
        if (length(x$selections[[nm]]) > 3) ", ..." else "",
        "\n",
        sep = ""
      )
    }
  }
  invisible(x)
}

# Internal: build a PXWeb JSON body from selections
.px_build_body <- function(tbl_id, selections, lang = .px_lang()) {
  resolved <- .px_resolve_table(tbl_id)
  meta <- .px_meta_cached(resolved$paths, resolved$px_file, lang = lang)
  vars <- meta$variables
  resolved_sel <- .px_map_selections(vars, selections)
  q <- lapply(vars, function(v) {
    list(
      code = v$code,
      selection = list(
        filter = "item",
        values = I(as.character(resolved_sel[[as.character(v$code)]]))
      )
    )
  })
  list(query = q, response = list(format = "json"))
}

#' Convert a query to a PXWeb body
#'
#' @param x An `nso_query` object.
#' @param lang PX language: "en" or "mn" (defaults to current option).
#' @return A list suitable to send as JSON body to PXWeb.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' q <- nso_query("DT_NSO_0300_001V2", list(Year = "2023"))
#' body <- as_px_query(q)
#' @export
as_px_query <- function(x, lang = .px_lang()) {
  if (!inherits(x, "nso_query")) {
    cli_abort("{.arg x} must be an {.cls nso_query} object.")
  }
  .px_build_body(x$tbl_id, x$selections, lang = lang)
}

#' Fetch a query and return a tibble
#'
#' Executes an `nso_query` and returns a tidy tibble with one column per
#' dimension and a numeric `value` column. Use `labels` to add `_en`/`_mn`
#' columns for each dimension.
#'
#' @param x An `nso_query` object.
#' @param labels One of "code", "en", "mn", or "both". "none" is accepted
#'   as an alias for "code" (matching [nso_data()]). Defaults to the
#'   `mongolstats.default_labels` option, like [nso_data()].
#' @param value_name Name of the numeric value column in the result (default: "value").
#' @param include_raw If TRUE, attach the raw PX payload as attribute `px_raw`.
#' @return A tibble.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' q <- nso_query("DT_NSO_0300_001V2", list(Year = "2023"))
#' data <- nso_fetch(q)
#' head(data)
#' @export
nso_fetch <- function(
  x,
  labels = c("code", "en", "mn", "both"),
  value_name = getOption("mongolstats.value_name", "value"),
  include_raw = getOption("mongolstats.attach_raw", FALSE)
) {
  if (!inherits(x, "nso_query")) {
    cli_abort("{.arg x} must be an {.cls nso_query} object.")
  }
  if (missing(labels)) {
    labels <- getOption("mongolstats.default_labels", "code")
  }
  # Accept the nso_data() vocabulary too: "none" is an alias for "code"
  if (identical(labels, "none")) labels <- "code"
  labels <- match.arg(labels)
  # Map 'code' -> existing 'none' for backwards compatibility
  lab <- if (identical(labels, "code")) "none" else labels
  nso_data(
    tbl_id = x$tbl_id,
    selections = x$selections,
    labels = lab,
    value_name = value_name,
    include_raw = include_raw
  )
}
