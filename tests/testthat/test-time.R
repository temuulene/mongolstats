# Time dimensions: detection, period parsing, and period-aware selections

test_that("period labels in NSO formats parse to start dates", {
  x <- c(
    "2025", "2025*", "2026-08", "2026-8", "2016M1", "2016M01", "2026.02",
    "202601", "2024Q1", "2024-Q2", "2024-I", "2024-IV", "2026-07-06"
  )
  p <- .px_parse_period(x)
  expect_equal(
    p$frequency,
    c(rep("year", 2), rep("month", 6), rep("quarter", 4), "day")
  )
  expect_equal(
    p$date,
    as.Date(c(
      "2025-01-01", "2025-01-01", "2026-08-01", "2026-08-01", "2016-01-01",
      "2016-01-01", "2026-02-01", "2026-01-01", "2024-01-01", "2024-04-01",
      "2024-01-01", "2024-10-01", "2026-07-06"
    ))
  )
})

test_that("labels that are not periods parse to NA", {
  p <- .px_parse_period(c("Total", "2015=100", "1990-1995", "2026-13", "85+", NA, ""))
  expect_true(all(is.na(p$date)))
  expect_true(all(is.na(p$frequency)))
})

test_that("nso_period_date() converts period labels to dates", {
  expect_equal(
    nso_period_date(c("2024", "2024-03", "2016M12", "Total")),
    as.Date(c("2024-01-01", "2024-03-01", "2016-12-01", NA))
  )
  expect_identical(nso_period_date(character()), as.Date(character()))
  expect_snapshot(nso_period_date(2024), error = TRUE)
})

test_that("period keys put different spellings of a period on one key", {
  expect_equal(
    .px_period_key(c("202601", "2026-01", "2026M1", "2026.01", "2026-1")),
    rep("2026-01", 5)
  )
  expect_equal(.px_period_key(c("2024", "2024*")), c("2024", "2024"))
  expect_equal(.px_period_key(c("2024-II", "2024Q2")), c("2024-Q2", "2024-Q2"))
  expect_equal(.px_period_key("Total"), NA_character_)
})

time_var <- function(text, labels, code = text, time = NULL) {
  v <- list(
    code = code, text = text, values = as.list(as.character(seq_along(labels) - 1L)),
    valueTexts = as.list(labels)
  )
  if (!is.null(time)) v$time <- time
  v
}

test_that(".px_time_var() finds the time dimension by name", {
  vars <- list(time_var("Age", c("0", "1")), time_var("Year", c("2025", "2024"), code = "Он"))
  expect_equal(.px_time_var(vars), 2L)
  # Mongolian display name (lang = "mn")
  vars_mn <- list(time_var("Сар", c("2026-08", "2026-07")))
  expect_equal(.px_time_var(vars_mn), 1L)
  # The PXWeb time flag wins
  vars_flag <- list(time_var("Year", c("2025")), time_var("Period", c("2025"), time = TRUE))
  expect_equal(.px_time_var(vars_flag), 2L)
})

test_that(".px_time_var() skips base-year dimensions and falls back on labels", {
  # CPI tables: "Reference year" holds base years, "Month" is the time axis
  vars <- list(
    time_var("Reference year", c("2015=100", "2020=100")),
    time_var("Month", c("2026-08", "2026-07"))
  )
  expect_equal(.px_time_var(vars), 2L)
  # No recognised name: the dimension whose labels are all periods
  vars2 <- list(
    time_var("Indicator", c("GDP", "GNI")),
    time_var("Statistical period", c("2016M1", "2016M2"))
  )
  expect_equal(.px_time_var(vars2), 2L)
  expect_equal(.px_time_var(list(time_var("Sex", c("Total", "Male")))), 0L)
  expect_equal(.px_time_var(list()), 0L)
})

test_that("selections match time labels written in another period format", {
  vars <- list(
    time_var("Sex", c("Total", "Male")),
    time_var("Month", c("2026-03", "2026-02", "2026-01"))
  )
  sel <- .px_map_selections(vars, list(Month = c("202601", "2026M2")))
  expect_equal(sel$Month, c("2", "1"))
  # Codes still win: "0" is the code of the latest month
  expect_equal(.px_map_selections(vars, list(Month = "0"))$Month, "0")
  # nso_period_seq() output selects months
  sel2 <- .px_map_selections(vars, list(Month = nso_period_seq("202601", "202603", by = "M")))
  expect_equal(sel2$Month, c("2", "1", "0"))
  expect_error(
    .px_map_selections(vars, list(Month = "202612")),
    class = "mongolstats_selection_error"
  )
})

test_that("YYYY-N labels are quarters on a quarterly dimension", {
  # NSO writes quarters as "2025-4"; on their own such labels are read as
  # quarters only when every label is YYYY-1 to YYYY-4
  q <- .px_parse_period(c("2025-4", "2025-3", "2025-2", "2025-1"))
  expect_equal(q$frequency, rep("quarter", 4))
  expect_equal(q$date, as.Date(c("2025-10-01", "2025-07-01", "2025-04-01", "2025-01-01")))
  # Unpadded months include values above 4
  m <- .px_parse_period(c("2026-8", "2026-7", "2026-3"))
  expect_equal(m$frequency, rep("month", 3))
  # The dimension name settles it either way
  expect_equal(.px_parse_period("2026-3", quarterly = TRUE)$frequency, "quarter")
  expect_equal(.px_parse_period(c("2026-1", "2026-2"), quarterly = FALSE)$frequency, rep("month", 2))
  expect_equal(nso_period_date(c("2024-1", "2024-4")), as.Date(c("2024-01-01", "2024-10-01")))
})

test_that("quarterly dimensions are recognised by name or labels", {
  expect_true(.px_var_quarterly(time_var("Quarter", c("2026-2", "2026-1"))))
  expect_true(.px_var_quarterly(time_var("Year", c("2026-2", "2026-1", "2025-4"))))
  expect_false(.px_var_quarterly(time_var("Month", c("2026-8", "2026-7"))))
  expect_false(.px_var_quarterly(time_var("Year", c("2025", "2024"))))
})

test_that("periods and selections on quarterly tables use quarters", {
  vars <- list(time_var("Quarter", c("2026-2", "2026-1", "2025-4")))
  p <- .px_periods(vars)
  expect_equal(p$label, c("2025-4", "2026-1", "2026-2"))
  expect_equal(p$frequency, rep("quarter", 3))
  sel <- .px_map_selections(vars, list(Quarter = c("2025Q4", "2026-I")))
  expect_equal(sel$Quarter, c("2", "1"))
})

test_that("nso_period_date() accepts factors", {
  expect_equal(nso_period_date(factor(c("2024", "2025"))), as.Date(c("2024-01-01", "2025-01-01")))
})

test_that("periods fall back to codes when labels do not line up", {
  vars <- list(list(code = "Year", text = "Year", values = list("2024", "2025"), valueTexts = list("x")))
  expect_equal(.px_periods(vars)$label, c("2024", "2025"))
})
