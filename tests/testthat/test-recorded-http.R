test_that("nso_dims works with recorded HTTP", {
  skip_on_cran()
  if (!requireNamespace("httptest2", quietly = TRUE)) skip("httptest2 not installed")
  # Provide guidance if fixtures are missing
  skip_if_no_mock_dir("px_dims")
  httptest2::with_mock_dir("px_dims", {
    d <- tryCatch(nso_dims("DT_NSO_0300_001V2"), error = function(e) NULL)
    expect_true(!is.null(d))
    expect_s3_class(d, "tbl_df")
  })
})

test_that("nso_data works with recorded HTTP", {
  skip_on_cran()
  if (!requireNamespace("httptest2", quietly = TRUE)) skip("httptest2 not installed")
  skip_if_no_mock_dir("px_data")
  httptest2::with_mock_dir("px_data", {
    res <- tryCatch(nso_data(
      tbl_id = "DT_NSO_0300_001V2",
      selections = list(Sex = "Total", Age = "Total", Year = "2024"),
      labels = "code"
    ), error = function(e) NULL)
    expect_true(!is.null(res))
    expect_s3_class(res, "tbl_df")
    expect_true("value" %in% names(res))
  })
})

