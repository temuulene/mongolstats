# nso_search()/nso_itms_search() use the embedded index and need no
# network; they are tested directly in test-endpoints.R. The recorded
# tests here cover the metadata and catalogue HTTP endpoints.

test_that("nso_table_meta works with recorded HTTP", {
  with_px_fixtures("px_meta", {
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

test_that("nso_itms_detail attaches Mongolian labels with recorded HTTP", {
  with_px_fixtures("px_meta", {
    d <- nso_itms_detail("DT_NSO_0300_001V2")
    expect_s3_class(d, "tbl_df")
    expect_gte(nrow(d), 1)
    expect_false(anyNA(d$scr_mn))
  })
})

test_that("sectors work with recorded HTTP", {
  with_px_fixtures("px_sectors", {
    top <- nso_sectors()
    expect_s3_class(top, "tbl_df")
    expect_gte(nrow(top), 1)
    expect_true(all(c("id", "type", "text") %in% names(top)))
  })
})
