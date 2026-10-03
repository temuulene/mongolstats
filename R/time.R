# Time dimensions ------------------------------------------------------------
#
# NSO never sets PXWeb's `time` flag, and it codes periods by position: "0" is
# the latest period, so a code changes meaning whenever a period is added.
# Time dimensions are therefore found by name (English or Mongolian), then by
# their labels, and are reported by label rather than by code.

# Display names (lowercase) that identify a time dimension. Base-year
# dimensions such as "Reference year" are deliberately absent.
.px_time_names <- c(
  "year", "years", "month", "months", "quarter", "quarters", "week", "weeks",
  "date", "day", "time", "period", "periods",
  "\u043e\u043d", # on (year)
  "\u0441\u0430\u0440", # sar (month)
  "\u0443\u043b\u0438\u0440\u0430\u043b", # uliral (quarter)
  "\u0445\u0443\u0433\u0430\u0446\u0430\u0430", # khugatsaa (period)
  "\u043e\u0433\u043d\u043e\u043e" # ognoo (date)
)

# Index of the time dimension in PXWeb `variables`, or 0 when there is none.
# Preference: the PXWeb time flag; a dimension with a time name whose labels
# are periods; any dimension with a time name; a dimension whose labels are
# all periods.
.px_time_var <- function(vars) {
  if (!length(vars)) {
    return(0L)
  }
  flagged <- which(vapply(vars, function(v) isTRUE(v$time), logical(1)))
  if (length(flagged)) {
    return(flagged[[1]])
  }
  named <- which(vapply(
    vars,
    function(v) {
      nms <- stringr::str_squish(stringr::str_to_lower(c(.px_chr(v$text), .px_chr(v$code))))
      any(nms %in% .px_time_names)
    },
    logical(1)
  ))
  periodic <- which(vapply(
    vars,
    function(v) {
      lab <- .px_chr(v$valueTexts)
      length(lab) > 0L && !anyNA(.px_parse_period(lab)$date)
    },
    logical(1)
  ))
  candidates <- c(intersect(named, periodic), named, periodic)
  if (length(candidates)) as.integer(candidates[[1]]) else 0L
}

# NSO writes quarters as "2025-4", which also reads as a month (April).
# `quarterly` says which: TRUE reads "YYYY-N" as quarter N, FALSE as month N,
# and NULL decides from `x` itself: quarters when every label is "YYYY-1" to
# "YYYY-4" (unpadded months show values above 4).
.px_quarterly_labels <- function(x) {
  x <- x[!is.na(x) & nzchar(x)]
  length(x) > 0L && all(grepl("^\\d{4}-[1-4]$", x))
}

# Is PXWeb variable `v` a quarterly time dimension? By name, else by labels.
.px_var_quarterly <- function(v) {
  nms <- stringr::str_squish(stringr::str_to_lower(c(.px_chr(v$text), .px_chr(v$code))))
  any(nms %in% c("quarter", "quarters", "\u0443\u043b\u0438\u0440\u0430\u043b")) ||
    .px_quarterly_labels(stringr::str_squish(sub("\\*+$", "", .px_chr(v$valueTexts))))
}

