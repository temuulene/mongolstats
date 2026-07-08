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

#' Get valid periods for a table (PXWeb)
#'
#' Inspects the table metadata to find the time dimension and returns its
#' available period labels (e.g., years or year-months).
#'
#' @param tbl_id Table identifier.
#' @return Character vector of period labels (e.g., years)
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' periods <- nso_table_periods("DT_NSO_0300_001V2")
#' head(periods)
#' @export
nso_table_periods <- function(tbl_id) {
  resolved <- tryCatch(.px_resolve_table(tbl_id), error = function(e) NULL)
  if (is.null(resolved)) {
    return(character())
  }
  px_file <- resolved$px_file
  paths <- resolved$paths
  meta <- tryCatch(
    .px_meta_cached(paths, px_file, lang = .px_lang()),
    error = function(e) NULL
  )
  if (is.null(meta) || is.null(meta$variables)) {
    return(character())
  }
  # Prefer a variable flagged as time or named Year (NSO omits the time
  # flag, so fall back on the display name in either language;
  # the Cyrillic entry is Mongolian "on" = Year)
  vars <- meta$variables
  vi <- purrr::detect_index(vars, function(v) {
    isTRUE(v$time) ||
      stringr::str_to_lower(v$text %||% "") %in%
        c("year", "time", "\u043e\u043d")
  })
  if (!vi) {
    return(character())
  }
  vt <- .px_chr(vars[[vi]]$valueTexts %||% character())
  vt
}
