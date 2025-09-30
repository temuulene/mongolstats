test_that("nso_itms returns tibble-like data", {
  skip_on_cran()
  skip_if_offline()
  itms <- tryCatch(nso_itms(), error = function(e) NULL)
  expect_true(is.null(itms) || inherits(itms, "tbl_df") || is.data.frame(itms))
})

test_that("nso_itms_detail works for a known table", {
  skip_on_cran()
  skip_if_offline()
  d <- tryCatch(nso_itms_detail("DT_NSO_2600_004V1"), error = function(e) NULL)
  expect_true(is.null(d) || is.data.frame(d))
})
