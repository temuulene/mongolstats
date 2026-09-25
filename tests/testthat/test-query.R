test_that("nso_query creates correct structure", {
  q <- nso_query("DT_NSO_TEST", selections = list(Year = "2023"))
  expect_s3_class(q, "nso_query")
  expect_equal(q$tbl_id, "DT_NSO_TEST")
  expect_equal(q$selections, list(Year = "2023"))
})

test_that("nso_query rejects bad tbl_id", {
  expect_snapshot(nso_query(123), error = TRUE)
  expect_snapshot(nso_query(c("a", "b")), error = TRUE)
})

test_that("nso_query rejects bad selections", {
  expect_snapshot(nso_query("DT_NSO_TEST", selections = "not_list"), error = TRUE)
})

test_that("print.nso_query summarises the query and returns it invisibly", {
  q <- nso_query(
    "DT_NSO_TEST",
    selections = list(Year = as.character(2018:2023), Sex = "Total")
  )
  expect_snapshot(print(q))
  expect_invisible(out <- print(q))
  expect_identical(out, q)
})

test_that("as_px_query and nso_fetch reject non-query input", {
  expect_snapshot(as_px_query("not_a_query"), error = TRUE)
  expect_snapshot(nso_fetch("not_a_query"), error = TRUE)
})
