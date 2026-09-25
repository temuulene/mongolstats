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
