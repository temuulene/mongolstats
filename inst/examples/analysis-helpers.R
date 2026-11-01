# Reusable validation helpers for the package's teaching examples.
# Load with source(system.file("examples", "analysis-helpers.R",
#                              package = "mongolstats"), local = TRUE).
# These checks do not establish that source definitions are comparable.
.data <- rlang::.data

analysis_keys <- function(data, keys, expected = NULL) {
  if (!length(keys) || !all(keys %in% names(data))) {
    stop("Supply existing observation-key columns.", call. = FALSE)
  }
  if (anyNA(data[keys]) || anyDuplicated(data[keys])) {
    stop("Missing or duplicate observation keys; inspect the dimensions.", call. = FALSE)
  }
  if (!is.null(expected)) {
    analysis_keys(expected, keys)
    if (nrow(dplyr::anti_join(expected, data, by = keys)) ||
          nrow(dplyr::anti_join(data, expected, by = keys))) {
      stop("Observation keys do not match the expected population or periods.", call. = FALSE)
    }
  }
  invisible(data)
}

analysis_pair <- function(x, y, by) {
  analysis_keys(x, by)
  analysis_keys(y, by, expected = x)
  dplyr::left_join(x, y, by = by, relationship = "one-to-one")
}

analysis_count_values <- function(x) {
  known <- is.finite(x)
  if (!is.numeric(x) || any(x[known] < 0 | x[known] != floor(x[known]))) {
    stop("Observed counts must be nonnegative integers.", call. = FALSE)
  }
  invisible(x)
}

analysis_sum <- function(x) {
  analysis_count_values(x)
  if (!length(x) || any(!is.finite(x))) {
    return(NA_real_)
  }
  sum(x)
}

analysis_month_dates <- function(labels) {
  if (anyNA(labels) || any(!grepl("^[0-9]{4}-(0[1-9]|1[0-2])$", labels))) {
    stop("Expected unambiguous YYYY-MM labels.", call. = FALSE)
  }
  as.Date(paste0(labels, "-01"))
}

analysis_complete_years <- function(labels) {
  dates <- analysis_month_dates(labels)
  if (anyDuplicated(dates)) stop("Duplicate calendar months.", call. = FALSE)
  years <- split(as.integer(format(dates, "%m")), format(dates, "%Y"))
  names(Filter(function(m) identical(sort(m), 1:12), years))
}

analysis_latest <- function(years) {
  years <- sort(unique(as.character(years)))
  if (!length(years) || anyNA(years)) stop("No common complete year.", call. = FALSE)
  tail(years, 1L)
}

# Fill the expected unit/month grid before aggregation. Missing rows and
# unresolved source values remain missing; calendar coverage is separate
# from having twelve usable count observations.
analysis_annual_counts <- function(data, units, years = NULL) {
  required <- c("Region", "Month_en", "value")
  if (!all(required %in% names(data))) stop("Monthly count columns are missing.", call. = FALSE)
  analysis_keys(data, c("Region", "Month_en"))
  analysis_count_values(data$value)
  dates <- analysis_month_dates(data$Month_en)
  if (is.null(years)) years <- sort(unique(format(dates, "%Y")))
  if (!length(years) || !length(units) || anyDuplicated(units)) {
    stop("Supply nonempty years and unique expected units.", call. = FALSE)
  }
  months <- unlist(lapply(years, function(y) sprintf("%s-%02d", y, 1:12)))
  expected <- tidyr::expand_grid(Region = as.character(units), Month_en = months)
  selected <- dplyr::filter(data, .data$Month_en %in% months)
  if (any(!selected$Region %in% units)) stop("Unexpected geographic units.", call. = FALSE)
  grid <- dplyr::left_join(
    expected,
    dplyr::mutate(selected, present = TRUE),
    by = c("Region", "Month_en"), relationship = "one-to-one"
  )
  grid$year <- substr(grid$Month_en, 1L, 4L)
  out <- dplyr::summarise(
    grid,
    count = analysis_sum(.data$value),
    n_months = sum(.data$present %in% TRUE),
    n_missing = sum(!is.finite(.data$value)),
    .by = c("Region", "year")
  )
  out$calendar_complete <- out$n_months == 12L
  out$usable <- out$calendar_complete & out$n_missing == 0L
  if ("Region_en" %in% names(data)) {
    labels <- dplyr::distinct(data, .data$Region, .data$Region_en)
    analysis_keys(labels, "Region")
    out <- dplyr::left_join(out, labels, by = "Region", relationship = "many-to-one")
  }
  out
}

