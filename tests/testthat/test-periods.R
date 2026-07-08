test_that("nso_period_seq builds expected sequences", {
  expect_equal(
    nso_period_seq("2018", "2020", by = "Y"),
    c("2018", "2019", "2020")
  )
  expect_equal(
    head(nso_period_seq("201801", "201803", by = "M"), 3),
    c("201801", "201802", "201803")
  )
})

test_that("nso_period_seq spans year boundaries for monthly sequences", {
  expect_equal(
    nso_period_seq("202412", "202501", by = "M"),
    c("202412", "202501")
  )
})

test_that("nso_period_seq rejects reversed ranges", {
  expect_error(nso_period_seq("2024", "2020"), "must not be after")
  expect_error(nso_period_seq("202405", "202401", by = "M"), "must not be after")
})

test_that("nso_period_seq rejects malformed periods", {
  # yearly period passed to a monthly sequence
  expect_error(nso_period_seq("2024", "202401", by = "M"), class = "rlang_error")
  # non-numeric input
  expect_error(nso_period_seq("abcd", "2024"), class = "rlang_error")
  # month 13 does not exist
  expect_error(nso_period_seq("202413", "202501", by = "M"), class = "rlang_error")
  # NA and vectors
  expect_error(nso_period_seq(NA, "2024"), class = "rlang_error")
  expect_error(nso_period_seq(c("2020", "2021"), "2024"), class = "rlang_error")
})

test_that("nso_table_periods handles unknown tbl_id", {
  skip_on_cran()
  # No network assumption here; function should return character(0) if metadata not available
  expect_type(nso_table_periods("DT_NSO_NON_EXISTENT"), "character")
})
