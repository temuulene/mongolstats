# Period helpers

#' Create period codes
#'
#' Utilities to construct NSO period codes and sequences. For monthly data,
#' use YYYYMM; for yearly, use YYYY.
#'
#' @param start,end Start and end periods as character (YYYY or YYYYMM).
#' @param by 'Y' for yearly or 'M' for monthly.
#' @return Character vector of period codes.
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
    seq_dates <- seq.Date(as.Date(sprintf("%04d-%02d-01", ys, ms)),
                          as.Date(sprintf("%04d-%02d-01", ye, me)), by = "month")
    return(format(seq_dates, "%Y%m"))
  }
}

#' Get valid periods for a table
#'
#' Uses `nso_itms()` metadata to compute the valid period codes for a given table.
#' @param tbl_id Table identifier.
#' @return Character vector of period codes.
#' @export
nso_table_periods <- function(tbl_id) {
  it <- tryCatch(nso_itms(), error = function(e) NULL)
  if (is.null(it) || !("tbl_id" %in% names(it))) return(character())
  row <- it[it$tbl_id == tbl_id, , drop = FALSE]
  if (!nrow(row)) return(character())
  start <- as.character(row$strt_prd[1])
  end <- as.character(row$end_prd[1])
  prd <- as.character(row$prd_se[1])
  if (nchar(start) == 6 || prd %in% c("M", "Q")) {
    # treat as monthly; quarters not handled specially
    return(nso_period_seq(start, end, by = "M"))
  } else {
    return(nso_period_seq(start, end, by = "Y"))
  }
}

