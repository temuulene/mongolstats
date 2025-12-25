# Period helpers

#' Create period codes
#'
#' Utilities to construct NSO period codes and sequences. For monthly data,
#' use YYYYMM; for yearly, use YYYY.
#'
#' @param start,end Start and end periods as character (YYYY or YYYYMM).
#' @param by 'Y' for yearly or 'M' for monthly.
#' @return Character vector of period codes.
#' @examples
#' # Generate yearly sequence
#' nso_period_seq("2020", "2024", by = "Y")
#'
#' # Generate monthly sequence
#' nso_period_seq("202401", "202406", by = "M")
#' @export
nso_period_seq <- function(start, end, by = c("Y", "M")) {
  by <- match.arg(by)
  if (by == "Y") {
    ys <- as.integer(substr(start, 1, 4))
    ye <- as.integer(substr(end, 1, 4))
    return(as.character(seq.int(ys, ye)))
  } else {
    ys <- as.integer(substr(start, 1, 4))
    ms <- as.integer(substr(start, 5, 6))
    ye <- as.integer(substr(end, 1, 4))
    me <- as.integer(substr(end, 5, 6))
    seq_dates <- seq.Date(
      as.Date(sprintf("%04d-%02d-01", ys, ms)),
      as.Date(sprintf("%04d-%02d-01", ye, me)),
      by = "month"
    )
    return(format(seq_dates, "%Y%m"))
  }
}

#' Get valid periods for a table (PXWeb)
#' @param tbl_id Table identifier.
#' @return Character vector of period labels (e.g., years)
#' @examplesIf curl::has_internet()
#' periods <- nso_table_periods("DT_NSO_0300_001V2")
#' head(periods)
#' @export
nso_table_periods <- function(tbl_id) {
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) {
    tbl_id
  } else {
    paste0(tbl_id, ".px")
  }
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) {
    return(character())
  }
  paths <- if (nzchar(row$px_path[1])) {
    strsplit(row$px_path[1], "/", fixed = TRUE)[[1]]
  } else {
    character()
  }
  meta <- tryCatch(
    .px_meta_cached(paths, px_file, lang = .px_lang()),
    error = function(e) NULL
  )
  if (is.null(meta) || is.null(meta$variables)) {
    return(character())
  }
  # Prefer a variable flagged as time or named Year
  vars <- meta$variables
  vi <- purrr::detect_index(vars, function(v) {
    isTRUE(v$time) || tolower(v$text %||% "") %in% c("year", "time")
  })
  if (!vi) {
    return(character())
  }
  vt <- .px_chr(vars[[vi]]$valueTexts %||% character())
  vt
}
