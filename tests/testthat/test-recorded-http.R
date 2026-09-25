# Replay-only tests: fixtures are recorded with tools/record_fixtures.R and
# no request reaches the network, so these also run on CRAN.

test_that("nso_dims works with recorded HTTP", {
  with_px_fixtures("px_dims", {
    d <- nso_dims("DT_NSO_0300_001V2")
    expect_s3_class(d, "tbl_df")
    expect_named(d, c("dim", "code", "is_time", "n_values"))
    expect_gte(nrow(d), 1)
  })
})

test_that("nso_data works with recorded HTTP", {
  with_px_fixtures("px_data", {
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

test_that("nso_fetch honors the mongolstats.default_labels option", {
  old <- options(mongolstats.default_labels = "en")
  on.exit(options(old), add = TRUE)
  with_px_fixtures("px_data", {
    q <- nso_query(
      "DT_NSO_0300_001V2",
      list(Sex = "Total", Age = "Total", Year = "2024")
    )
    res <- nso_fetch(q)
    expect_true(any(grepl("_en$", names(res))))
    # An explicit labels argument still overrides the option
    res_code <- nso_fetch(q, labels = "code")
    expect_false(any(grepl("_en$", names(res_code))))
  })
})
