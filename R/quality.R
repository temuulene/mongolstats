#' Inspect statistical results for analytical concerns
#'
#' These optional checks report concerns without altering observations or
#' interpreting undocumented source symbols. Supply observation keys, units,
#' expected periods, and geographic levels explicitly. Different measures and
#' populations require substantive review even when these checks find no issue.
#'
#' @param data A data frame, preferably an original fetched result.
#' @param keys Character vector of columns identifying an observation.
#' @param unit Optional column containing units.
#' @param period Optional column containing period labels.
#' @param expected_periods Optional expected labels, compared literally.
#' @param geography_level Optional column containing explicit geographic levels.
#' @return A tibble with `check`, `severity`, `message`, and `n` (affected rows
#'   or values). An empty tibble means none of the requested checks found an
#'   issue; it does not establish semantic comparability.
#' @examples
#' # Constructed records contain a duplicate key and an unresolved symbol.
#' observations <- data.frame(
#'   period = c("2023", "2023"),
#'   value = c(12, NA_real_),
#'   value_raw = c("12", ".."),
#'   value_status = c("observed", "symbol")
#' )
#' nso_check_data(
#'   observations,
#'   keys = "period",
#'   period = "period",
#'   expected_periods = c("2023", "2024")
#' )
#' @export
nso_check_data <- function(
  data,
  keys = NULL,
  unit = NULL,
  period = NULL,
  expected_periods = NULL,
  geography_level = NULL
) {
  if (!is.data.frame(data)) {
    cli_abort("{.arg data} must be a data frame.")
  }
  columns <- c(keys, unit, period, geography_level)
  if (!is.character(columns) && !is.null(columns)) {
    cli_abort("Check columns must be character names.")
  }
  if (anyNA(columns) || any(!columns %in% names(data))) {
    cli_abort("Every check column must exist in {.arg data}.")
  }
  for (column in list(unit, period, geography_level)) {
    if (length(column) > 1L) {
      cli_abort("Unit, period, and geographic level must each name one column.")
    }
  }
  valid_periods <- TRUE
  if (!is.null(expected_periods)) {
    valid_periods <- is.character(expected_periods) &&
      !anyNA(expected_periods) &&
      !is.null(period)
  }
  if (!valid_periods) {
    cli_abort(
      "{.arg expected_periods} requires character labels and a {.arg period} column."
    )
  }
  out <- tibble::tibble(
    check = character(),
    severity = character(),
    message = character(),
    n = integer()
  )
  add <- function(check, message, n) {
    out <<- dplyr::bind_rows(
      out,
      tibble::tibble(
        check = check,
        severity = "review",
        message = message,
        n = as.integer(n)
      )
    )
  }
  if (length(keys)) {
    duplicated <- duplicated(data[keys]) |
      duplicated(data[keys], fromLast = TRUE)
    if (any(duplicated)) {
      add(
        "duplicate_keys",
        "Observation keys are duplicated; inspect dimensions before combining values.",
        sum(duplicated)
      )
    }
  }
  if (!is.null(unit)) {
    values <- unique(data[[unit]])
    values <- values[!is.na(values) & nzchar(as.character(values))]
    if (length(values) > 1L) {
      add(
        "mixed_units",
        "Several units are present; aggregate only compatible measures.",
        length(values)
      )
    }
  }
  status <- nso_value_status(data)
  n_symbols <- if ("value_status" %in% names(status)) {
    sum(status$value_status == "symbol", na.rm = TRUE)
  } else {
    0L
  }
  if (n_symbols) {
    add(
      "source_symbols",
      "Source symbols remain unresolved; numeric missing values do not establish their meaning.",
      n_symbols
    )
  }
  if (!is.null(expected_periods)) {
    missing <- setdiff(expected_periods, as.character(data[[period]]))
    if (length(missing)) {
      add(
        "missing_periods",
        paste("Requested periods absent:", paste(missing, collapse = ", ")),
        length(missing)
      )
    }
  }
  if (!is.null(geography_level)) {
    levels <- unique(data[[geography_level]])
    levels <- levels[!is.na(levels) & nzchar(as.character(levels))]
    if (length(levels) > 1L) {
      add(
        "mixed_geography_levels",
        "Several geographic levels are present; totals may overlap.",
        length(levels)
      )
    }
  }
  out
}