# Parse NSO period labels. Returns a tibble with `date` (first day of the
# period) and `frequency` ("year", "quarter", "month" or "day"); both NA for
# labels that are not periods. Handles "2025", "2025*" (preliminary),
# "2026-08", "2026-8", "2016M1", "2026.02", "202601", "2024Q1", "2024-Q1",
# "2024-I" ... "2024-IV", "2025-4" (a quarter, see `quarterly` above), and
# "2026-07-06".
.px_parse_period <- function(x, quarterly = NULL) {
  x <- stringr::str_squish(sub("\\*+$", "", as.character(x)))
  quarterly <- quarterly %||% .px_quarterly_labels(x)
  n <- length(x)
  year <- rep(NA_integer_, n)
  month <- rep(NA_integer_, n)
  day <- rep(1L, n)
  freq <- rep(NA_character_, n)

  fill <- function(pattern, f, to_month, ignore_case = FALSE) {
    todo <- is.na(freq) & !is.na(x)
    m <- stringr::str_match(x[todo], stringr::regex(pattern, ignore_case = ignore_case))
    hit <- !is.na(m[, 1])
    if (!any(hit)) {
      return(invisible())
    }
    idx <- which(todo)[hit]
    m <- m[hit, , drop = FALSE]
    mon <- to_month(m)
    ok <- !is.na(mon) & mon >= 1L & mon <= 12L
    idx <- idx[ok]
    m <- m[ok, , drop = FALSE]
    year[idx] <<- as.integer(m[, 2])
    month[idx] <<- mon[ok]
    if (f == "day") day[idx] <<- as.integer(m[, 4])
    freq[idx] <<- f
  }
  roman <- c(I = 1L, II = 2L, III = 3L, IV = 4L)
  fill("^(\\d{4})$", "year", function(m) rep(1L, nrow(m)))
  fill("^(\\d{4})-(\\d{2})-(\\d{2})$", "day", function(m) as.integer(m[, 3]))
  if (isTRUE(quarterly)) {
    fill("^(\\d{4})-([1-4])$", "quarter", function(m) as.integer(m[, 3]) * 3L - 2L)
  }
  fill("^(\\d{4})(?:[-./]|M)(\\d{1,2})$", "month", function(m) as.integer(m[, 3]), ignore_case = TRUE)
  fill("^(\\d{4})(\\d{2})$", "month", function(m) as.integer(m[, 3]))
  fill("^(\\d{4})[- ]?Q([1-4])$", "quarter", function(m) as.integer(m[, 3]) * 3L - 2L, ignore_case = TRUE)
  fill("^(\\d{4})[- ]?(I|II|III|IV)$", "quarter", function(m) roman[m[, 3]] * 3L - 2L)

  # Four digits outside a plausible range are codes or counts, not years
  bad_year <- !is.na(year) & (year < 1900L | year > 2199L)
  freq[bad_year] <- NA_character_
  date <- as.Date(
    ifelse(is.na(freq), NA_character_, sprintf("%04d-%02d-%02d", year, month, day)),
    format = "%Y-%m-%d"
  )
  freq[is.na(date)] <- NA_character_
  tibble::tibble(date = date, frequency = freq)
}

# Canonical spelling of a period ("2026-01", "2024", "2024-Q2",
# "2026-07-06") so that one period written in different formats compares
# equal; NA for labels that are not periods.
.px_period_key <- function(x, quarterly = NULL) {
  p <- .px_parse_period(x, quarterly = quarterly)
  key <- rep(NA_character_, nrow(p))
  f <- p$frequency
  d <- p$date
  key[f %in% "year"] <- format(d[f %in% "year"], "%Y")
  key[f %in% "month"] <- format(d[f %in% "month"], "%Y-%m")
  key[f %in% "day"] <- format(d[f %in% "day"], "%Y-%m-%d")
  q <- f %in% "quarter"
  key[q] <- sprintf(
    "%s-Q%d",
    format(d[q], "%Y"),
    (as.integer(format(d[q], "%m")) - 1L) %/% 3L + 1L
  )
  key
}

#' Convert NSO period labels to dates
#'
#' NSO tables label periods in several formats, such as `"2024"`,
#' `"2024-03"`, `"2016M3"`, `"2024.03"`, `"2024-I"` (first quarter) or
#' `"2026-07-06"`. `nso_period_date()` returns the first day of each period,
#' so results can be sorted, filtered and plotted on a date axis. A trailing
#' `*`, which NSO uses to mark preliminary figures, is ignored.
#'
#' NSO's quarterly tables label quarters `"2025-1"` to `"2025-4"`. When every
#' label in `x` has that form, `x` is read as quarters; otherwise `"2025-4"`
#' is April. Pass a table's whole time column so this can be decided, or see
#' the `frequency` column of [nso_table_periods()].
#'
#' @param x A character vector of period labels, such as the time column
#'   returned by [nso_data()].
#' @return A `Date` vector the same length as `x` holding the first day of
#'   each period. Labels that are not periods, such as `"Total"`, give `NA`.
#' @seealso [nso_table_periods()] for the periods available in a table.
#' @examples
#' nso_period_date(c("2024", "2024-03", "2016M3", "2024-II", "Total"))
#' @export
nso_period_date <- function(x) {
  if (is.factor(x)) {
    x <- as.character(x)
  }
  if (!is.character(x)) {
    cli_abort("{.arg x} must be a character vector, not {.obj_type_friendly {x}}.")
  }
  .px_parse_period(x)$date
}
