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

test_that("nso_search() keeps regex escapes case-sensitive", {
  idx <- tibble::tibble(tbl_eng_nm = c("a b", "aXb"))
  # \S is "non-space"; lowercasing the pattern turned it into \s
  expect_equal(.search_index(idx, "A\\Sb", "tbl_eng_nm")$tbl_eng_nm, "aXb")
  expect_equal(
    .search_index(idx, "A B", "tbl_eng_nm", fixed = TRUE)$tbl_eng_nm,
    "a b"
  )
})

test_that("nso_itms_by_sector() validates list_id", {
  expect_snapshot(nso_itms_by_sector(NULL), error = TRUE)
  expect_snapshot(nso_itms_by_sector(c("a", "b")), error = TRUE)
})

test_that("nso_package() reports a labelling failure as a failed table", {
  local_mocked_bindings(
    nso_px_data = function(...) tibble::tibble(Year = "0", value = 1),
    .px_add_labels = function(...) {
      cli::cli_abort("metadata unavailable", class = "mongolstats_http_error")
    }
  )
  expect_warning(
    out <- nso_package(list(list(tbl_id = "T", selections = list())), labels = "en"),
    "Failed to fetch"
  )
  expect_equal(nrow(out), 0)
})

test_that("nso_itms_by_sector() and nso_search(sector =) filter by folder", {
  itms <- nso_itms()
  sector <- itms$px_path[1]
  in_sector <- nso_itms_by_sector(sector)
  expect_gte(nrow(in_sector), 1)
  expect_true(all(in_sector$px_path == sector))
  hits <- nso_search(".", sector = sector)
  expect_setequal(hits$px_file, in_sector$px_file)
  expect_equal(nrow(nso_itms_by_sector("no/such/folder")), 0)
})
