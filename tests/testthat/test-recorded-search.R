# nso_search()/nso_itms_search() use the embedded index and need no
# network; they are tested directly in test-endpoints.R. The recorded
# tests here cover the metadata and catalogue HTTP endpoints.

test_that("nso_table_meta works with recorded HTTP", {
  skip_on_cran()
  if (!requireNamespace("httptest2", quietly = TRUE)) {
    skip("httptest2 not installed")
  }
  # Record fixtures with tools/record_fixtures.R
  skip_if_no_mock_dir("px_meta")
  httptest2::with_mock_dir("px_meta", {
    meta <- nso_table_meta("DT_NSO_0300_001V2")
    expect_s3_class(meta, "tbl_df")
    expect_true(
      all(c("dim", "code", "is_time", "n_values", "codes") %in% names(meta))
    )
    expect_gte(nrow(meta), 1)
    expect_s3_class(meta$codes[[1]], "tbl_df")
    expect_true("code" %in% names(meta$codes[[1]]))
  })
})

test_that("sectors work with recorded HTTP", {
  skip_on_cran()
  if (!requireNamespace("httptest2", quietly = TRUE)) {
    skip("httptest2 not installed")
  }
  skip_if_no_mock_dir("px_sectors")
  httptest2::with_mock_dir("px_sectors", {
    top <- nso_sectors()
    expect_s3_class(top, "tbl_df")
    expect_gte(nrow(top), 1)
    expect_true(all(c("id", "type", "text") %in% names(top)))
  })
})
