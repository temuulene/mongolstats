test_that("data checks identify duplicate keys and mixed units without changing rows", {
  data <- tibble::tibble(area = c("a", "a"), period = c("2024", "2024"),
                         unit = c("persons", "percent"), value = c(1, 2))
  out <- nso_check_data(data, keys = c("area", "period"), unit = "unit")
  expect_setequal(out$check, c("duplicate_keys", "mixed_units"))
  expect_equal(nrow(data), 2L)
})

test_that("data checks retain unresolved symbols and missing requested periods", {
  data <- tibble::tibble(period = "2024", value = NA_real_)
  attr(data, "nso_value_status") <- tibble::tibble(period = "2024", value_raw = "..", value_status = "symbol")
  out <- nso_check_data(data, period = "period", expected_periods = c("2023", "2024"))
  expect_setequal(out$check, c("source_symbols", "missing_periods"))
})

test_that("geographic overlap checks use explicitly supplied levels", {
  data <- tibble::tibble(area = c("0", "65"), level = c("national", "aimag"), value = c(10, 1))
  out <- nso_check_data(data, geography_level = "level")
  expect_equal(out$check, "mixed_geography_levels")
  expect_equal(nrow(nso_check_data(tibble::tibble(value = 1))), 0L)
})
