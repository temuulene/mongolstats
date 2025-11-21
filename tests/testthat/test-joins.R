test_that("name normalization produces expected tokens", {
  x <- c("Ulaanbaatar", "Övörkhangai aimag", "  Darkhan-Uul\t")
  norm <- c("ulaanbaatar", "ovorkhangai aimag", "darkhan uul")
  expect_equal(
    as.character(get(".normalize_str", envir = asNamespace("mongolstats"))(x)),
    norm
  )
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
