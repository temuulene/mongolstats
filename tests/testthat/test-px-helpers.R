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

test_that(".px_resolve_table handles .px suffix", {
  fake_idx <- tibble::tibble(px_file = "DT_TEST.px", px_path = "")
  result <- .px_resolve_table("DT_TEST.px", idx = fake_idx)
  expect_equal(result$px_file, "DT_TEST.px")
  expect_equal(result$paths, character())
})
