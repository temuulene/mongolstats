test_that("nso_cache_enable errors without packages", {
  all_installed <- requireNamespace("memoise", quietly = TRUE) &&
    requireNamespace("cachem", quietly = TRUE) &&
    requireNamespace("rappdirs", quietly = TRUE)
  skip_if(all_installed, "All cache packages installed, cannot test missing package error")
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

test_that("cached PXWeb calls are keyed by base URL and database", {
  skip_if_not_installed("memoise")
  skip_if_not_installed("cachem")
  skip_if_not_installed("rappdirs")
  calls <- 0
  local_mocked_bindings(
    .px_list = function(paths = character(), lang = .px_lang()) {
      calls <<- calls + 1
      paste(getOption("mongolstats.px_base_url"), getOption("mongolstats.px_db"))
    }
  )
  dir <- tempfile("mongolstats-cache-")
  nso_cache_enable(dir = dir)
  old <- options(
    mongolstats.px_base_url = "https://a.example/api/v1",
    mongolstats.px_db = "NSO"
  )
  on.exit(
    {
      options(old)
      nso_cache_disable()
      unlink(dir, recursive = TRUE)
    },
    add = TRUE
  )
  a1 <- .px_list_cached("x", lang = "en")
  a2 <- .px_list_cached("x", lang = "en")
  options(mongolstats.px_base_url = "https://b.example/api/v1")
  b <- .px_list_cached("x", lang = "en")
  options(mongolstats.px_db = "OTHER")
  c <- .px_list_cached("x", lang = "en")
  expect_equal(a1, "https://a.example/api/v1 NSO")
  expect_equal(a2, a1)
  expect_equal(b, "https://b.example/api/v1 NSO")
  expect_equal(c, "https://b.example/api/v1 OTHER")
  expect_equal(calls, 3)
})

test_that("the embedded table index is never served from the disk cache", {
  skip_if_not_installed("memoise")
  skip_if_not_installed("cachem")
  skip_if_not_installed("rappdirs")
  dir <- tempfile("mongolstats-cache-")
  nso_cache_enable(dir = dir)
  on.exit(
    {
      nso_cache_disable()
      unlink(dir, recursive = TRUE)
    },
    add = TRUE
  )
  # A stale on-disk copy would survive package upgrades that refresh the
  # embedded index; nso_itms() must always reflect the in-session index.
  idx_id <- "OLD"
  local_mocked_bindings(
    .px_index = function(...) tibble::tibble(px_path = "p", tbl_id = idx_id)
  )
  expect_equal(nso_itms()$tbl_id, "OLD")
  idx_id <- "NEW"
  expect_equal(nso_itms()$tbl_id, "NEW")
})
