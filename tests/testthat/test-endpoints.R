# Catalogue endpoints. Most of these run entirely offline against the
# embedded index; only nso_itms_detail() needs the live API.

test_that("nso_itms returns the embedded catalogue offline", {
  itms <- nso_itms()
  expect_s3_class(itms, "tbl_df")
  expect_gte(nrow(itms), 1)
  expect_true(
    all(c("px_path", "px_file", "tbl_id", "tbl_eng_nm", "list_id") %in% names(itms))
  )
})

test_that("nso_search matches tables in the embedded index", {
  hits <- nso_search("population")
  expect_s3_class(hits, "tbl_df")
  expect_gte(nrow(hits), 1)
  # case-insensitive
  expect_equal(nrow(nso_search("POPULATION")), nrow(hits))
  # no matches returns an empty tibble, not an error
  none <- nso_search("zzz-no-such-table-zzz")
  expect_s3_class(none, "tbl_df")
  expect_equal(nrow(none), 0)
})

test_that("nso_itms_search treats the query as a literal keyword", {
  hits <- nso_itms_search("population")
  expect_gte(nrow(hits), 1)
  # regex metacharacters are matched literally instead of erroring
  none <- nso_itms_search("c++")
  expect_s3_class(none, "tbl_df")
  expect_equal(nrow(none), 0)
})

test_that("labels argument accepts both vocabularies", {
  # The unknown-table error proves the labels value passed validation
  expect_error(
    nso_data("DT_DOES_NOT_EXIST", selections = list(), labels = "code"),
    "not found"
  )
  q <- nso_query("DT_DOES_NOT_EXIST")
  expect_error(nso_fetch(q, labels = "none"), "not found")
  expect_error(
    nso_data("DT_DOES_NOT_EXIST", selections = list(), labels = "bogus")
  )
})

test_that("nso_package reports failed tables instead of dropping silently", {
  reqs <- list(list(tbl_id = "DT_DOES_NOT_EXIST", selections = list()))
  expect_warning(out <- nso_package(reqs), "Failed to fetch")
  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), 0)
  expect_error(
    nso_package(reqs, strict = TRUE),
    class = "mongolstats_http_error"
  )
})

test_that("nso_itms_detail works for a known table", {
  skip_on_cran()
  skip_if_offline()
  d <- nso_itms_detail("DT_NSO_0300_001V2")
  expect_s3_class(d, "tbl_df")
  expect_gte(nrow(d), 1)
  expect_true(all(c("field", "itm_id", "scr_eng") %in% names(d)))
})
