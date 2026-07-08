test_that("nso_dims works with recorded HTTP", {
  skip_on_cran()
  if (!requireNamespace("httptest2", quietly = TRUE)) {
    skip("httptest2 not installed")
  }
  # Record fixtures with tools/record_fixtures.R
  skip_if_no_mock_dir("px_dims")
  httptest2::with_mock_dir("px_dims", {
    d <- nso_dims("DT_NSO_0300_001V2")
    expect_s3_class(d, "tbl_df")
    expect_named(d, c("dim", "code", "is_time", "n_values"))
    expect_gte(nrow(d), 1)
  })
})

test_that("nso_data works with recorded HTTP", {
  skip_on_cran()
  if (!requireNamespace("httptest2", quietly = TRUE)) {
    skip("httptest2 not installed")
  }
  skip_if_no_mock_dir("px_data")
  httptest2::with_mock_dir("px_data", {
    res <- nso_data(
      tbl_id = "DT_NSO_0300_001V2",
      selections = list(Sex = "Total", Age = "Total", Year = "2024"),
      labels = "code"
    )
    expect_s3_class(res, "tbl_df")
    expect_true("value" %in% names(res))
    expect_gte(nrow(res), 1)
    expect_type(res$value, "double")
  })
})
