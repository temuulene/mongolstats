test_that("nso_search works with recorded HTTP", {
  skip_on_cran()
  if (!requireNamespace("httptest2", quietly = TRUE)) skip("httptest2 not installed")
  skip_if_no_mock_dir("px_search")
  httptest2::with_mock_dir("px_search", {
    it <- tryCatch(nso_search("population"), error = function(e) NULL)
    expect_true(!is.null(it))
    expect_s3_class(it, "tbl_df")
  })
})

test_that("sectors and subsectors work with recorded HTTP", {
  skip_on_cran()
  if (!requireNamespace("httptest2", quietly = TRUE)) skip("httptest2 not installed")
  skip_if_no_mock_dir("px_sectors")
  httptest2::with_mock_dir("px_sectors", {
    top <- tryCatch(nso_sectors(), error = function(e) NULL)
    expect_true(!is.null(top))
    expect_s3_class(top, "tbl_df")
  })
})

