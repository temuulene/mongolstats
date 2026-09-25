# Error classes from the HTTP layer. Both tests run offline.

test_that("network failures raise mongolstats_http_error, not offline error", {
  skip_on_cran()
  old <- options(
    mongolstats.px_base_url = "http://127.0.0.1:9/api/v1",
    mongolstats.retry_tries = 1L,
    mongolstats.timeout = 2
  )
  on.exit(options(old), add = TRUE)
  err <- tryCatch(.px_list(character(), lang = "en"), error = function(e) e)
  expect_s3_class(err, "mongolstats_http_error")
  expect_false(inherits(err, "mongolstats_offline_error"))
})

test_that("HTTP errors include the request URL", {
  skip_on_cran()
  old <- options(
    mongolstats.px_base_url = "http://127.0.0.1:9/api/v1",
    mongolstats.retry_tries = 1L,
    mongolstats.timeout = 2
  )
  on.exit(options(old), add = TRUE)
  err <- tryCatch(.px_list(character(), lang = "en"), error = function(e) e)
  expect_s3_class(err, "mongolstats_http_error")
  expect_match(conditionMessage(err), "127.0.0.1", fixed = TRUE)
})

test_that("verbose mode logs the request URL", {
  skip_on_cran()
  old <- options(
    mongolstats.px_base_url = "http://127.0.0.1:9/api/v1",
    mongolstats.verbose = TRUE,
    mongolstats.retry_tries = 1L,
    mongolstats.timeout = 2
  )
  on.exit(options(old), add = TRUE)
  expect_message(
    tryCatch(.px_list(character(), lang = "en"), error = function(e) NULL),
    "127.0.0.1"
  )
})

test_that("offline mode raises mongolstats_offline_error", {
  nso_offline_enable()
  on.exit(nso_offline_disable(), add = TRUE)
  expect_error(
    .px_list(character(), lang = "en"),
    class = "mongolstats_offline_error"
  )
})

test_that("upstream error text is not interpolated as a cli template", {
  local_mocked_bindings(
    req_perform = function(req, ...) stop("server said {oops}"),
    .package = "httr2"
  )
  err <- tryCatch(.px_list(character(), lang = "en"), error = function(e) e)
  expect_s3_class(err, "mongolstats_http_error")
  expect_match(conditionMessage(err), "server said {oops}", fixed = TRUE)
})
