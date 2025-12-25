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
  stopifnot(is.character(tbl_id), length(tbl_id) == 1L)
  if (!is.list(selections)) {
    stop("`selections` must be a named list of values")
  }
  structure(list(tbl_id = tbl_id, selections = selections), class = "nso_query")
}

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
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) {
    tbl_id
  } else {
    paste0(tbl_id, ".px")
  }
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) {
    stop("Table not found in PXWeb index: ", tbl_id)
  }
  paths <- if (nzchar(row$px_path[1])) {
    strsplit(row$px_path[1], "/", fixed = TRUE)[[1]]
  } else {
    character()
  }
  meta <- .px_meta_cached(paths, px_file, lang = lang)
  vars <- meta$variables
  q <- list()
  sel_names <- tolower(names(selections))
  for (v in vars) {
    vname <- tolower(.px_first_nonempty(v$text, v$code, ""))
    vv <- .px_chr(v$values)
    vt <- .px_chr(v$valueTexts)
    if (vname %in% sel_names) {
      vals <- as.character(selections[[which(sel_names == vname)[1]]])
      if (length(vt) && !all(vals %in% vv) && any(vals %in% vt)) {
        idxs <- match(vals, vt)
        vals <- vv[idxs]
      }
      if (length(vv) && !all(vals %in% vv)) {
        bad <- unique(setdiff(vals, vv))
        ex_codes <- paste(utils::head(vv, 5), collapse = ", ")
        ex_labs <- tryCatch(
          {
            labs <- .px_chr(v$valueTexts)
            if (length(labs)) {
              paste(utils::head(labs, 5), collapse = ", ")
            } else {
              NA_character_
            }
          },
          error = function(e) NA_character_
        )
        msg <- sprintf(
          "Invalid selection for '%s': %s. Available codes include: %s",
          .px_first_nonempty(v$text, v$code, vname),
          paste(bad, collapse = ", "),
          ex_codes
        )
        if (!is.na(ex_labs)) {
          msg <- paste0(msg, "; labels include: ", ex_labs)
        }
        stop(msg)
      }
      q[[length(q) + 1]] <- list(
        code = v$code,
        selection = list(filter = "item", values = I(as.character(vals)))
      )
    } else {
      q[[length(q) + 1]] <- list(
        code = v$code,
        selection = list(filter = "item", values = I(as.character(vv)))
      )
    }
  }
  list(query = q, response = list(format = "json"))
}

#' Convert a query to a PXWeb body
#'
#' @param x An `nso_query` object.
#' @param lang PX language: "en" or "mn" (defaults to current option).
#' @return A list suitable to send as JSON body to PXWeb.
#' @examplesIf curl::has_internet()
#' q <- nso_query("DT_NSO_0300_001V2", list(Year = "2023"))
#' body <- as_px_query(q)
#' @export
as_px_query <- function(x, lang = .px_lang()) {
  stopifnot(inherits(x, "nso_query"))
  .px_build_body(x$tbl_id, x$selections, lang = lang)
}

#' Fetch a query and return a tibble
#'
#' Executes an `nso_query` and returns a tidy tibble with one column per
#' dimension and a numeric `value` column. Use `labels` to add `_en`/`_mn`
#' columns for each dimension.
#'
#' @param x An `nso_query` object.
#' @param labels One of "code", "en", "mn", or "both" (mapped to internal API).
#' @param value_name Name of the numeric value column in the result (default: "value").
#' @param include_raw If TRUE, attach the raw PX payload as attribute `px_raw`.
#' @return A tibble.
#' @examplesIf curl::has_internet()
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
  stopifnot(inherits(x, "nso_query"))
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
