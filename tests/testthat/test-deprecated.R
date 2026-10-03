test_that("geoBoundaries helpers are deprecated in favour of mongolmaps", {
  withr::local_options(lifecycle_verbosity = "warning")
  d <- data.frame(aimag = "Ulaanbaatar", pop = 1)
  b <- data.frame(shapeName = "Ulaanbaatar")
  expect_snapshot({
    j <- mn_join_by_name(d, "aimag", boundaries = b)
    j <- mn_fuzzy_join_by_name(d, "aimag", boundaries = b)
    g <- mn_boundaries_normalize(b)
  })
  expect_equal(j$pop, 1)
  expect_equal(g$name_std, "ulaanbaatar")
})

test_that("mn_boundaries() and mn_boundary_keys() are deprecated", {
  withr::local_options(lifecycle_verbosity = "warning")
  local_mocked_bindings(.gb_gj_url = function(...) cli::cli_abort("no network", class = "mongolstats_http_error"))
  .mn_boundaries_env$ADM0 <- NULL
  expect_snapshot(mn_boundaries("ADM0", refresh = TRUE), error = TRUE)
  expect_snapshot(mn_boundary_keys("ADM0"), error = TRUE)
})
