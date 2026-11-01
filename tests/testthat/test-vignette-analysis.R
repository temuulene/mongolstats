analysis <- new.env(parent = globalenv())
sys.source(system.file("examples", "analysis-helpers.R", package = "mongolstats"), envir = analysis)

monthly_fixture <- function() {
  tibble::tibble(
    Region = "A", Region_en = "Area A",
    Month_en = sprintf("2024-%02d", 1:12), value = rep(1, 12)
  )
}

test_that("teaching aggregates preserve unknown counts and distinguish absent units", {
  skip_if_not_installed("tidyr")
  expect_equal(analysis$analysis_sum(c(0, 1, 2)), 3)
  expect_true(is.na(analysis$analysis_sum(c(NA_real_, NA_real_))))
  expect_true(is.na(analysis$analysis_sum(numeric())))
  expect_error(analysis$analysis_sum(c(1, -1)), "nonnegative integers")
  expect_error(analysis$analysis_sum(1.5), "nonnegative integers")
  data <- monthly_fixture()
  annual <- analysis$analysis_annual_counts(data, c("A", "B"))
  expect_equal(annual$count[annual$Region == "A"], 12)
  expect_true(is.na(annual$count[annual$Region == "B"]))
  expect_equal(annual$n_missing[annual$Region == "B"], 12)
  data$value[1] <- NA_real_
  expect_false(analysis$analysis_annual_counts(data, "A")$usable)
  expect_true(is.na(analysis$analysis_annual_counts(data, "A")$count))
})

test_that("twelve rows cannot substitute for twelve distinct expected months", {
  skip_if_not_installed("tidyr")
  data <- monthly_fixture()
  data$Month_en[12] <- data$Month_en[1]
  expect_error(analysis$analysis_annual_counts(data, "A"), "duplicate")
  expect_error(analysis$analysis_complete_years(data$Month_en), "Duplicate")
  data <- monthly_fixture()[-12, ]
  annual <- analysis$analysis_annual_counts(data, "A")
  expect_equal(annual$n_months, 11)
  expect_false(annual$calendar_complete)
  expect_error(analysis$analysis_month_dates("2024-13"), "YYYY-MM")
  expect_error(analysis$analysis_latest(character()), "No common")
})

test_that("paired joins validate keys and align values before rates", {
  x <- tibble::tibble(Region = c("A", "B"), deaths = c(1, 2))
  y <- tibble::tibble(Region = c("B", "A"), births = c(200, 10))
  pair <- analysis$analysis_pair(x, y, "Region")
  expect_equal(pair$births, c(10, 200))
  expect_error(analysis$analysis_pair(x, y[1, ], "Region"), "expected")
  expect_error(analysis$analysis_pair(x, y[c(1, 1), ], "Region"), "duplicate")
  rates <- analysis$analysis_poisson(c(0, NA_real_, 2), c(1000, 1000, 0))
  expect_equal(rates$lower[1], 0)
  expect_equal(rates$upper[1], unname(stats::poisson.test(0, T = 1000)$conf.int[2]) * 1000)
  expect_true(all(is.na(rates$rate[-1])))
})

test_that("age standardisation requires complete matching strata in every year", {
  skip_if_not_installed("tidyr")
  cases <- tibble::tibble(year = c("2024", "2024"), age = c("young", "old"), cases = c(10, 30))
  pop <- tibble::tibble(year = c("2024", "2024"), age = c("young", "old"), population = c(1000, 1000))
  weights <- tibble::tibble(age = c("young", "old"), weight = c(0.5, 0.5))
  expect_equal(analysis$analysis_asr(cases, pop, weights)$standardised, 200)
  expect_error(analysis$analysis_asr(cases[1, ], pop, weights), "expected")
  expect_error(analysis$analysis_asr(cases[1, ], pop[1, ], weights), "expected")
  pop$population[1] <- 0
  expect_error(analysis$analysis_asr(cases, pop, weights), "invalid")
})

test_that("funnel screening never classifies undefined rates as within limits", {
  signal <- analysis$analysis_funnel_signal(c(NA_real_, 0, 8, 0), c(100, 0, 300, 1000), 0.01)
  expect_equal(as.character(signal[1:2]), rep("Insufficient data", 2))
  expect_equal(as.character(signal[3]), "Above 95% limit")
  # This is a conservative attainable Poisson tail, not an interpolated one.
  cutoff <- stats::qpois(0.975, 3)
  expect_lte(stats::ppois(cutoff, 3, lower.tail = FALSE), 0.025)
})

test_that("air fallback is explicit and does not hide schema or programming errors", {
  cache <- function() data.frame(value = 1)
  unavailable <- function() {
    stop(structure(list(message = "unavailable", call = NULL),
      class = c("mongolstats_http_error", "error", "condition")
    ))
  }
  expect_message(result <- analysis$analysis_air_source(unavailable, cache, "value"), "historical")
  expect_equal(result$mode, "Historical bundled snapshot")
  expect_equal(result$error, "unavailable")
  expect_error(analysis$analysis_air_source(function() stop("bad selection"), cache, "value"), "bad selection")
  expect_error(analysis$analysis_air_source(function() data.frame(wrong = 1), cache, "value"), "expected columns")
  malformed <- function() {
    stop(structure(list(message = "malformed", call = NULL),
      class = c("mongolstats_invalid_response", "mongolstats_http_error", "error", "condition")
    ))
  }
  expect_error(analysis$analysis_air_source(malformed, cache, "value"), "malformed")
})

test_that("measurement counts and water years are checked explicitly", {
  skip_if_not_installed("lubridate")
  date <- rep(as.Date("2024-02-01"), 4)
  expect_equal(analysis$analysis_monitoring_days(c(29, 30, 10, NA_real_), date), c(TRUE, FALSE, FALSE, FALSE))
  water <- data.frame(Year_en = c("2023", "2024"), value = c(100, 200))
  expect_equal(analysis$analysis_one_year(water, "2024")$value, 200)
  expect_error(analysis$analysis_one_year(water, "2025"), "no observations")
})

test_that("December neighbours must be adjacent calendar months", {
  skip_if_not_installed("lubridate")
  data <- tibble::tibble(
    date = as.Date(c("2023-10-01", "2023-12-01", "2024-01-01")),
    daily_avg = c(10, 50, 20)
  )
  expect_true(is.na(analysis$analysis_neighbours(data)$neighbours))
  data$date[1] <- as.Date("2023-11-01")
  expect_equal(analysis$analysis_neighbours(data)$neighbours, 15)
  expect_equal(analysis$analysis_weighted_daily(c(31, 56), c(31, 28)), 87 / 59)
})

test_that("hospital shares require paired observations and a subset relationship", {
  all <- tibble::tibble(date = as.Date(c("2024-01-01", "2024-02-01")), value = c(100, 110))
  hospital <- dplyr::mutate(all, value = c(40, 50))
  expect_equal(analysis$analysis_hospital_pair(all, hospital)$nonhospital_deaths, c(60, 60))
  expect_error(analysis$analysis_hospital_pair(all, hospital[1, ]), "expected")
  hospital$value[1] <- 101
  expect_error(analysis$analysis_hospital_pair(all, hospital), "subsets")
})
