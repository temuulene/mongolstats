test_that(".px_strip_bom removes BOM", {
  bom_str <- paste0("\uFEFF", "hello")
  expect_equal(.px_strip_bom(bom_str), "hello")
  expect_equal(.px_strip_bom("hello"), "hello")
})

test_that(".px_strip_bom passes non-string through", {
  expect_equal(.px_strip_bom(42), 42)
})

test_that(".px_first_nonempty picks first non-empty", {
  expect_equal(.px_first_nonempty(NULL, "", "fallback"), "fallback")
  expect_equal(.px_first_nonempty("first", "second"), "first")
  expect_null(.px_first_nonempty(NULL, NULL))
})

test_that(".px_chr flattens nested lists", {
  expect_equal(.px_chr(list("a", "b", "c")), c("a", "b", "c"))
  expect_equal(.px_chr(c(1, 2, 3)), c("1", "2", "3"))
})

test_that(".px_resolve_table errors on unknown table", {
  # Mock a minimal px_index
  fake_idx <- tibble::tibble(px_file = "known.px", px_path = "a/b")
  expect_error(
    .px_resolve_table("UNKNOWN", idx = fake_idx),
    class = "rlang_error"
  )
})

test_that(".px_resolve_table resolves known table", {
  fake_idx <- tibble::tibble(px_file = "DT_TEST.px", px_path = "sector/sub")
  result <- .px_resolve_table("DT_TEST", idx = fake_idx)
  expect_equal(result$px_file, "DT_TEST.px")
  expect_equal(result$paths, c("sector", "sub"))
  expect_equal(nrow(result$row), 1L)
})

test_that(".px_resolve_table warns on ambiguous table id and uses first match", {
  fake_idx <- tibble::tibble(
    px_file = c("DT_TEST.px", "DT_TEST.px"),
    px_path = c("sector/sub", "other/place"),
    tbl_eng_nm = c("First table", "Second table")
  )
  expect_snapshot(result <- .px_resolve_table("DT_TEST", idx = fake_idx))
  expect_equal(result$paths, c("sector", "sub"))
  expect_equal(nrow(result$row), 1L)
})

test_that(".px_resolve_table resolves cross-listed table silently", {
  fake_idx <- tibble::tibble(
    px_file = c("DT_TEST.px", "DT_TEST.px"),
    px_path = c("sector/sub", "other/place"),
    tbl_eng_nm = c("Same table", "Same table")
  )
  expect_no_warning(result <- .px_resolve_table("DT_TEST", idx = fake_idx))
  expect_equal(result$paths, c("sector", "sub"))
  expect_equal(nrow(result$row), 1L)
})

test_that(".px_resolve_table handles .px suffix", {
  fake_idx <- tibble::tibble(px_file = "DT_TEST.px", px_path = "")
  result <- .px_resolve_table("DT_TEST.px", idx = fake_idx)
  expect_equal(result$px_file, "DT_TEST.px")
  expect_equal(result$paths, character())
})

test_that(".px_flatten_response keeps time columns typed 't'", {
  out <- list(
    columns = list(
      list(code = "SEX", text = "Sex", type = "d"),
      list(code = "YEAR", text = "Year", type = "t"),
      list(code = "POP", text = "Population", type = "c")
    ),
    data = list(
      list(key = list("0", "2024"), values = list("100")),
      list(key = list("1", "2024"), values = list("60"))
    )
  )
  df <- .px_flatten_response(out)
  expect_named(df, c("Sex", "Year", "value"))
  expect_equal(df$Year, c("2024", "2024"))
  expect_equal(df$value, c(100, 60))
})

test_that(".px_flatten_response handles empty data and custom value_name", {
  empty <- .px_flatten_response(list(columns = list(), data = list()))
  expect_s3_class(empty, "tbl_df")
  expect_equal(nrow(empty), 0)

  out <- list(
    columns = list(
      list(code = "A", text = "A", type = "d"),
      list(code = "V", text = "V", type = "c")
    ),
    data = list(list(key = list("x"), values = list("1.5")))
  )
  df <- .px_flatten_response(out, value_name = "pop")
  expect_equal(df$pop, 1.5)
})

test_that(".px_resolve_table matches table ids case-insensitively", {
  fake_idx <- tibble::tibble(px_file = "DT_TEST_01V2.px", px_path = "a")
  for (id in c("dt_test_01v2", "DT_TEST_01V2.PX", "Dt_Test_01v2.px")) {
    expect_equal(.px_resolve_table(id, idx = fake_idx)$px_file, "DT_TEST_01V2.px")
  }
})

test_that(".px_flatten_response keeps rows aligned on larger responses", {
  n <- 5000
  out <- list(
    columns = list(
      list(code = "A", text = "A", type = "d"),
      list(code = "B", text = "B", type = "t"),
      list(code = "V", text = "V", type = "c")
    ),
    data = lapply(seq_len(n), function(i) {
      list(key = list(as.character(i), as.character(i %% 3)), values = list(as.character(i / 2)))
    })
  )
  df <- .px_flatten_response(out)
  expect_named(df, c("A", "B", "value"))
  expect_equal(nrow(df), n)
  expect_equal(df$A, as.character(seq_len(n)))
  expect_equal(df$B, as.character(seq_len(n) %% 3))
  expect_equal(df$value, seq_len(n) / 2)
})

test_that(".px_flatten_response errors on keys that do not match the columns", {
  out <- list(
    columns = list(
      list(code = "A", text = "A", type = "d"),
      list(code = "B", text = "B", type = "d"),
      list(code = "V", text = "V", type = "c")
    ),
    data = list(
      list(key = list("x", "y"), values = list("1")),
      list(key = list("x"), values = list("2"))
    )
  )
  expect_snapshot(.px_flatten_response(out), error = TRUE)
})

test_that(".px_flatten_response treats missing values as NA", {
  out <- list(
    columns = list(
      list(code = "A", text = "A", type = "d"),
      list(code = "V", text = "V", type = "c")
    ),
    data = list(
      list(key = list("x"), values = list("..")),
      list(key = list("y"), values = list())
    )
  )
  expect_equal(.px_flatten_response(out)$value, c(NA_real_, NA_real_))
})
