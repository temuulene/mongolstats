test_that("check_tbl_id rejects non-string input", {
  expect_error(check_tbl_id(123), class = "rlang_error")
  expect_error(check_tbl_id(NULL), class = "rlang_error")
  expect_error(check_tbl_id(c("a", "b")), class = "rlang_error")
})

test_that("check_tbl_id accepts valid input", {

  expect_silent(check_tbl_id("DT_NSO_0300_001V2"))
  expect_silent(check_tbl_id("some_table.px"))
})

test_that("check_selections rejects non-list input", {
  expect_error(check_selections("not a list"), class = "rlang_error")
  expect_error(check_selections(123), class = "rlang_error")
})

test_that("check_selections accepts valid input", {
  expect_silent(check_selections(list()))
  expect_silent(check_selections(list(Year = "2023")))
})

test_that("check_query rejects non-string input", {
  expect_error(check_query(123), class = "rlang_error")
  expect_error(check_query(NULL), class = "rlang_error")
  expect_error(check_query(c("a", "b")), class = "rlang_error")
})

test_that("check_query accepts valid input", {
  expect_silent(check_query("population"))
})
