# Period helpers

#' Create a sequence of periods
#'
#' Builds a run of years (`YYYY`) or months (`YYYYMM`) for use in
#' `selections`. Selections match these to a table's time labels whatever
#' format the table uses, so `"202403"` selects `"2024-03"`, `"2024M3"` or
#' `"2024.03"`.
#'
#' @param start,end Start and end periods as character (YYYY or YYYYMM).
#' @param by 'Y' for yearly or 'M' for monthly.
#' @return Character vector of periods.
#' @examples
#' # Generate yearly sequence
#' nso_period_seq("2020", "2024", by = "Y")
#'
#' # Generate monthly sequence
#' nso_period_seq("202401", "202406", by = "M")
#' @export
nso_period_seq <- function(start, end, by = c("Y", "M")) {
  by <- match.arg(by)
  start <- as.character(start)
  end <- as.character(end)
  # Yearly accepts YYYY (or YYYYMM, using the year part); monthly requires
  # YYYYMM with a valid month.
  pat <- if (by == "Y") "^[0-9]{4}([0-9]{2})?$" else "^[0-9]{4}(0[1-9]|1[0-2])$"
  fmt <- if (by == "Y") "YYYY" else "YYYYMM" # nolint object_usage_linter. Used in cli_abort() below.
  check_period <- function(x, arg) {
    if (length(x) != 1L || is.na(x) || !grepl(pat, x)) {
      cli_abort(
        "{.arg {arg}} must be a single {fmt} period, not {.val {x}}.",
        call = rlang::caller_env(2)
      )
    }
  }
  check_period(start, "start")
  check_period(end, "end")
  if (by == "Y") {
    ys <- as.integer(substr(start, 1, 4))
    ye <- as.integer(substr(end, 1, 4))
    if (ys > ye) {
      cli_abort(
        "{.arg start} ({.val {start}}) must not be after {.arg end} ({.val {end}})."
      )
    }
    as.character(seq.int(ys, ye))
  } else {
    ys <- as.integer(substr(start, 1, 4))
    ms <- as.integer(substr(start, 5, 6))
    ye <- as.integer(substr(end, 1, 4))
    me <- as.integer(substr(end, 5, 6))
    d_start <- as.Date(sprintf("%04d-%02d-01", ys, ms))
    d_end <- as.Date(sprintf("%04d-%02d-01", ye, me))
    if (d_start > d_end) {
      cli_abort(
        "{.arg start} ({.val {start}}) must not be after {.arg end} ({.val {end}})."
      )
    }
    seq_dates <- seq.Date(d_start, d_end, by = "month")
    format(seq_dates, "%Y%m")
  }
}

#' Periods available in a table
#'
#' Finds the table's time dimension (years, quarters, months or dates) and
#' lists its periods from oldest to newest.
#'
#' NSO codes periods by position: code `"0"` is the latest period, so a
#' period's code changes whenever a new one is published. Use the `label`
#' column (or [nso_period_seq()]) in selections, not `code`.
#'
#' @param tbl_id Table identifier.
#' @return A tibble with one row per period, oldest first, and columns
#'   `code` (the positional PXWeb code), `label` (as shown by NSO, e.g.
#'   `"2024"` or `"2024-03"`), `date` (first day of the period, see
#'   [nso_period_date()]) and `frequency` (`"year"`, `"quarter"`, `"month"`
#'   or `"day"`). Periods whose label is not a recognisable date keep their
#'   catalogue order at the end. The tibble has no rows when the table has no
#'   time dimension or in offline mode (see [nso_offline_enable()]). Unknown
#'   tables and failed requests raise an error.
#' @seealso [nso_latest_periods()] for the most recent periods.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' periods <- nso_table_periods("DT_NSO_0300_001V2")
#' tail(periods)
#' @export
nso_table_periods <- function(tbl_id) {
  check_tbl_id(tbl_id)
  meta <- .nso_or_offline(.px_table_meta(tbl_id, lang = .px_lang())$meta)
  .px_periods(meta$variables)
}

#' Most recent periods of a table
#'
#' Returns the labels of the latest periods published in a table, ready to
#' use in `selections`. Combine with [nso_data()] to keep a script on the
#' newest data without hard-coding years.
#'
#' @param tbl_id Table identifier.
#' @param n Number of periods to return.
#' @return A character vector of up to `n` period labels, oldest first;
#'   empty in offline mode (see [nso_offline_enable()]).
#' @seealso [nso_table_periods()] for every period with its date.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' nso_latest_periods("DT_NSO_0300_001V2", n = 3)
#'
#' # Fetch the latest year without hard-coding it
#' nso_data(
#'   "DT_NSO_0300_001V2",
#'   list(Year = nso_latest_periods("DT_NSO_0300_001V2"), Sex = "Total", Age = "Total")
#' )
#' @export
nso_latest_periods <- function(tbl_id, n = 1) {
  check_tbl_id(tbl_id)
  if (!is.numeric(n) || length(n) != 1L || is.na(n) || n < 1 || n != round(n)) {
    got <- if (is.atomic(n) && length(n) == 1L) "{.val {n}}" else "{.obj_type_friendly {n}}"
    # `got` is a fixed template from this function, never user text
    cli_abort(paste0("{.arg n} must be a single positive whole number, not ", got, "."))
  }
  meta <- .nso_or_offline(.px_table_meta(tbl_id, lang = .px_lang())$meta)
  if (is.null(meta)) {
    return(character())
  }
  periods <- .px_periods(meta$variables)
  if (!nrow(periods)) {
    cli_abort("Table {.val {tbl_id}} has no recognisable time dimension.")
  }
  periods <- periods[!is.na(periods$date), , drop = FALSE]
  utils::tail(periods$label, n)
}

# Periods of the time dimension in `vars` as a tibble (code, label, date,
# frequency), oldest first; undated labels last in catalogue order.
.px_periods <- function(vars) {
  empty <- tibble::tibble(
    code = character(), label = character(),
    date = as.Date(character()), frequency = character()
  )
  tv <- .px_time_var(vars)
  if (!tv) {
    return(empty)
  }
  codes <- .px_chr(vars[[tv]]$values)
  labels <- .px_chr(vars[[tv]]$valueTexts)
  if (length(labels) != length(codes)) {
    labels <- codes
  }
  parsed <- .px_parse_period(labels, quarterly = .px_var_quarterly(vars[[tv]]))
  out <- tibble::tibble(code = codes, label = labels, date = parsed$date, frequency = parsed$frequency)
  out[order(out$date, na.last = TRUE), , drop = FALSE]
}
