test_that("check_tbl_id rejects non-string input", {
  expect_snapshot(check_tbl_id(123), error = TRUE)
  expect_snapshot(check_tbl_id(NULL), error = TRUE)
  expect_snapshot(check_tbl_id(c("a", "b")), error = TRUE)
})

test_that("check_tbl_id accepts valid input", {
  expect_silent(check_tbl_id("DT_NSO_0300_001V2"))
  expect_silent(check_tbl_id("some_table.px"))
})

test_that("check_selections rejects malformed selections", {
  expect_snapshot(check_selections("not a list"), error = TRUE)
  expect_snapshot(check_selections(list("2023")), error = TRUE)
  expect_snapshot(check_selections(list(Year = "2023", year = "2024")), error = TRUE)
})

test_that("check_selections accepts valid input", {
  expect_silent(check_selections(list()))
  expect_silent(check_selections(list(Year = "2023")))
})

test_that("check_query rejects non-string input", {
  expect_snapshot(check_query(123), error = TRUE)
  expect_snapshot(check_query(NULL), error = TRUE)
  expect_snapshot(check_query(c("a", "b")), error = TRUE)
})

test_that("check_query accepts valid input", {
  expect_silent(check_query("population"))
})

test_that("string validators reject missing and blank values", {
  expect_snapshot(check_tbl_id(NA_character_), error = TRUE)
  expect_snapshot(check_tbl_id("  "), error = TRUE)
  expect_snapshot(check_query(NA_character_), error = TRUE)
  expect_snapshot(check_query(""), error = TRUE)
})

test_that("non-list selections raise a selection error", {
  expect_error(check_selections("not a list"), class = "mongolstats_selection_error")
})

test_that("missing path and dimension arguments fail before any request", {
  local_mocked_bindings(
    .px_table_meta = function(...) stop("should not be called"),
    .px_list_cached = function(...) stop("should not be called")
  )
  expect_snapshot(nso_dim_values("T", NA_character_), error = TRUE)
  expect_snapshot(nso_subsectors(NA_character_), error = TRUE)
  expect_snapshot(nso_data(NA_character_, list()), error = TRUE)
})

test_that("metadata and manifest validation errors name the user-facing function", {
  expect_snapshot(nso_metadata("bogus", 1), error = TRUE)
  expect_snapshot(nso_metadata("database", -1), error = TRUE)
  expect_snapshot(nso_forms(1, include_raw = NA), error = TRUE)
  expect_snapshot(nso_read_manifest(NA_character_), error = TRUE)
})