analysis_fetch_counts <- function(tbl, units) {
  periods <- mongolstats::nso_table_periods(tbl)$label
  raw <- mongolstats::nso_data(tbl, list(Region = units, Month = periods), labels = "en")
  # Save source status and provenance before dplyr transformations.
  list(
    annual = analysis_annual_counts(raw, units),
    raw = raw,
    status = mongolstats::nso_value_status(raw),
    provenance = mongolstats::nso_provenance(raw)
  )
}

analysis_common_years <- function(..., require_values = FALSE) {
  inputs <- list(...)
  if (!length(inputs)) stop("Supply annual summaries.", call. = FALSE)
  available <- lapply(inputs, function(x) {
    valid <- if (require_values) x$usable else x$calendar_complete
    ok <- tapply(valid, x$year, all)
    names(ok)[ok %in% TRUE]
  })
  sort(Reduce(intersect, available))
}

analysis_pool_counts <- function(annual, years) {
  x <- dplyr::filter(annual, .data$year %in% years)
  expected <- tidyr::expand_grid(Region = unique(annual$Region), year = as.character(years))
  analysis_keys(x, c("Region", "year"), expected)
  dplyr::summarise(
    x,
    count = analysis_sum(.data$count),
    n_missing = sum(.data$n_missing),
    n_years = dplyr::n(),
    .by = dplyr::all_of(intersect(c("Region", "Region_en"), names(x)))
  )
}

analysis_poisson <- function(events, denominator, scale = 1000) {
  if (length(events) != length(denominator)) stop("Unpaired rate inputs.", call. = FALSE)
  analysis_count_values(events)
  valid <- is.finite(events) & is.finite(denominator) & denominator > 0
  rate <- lower <- upper <- rep(NA_real_, length(events))
  rate[valid] <- events[valid] / denominator[valid] * scale
  lower[valid] <- stats::qchisq(0.025, 2 * events[valid]) / 2 / denominator[valid] * scale
  upper[valid] <- stats::qchisq(0.975, 2 * (events[valid] + 1)) / 2 / denominator[valid] * scale
  tibble::tibble(rate, lower, upper)
}

# Use attainable, conservative discrete Poisson limits for screening.
analysis_funnel_signal <- function(events, births, reference) {
  if (length(reference) != 1L || !is.finite(reference) || reference <= 0) {
    stop("A positive national reference rate is required.", call. = FALSE)
  }
  analysis_count_values(events)
  valid <- is.finite(events) & is.finite(births) & births > 0
  signal <- rep("Insufficient data", length(events))
  expected <- births[valid] * reference
  signal[valid] <- ifelse(
    events[valid] > stats::qpois(0.975, expected), "Above 95% limit",
    ifelse(events[valid] < stats::qpois(0.025, expected), "Below 95% limit", "Within limits")
  )
  factor(signal, levels = c("Above 95% limit", "Within limits", "Below 95% limit", "Insufficient data"))
}

analysis_asr <- function(cases, population, standard) {
  joined <- analysis_pair(cases, population, c("year", "age"))
  analysis_keys(standard, "age")
  expected <- tidyr::expand_grid(year = unique(joined$year), age = standard$age)
  analysis_keys(joined, c("year", "age"), expected)
  analysis_count_values(joined$cases)
  if (any(!is.finite(joined$cases)) || any(!is.finite(joined$population)) ||
        any(joined$population <= 0) || any(!is.finite(standard$weight)) ||
        any(standard$weight <= 0)) {
    stop("Incomplete or invalid age-specific observations.", call. = FALSE)
  }
  joined <- dplyr::left_join(joined, standard, by = "age", relationship = "many-to-one")
  dplyr::summarise(
    joined,
    crude = sum(.data$cases) / sum(.data$population) * 1e4,
    standardised = sum(.data$weight * .data$cases / .data$population) / sum(.data$weight) * 1e4,
    standard_weight = sum(.data$weight),
    .by = "year"
  )
}

