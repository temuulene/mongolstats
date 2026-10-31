test_that("configuration is cached by normalized base URL and language", {
  withr::local_options(
    mongolstats.px_base_url = "https://config.example/api/v1/",
    mongolstats.lang = "en"
  )
  calls <- character()
  local_mocked_bindings(.nso_perform = function(req, ...) {
    calls <<- c(calls, req$url)
    httr2::response(
      status_code = 200,
      body = charToRaw('{"maxCells":100,"maxValues":20,"maxCalls":5,"timeWindow":10}')
    )
  })
  config <- nso_api_config(refresh = TRUE)
  expect_equal(config$maxCells, 100)
  expect_equal(config$maxValues, 20)
  expect_equal(config$maxCalls, 5)
  expect_equal(config$timeWindow, 10)
  expect_identical(config$origin, "server")
  expect_identical(config$status, "available")
  expect_identical(calls, "https://config.example/api/v1/en/?config")
  nso_api_config()
  expect_length(calls, 1)
  withr::local_options(mongolstats.lang = "mn")
  nso_api_config()
  expect_length(calls, 2)
  withr::local_options(mongolstats.px_base_url = "https://other-config.example/api/v1")
  nso_api_config()
  expect_length(calls, 3)
})

test_that("configuration fallback is explicit and never fetches offline", {
  withr::local_options(
    mongolstats.px_base_url = "https://offline-config.example/api/v1",
    mongolstats.offline = TRUE
  )
  local_mocked_bindings(.nso_perform = function(...) stop("unexpected request"))
  config <- nso_api_config(refresh = TRUE)
  expect_identical(config$origin, "defaults")
  expect_identical(config$status, "offline")
  expect_equal(config$maxCells, 1e6)
  expect_equal(config$maxValues, 3000)
})

test_that("invalid advertised limits cannot enlarge conservative query limits", {
  withr::local_options(mongolstats.px_base_url = "https://invalid-config.example/api/v1")
  local_mocked_bindings(.nso_perform = function(req, ...) {
    httr2::response(status_code = 200, body = charToRaw('{"maxCells":-2,"maxValues":"bad","maxCalls":0}'))
  })
  config <- nso_api_config(refresh = TRUE)
  expect_identical(config$status, "partial")
  expect_equal(config$maxCells, 1e6)
  expect_equal(config$maxValues, 3000)
  withr::local_options(mongolstats.max_cells = 50, mongolstats.max_values = 10)
  expect_equal(.nso_query_limits(), list(max_cells = 50, max_values = 10))
})

test_that("query limits use cached configuration without an implicit request", {
  withr::local_options(
    mongolstats.px_base_url = "https://small-config.example/api/v1",
    mongolstats.max_cells = 1000,
    mongolstats.max_values = 100
  )
  local_mocked_bindings(.nso_perform = function(req, ...) {
    httr2::response(status_code = 200, body = charToRaw('{"maxCells":40,"maxValues":30,"maxCalls":2,"timeWindow":1}'))
  })
  nso_api_config(refresh = TRUE)
  local_mocked_bindings(.nso_perform = function(...) stop("unexpected request"))
  expect_equal(.nso_query_limits(), list(max_cells = 40, max_values = 30))
  withr::local_options(mongolstats.px_base_url = "https://new-config.example/api/v1")
  expect_equal(.nso_query_limits(), list(max_cells = 1000, max_values = 100))
})

test_that("failed refresh preserves known limits and reports stale status", {
  withr::local_options(mongolstats.px_base_url = "https://stale-config.example/api/v1")
  local_mocked_bindings(.nso_perform = function(req, ...) {
    httr2::response(status_code = 200, body = charToRaw('{"maxCells":45,"maxValues":30,"maxCalls":2,"timeWindow":1}'))
  })
  nso_api_config(refresh = TRUE)
  local_mocked_bindings(.nso_perform = function(...) stop("unavailable"))
  config <- nso_api_config(refresh = TRUE)
  expect_equal(config$maxCells, 45)
  expect_identical(config$origin, "cache")
  expect_identical(config$status, "stale")
  expect_error(nso_api_config(refresh = NA), "refresh")
})

test_that("a stricter cached server allowance slows request scheduling", {
  withr::local_options(
    mongolstats.px_base_url = "https://slow-config.example/api/v1",
    mongolstats.request_interval = 1
  )
  local_mocked_bindings(.nso_perform = function(req, ...) {
    httr2::response(status_code = 200, body = charToRaw('{"maxCells":40,"maxValues":30,"maxCalls":2,"timeWindow":10}'))
  })
  nso_api_config(refresh = TRUE)
  expect_equal(.nso_request_interval(), 5)
  withr::local_options(mongolstats.px_base_url = "https://new-slow-config.example/api/v1")
  expect_equal(.nso_request_interval(), 1)
})
