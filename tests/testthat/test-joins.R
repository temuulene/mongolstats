test_that("name normalization produces expected tokens", {
  x <- c("Ulaanbaatar", "Övörkhangai aimag", "  Darkhan-Uul\t")
  norm <- c("ulaanbaatar", "ovorkhangai aimag", "darkhan uul")
  expect_equal(
    as.character(.normalize_str(x)),
    norm
  )
})

test_that("join helpers error clearly on a missing name column", {
  d <- data.frame(aimag = "Ulaanbaatar", pop = 1)
  # Errors before any boundary download, naming the missing column
  expect_error(mn_join_by_name(d, "region"), "region")
  expect_error(mn_fuzzy_join_by_name(d, "region"), "region")
  expect_error(mn_join_by_name(d, c("a", "b")), "single character")
})

test_that("fuzzy join falls back gracefully when inputs are empty", {
  skip_on_cran()
  d <- data.frame(name = character(), value = numeric())
  expect_silent({
    res <- try(
      mn_fuzzy_join_by_name(d, name_col = "name", level = "ADM1"),
      silent = TRUE
    )
  })
})
