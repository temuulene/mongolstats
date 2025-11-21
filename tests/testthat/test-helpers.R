test_that("nso_period_seq yearly and monthly work", {
  y <- nso_period_seq("2018", "2020", by = "Y")
  expect_equal(y, c("2018", "2019", "2020"))
  m <- nso_period_seq("201801", "201803", by = "M")
  expect_equal(m, c("201801", "201802", "201803"))
})

test_that("mn_boundaries_normalize adds name_std", {
  skip_on_cran()
  skip_if_offline()
  g <- mn_boundaries("ADM1")
  g2 <- mn_boundaries_normalize(g)
  expect_true("name_std" %in% names(g2))
})

test_that("mn_fuzzy_join_by_name returns sf with matches", {
  skip_on_cran()
  skip_if_offline()
  g <- mn_boundaries("ADM1")
  g2 <- mn_boundaries_normalize(g)
  # Create a slightly perturbed name to test fuzzy matching
  nm <- g2$shapeName[1]
  d <- data.frame(val = 1, name = sub("a", "", nm))
  j <- mn_fuzzy_join_by_name(
    d,
    name_col = "name",
    level = "ADM1",
    boundaries = g2,
    max_distance = 3
  )
  expect_s3_class(j, "sf")
})

test_that("cache can enable and clear", {
  dir <- NULL
  expect_silent(dir <- nso_cache_enable())
  expect_true(dir.exists(dir))
  expect_silent(nso_cache_clear())
  expect_silent(nso_cache_disable())
})
