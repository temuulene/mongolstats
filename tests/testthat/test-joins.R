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

# Plain data frames stand in for sf boundaries: the joins only need the
# name column, so these tests never download anything.
fake_boundaries <- function() {
  data.frame(shapeName = c("Ulaanbaatar", "Darkhan-Uul"))
}

test_that("fuzzy join returns all boundaries when data is empty", {
  d <- data.frame(name = character(), value = numeric())
  expect_silent(
    res <- mn_fuzzy_join_by_name(d, "name", boundaries = fake_boundaries())
  )
  expect_equal(nrow(res), 2)
  expect_true(all(is.na(res$value)))
})

test_that("fuzzy join skips NA names instead of crashing", {
  d <- data.frame(aimag = c("Ulanbatar", NA), pop = 1:2)
  res <- mn_fuzzy_join_by_name(d, "aimag", boundaries = fake_boundaries())
  expect_equal(res$pop[res$shapeName == "Ulaanbaatar"], 1L)
  expect_true(is.na(res$pop[res$shapeName == "Darkhan-Uul"]))
})

test_that("fuzzy join rejects edit-distance thresholds for method = 'jw'", {
  skip_if_not_installed("stringdist")
  d <- data.frame(aimag = c("Zzzzzzz", "Qqqq"), pop = 1:2)
  expect_snapshot(
    mn_fuzzy_join_by_name(d, "aimag", boundaries = fake_boundaries(), method = "jw"),
    error = TRUE
  )
  d2 <- data.frame(aimag = "Ulanbatar", pop = 1)
  res <- mn_fuzzy_join_by_name(
    d2, "aimag",
    boundaries = fake_boundaries(), method = "jw", max_distance = 0.2
  )
  expect_equal(res$pop[res$shapeName == "Ulaanbaatar"], 1)
})

test_that("fuzzy join validates max_distance", {
  d <- data.frame(aimag = "Ulanbatar", pop = 1)
  expect_snapshot(
    mn_fuzzy_join_by_name(d, "aimag", boundaries = fake_boundaries(), max_distance = -1),
    error = TRUE
  )
})

test_that("joins warn about data names that match no boundary", {
  d <- data.frame(aimag = c("Ulaanbaatar", "Ulan Bator", NA), pop = 1:3)
  expect_snapshot(
    res <- mn_join_by_name(d, "aimag", boundaries = fake_boundaries())
  )
  expect_equal(res$pop[res$shapeName == "Ulaanbaatar"], 1L)
  expect_warning(
    mn_fuzzy_join_by_name(
      data.frame(aimag = c("Ulanbatar", "Qqqqqqqq"), pop = 1:2),
      "aimag",
      boundaries = fake_boundaries()
    ),
    class = "mongolstats_unmatched_names"
  )
})

test_that("joins are silent when every data name matches", {
  d <- data.frame(aimag = c("Ulaanbaatar", "Darkhan Uul"), pop = 1:2)
  expect_no_warning(mn_join_by_name(d, "aimag", boundaries = fake_boundaries()))
  expect_no_warning(
    mn_fuzzy_join_by_name(d, "aimag", boundaries = fake_boundaries())
  )
})
