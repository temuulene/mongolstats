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

test_that("nso_table_periods handles unknown tbl_id", {
  skip_on_cran()
  # No network assumption here; function should return character(0) if metadata not available
  expect_type(nso_table_periods("DT_NSO_NON_EXISTENT"), "character")
})
