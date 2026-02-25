test_that("nso_cache_enable errors without packages", {
  skip_if(requireNamespace("memoise", quietly = TRUE) &&
          requireNamespace("cachem", quietly = TRUE) &&
          requireNamespace("rappdirs", quietly = TRUE),
          "All cache packages installed, cannot test missing package error")
  expect_error(nso_cache_enable(), class = "rlang_error")
})

test_that("nso_cache_status returns list with expected fields", {
  status <- nso_cache_status()
  expect_type(status, "list")
  expect_named(status, c("enabled", "dir", "has_cache"))
  expect_type(status$enabled, "logical")
})

test_that("nso_cache_disable works silently", {
  expect_silent(nso_cache_disable())
  expect_false(nso_cache_status()$enabled)
})

test_that("nso_cache_clear does not error when cache is off", {
  nso_cache_disable()
  expect_silent(nso_cache_clear())
})
