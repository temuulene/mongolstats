test_that("nso_query creates correct structure", {
  q <- nso_query("DT_NSO_TEST", selections = list(Year = "2023"))
  expect_s3_class(q, "nso_query")
  expect_equal(q$tbl_id, "DT_NSO_TEST")
  expect_equal(q$selections, list(Year = "2023"))
})

test_that("nso_query rejects bad tbl_id", {
  expect_error(nso_query(123), class = "rlang_error")
  expect_error(nso_query(c("a", "b")), class = "rlang_error")
})

test_that("nso_query rejects bad selections", {
  expect_error(nso_query("DT_NSO_TEST", selections = "not_list"), class = "rlang_error")
})

test_that("print.nso_query returns invisibly", {
  q <- nso_query("DT_NSO_TEST", selections = list(Year = "2023"))
  expect_output(print(q), "nso_query")
  out <- print(q)
  expect_identical(out, q)
})

test_that("as_px_query rejects non-query", {
  expect_error(as_px_query("not_a_query"), class = "rlang_error")
})

test_that("nso_fetch rejects non-query", {
  expect_error(nso_fetch("not_a_query"), class = "rlang_error")
})