analysis_latest_common_year <- function(tables) {
  years <- lapply(tables, function(tbl) {
    labels <- mongolstats::nso_dim_values(tbl, "Year", labels = "en")$label_en
    labels[grepl("^[0-9]{4}$", labels)]
  })
  analysis_latest(Reduce(intersect, years))
}

analysis_one_year <- function(data, year) {
  if (!"Year_en" %in% names(data)) stop("Missing year labels.", call. = FALSE)
  x <- dplyr::filter(data, .data$Year_en == year)
  if (!nrow(x)) stop("Selected year has no observations.", call. = FALSE)
  x
}

analysis_monitoring_days <- function(days, date, fraction = 0.75) {
  maximum <- as.integer(lubridate::days_in_month(date))
  is.finite(days) & days == floor(days) & days >= 0 & days <= maximum &
    days >= fraction * maximum
}

# Catch only typed transport/HTTP failures. A valid empty result, malformed
# columns, a selection error or a programming error must remain visible.
analysis_air_source <- function(fetch, cached, required) {
  reason <- NULL
  data <- tryCatch(fetch(), mongolstats_http_error = function(e) {
    if (inherits(e, "mongolstats_invalid_response")) stop(e)
    reason <<- conditionMessage(e)
    NULL
  })
  mode <- if (is.null(data)) "Historical bundled snapshot" else "Live NSO response"
  if (is.null(data)) {
    message("Using historical air snapshot after request failure: ", reason)
    data <- cached()
  }
  if (!is.data.frame(data) || !nrow(data) || !all(required %in% names(data))) {
    stop("Air data are empty or do not have the expected columns.", call. = FALSE)
  }
  list(data = data, mode = mode, error = reason)
}

analysis_weighted_daily <- function(count, days) {
  if (!length(count) || length(count) != length(days) ||
        any(!is.finite(count)) || any(!is.finite(days)) || any(days <= 0)) {
    return(NA_real_)
  }
  sum(count) / sum(days)
}

analysis_neighbours <- function(data) {
  analysis_keys(data, "date")
  x <- dplyr::select(data, "date", "daily_avg")
  december <- dplyr::filter(data, format(.data$date, "%m") == "12")
  previous <- dplyr::transmute(x,
    date = lubridate::add_with_rollback(.data$date, lubridate::period(months = 1)),
    previous = .data$daily_avg
  )
  following <- dplyr::transmute(x,
    date = lubridate::add_with_rollback(.data$date, lubridate::period(months = -1)),
    following = .data$daily_avg
  )
  december <- dplyr::left_join(december, previous, by = "date", relationship = "one-to-one")
  december <- dplyr::left_join(december, following, by = "date", relationship = "one-to-one")
  dplyr::mutate(december, neighbours = (.data$previous + .data$following) / 2)
}

analysis_hospital_pair <- function(all_deaths, hospital) {
  analysis_count_values(all_deaths$value)
  analysis_count_values(hospital$value)
  paired <- analysis_pair(
    dplyr::select(all_deaths, "date", all_deaths = "value"),
    dplyr::select(hospital, "date", hospital_deaths = "value"), "date"
  )
  if (any(!is.finite(paired$all_deaths)) || any(!is.finite(paired$hospital_deaths)) ||
        any(paired$hospital_deaths < 0 | paired$hospital_deaths > paired$all_deaths)) {
    stop("Hospital counts must be observed subsets of matched all-death counts.", call. = FALSE)
  }
  paired$nonhospital_deaths <- paired$all_deaths - paired$hospital_deaths
  paired
}
