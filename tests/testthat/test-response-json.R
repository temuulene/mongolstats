test_that("service response text cannot open a file or URL", {
  path <- withr::local_tempfile(fileext = ".json")
  writeLines('{"id":123}', path)
  response_text <- path
  url_reads <- 0L
  local_mocked_bindings(.nso_perform = function(req, ...) {
    httr2::response(200, body = charToRaw(response_text))
  })
  local_mocked_bindings(url = function(...) {
    url_reads <<- url_reads + 1L
    stop("Unexpected external URL read.")
  }, .package = "base")

  for (body in c(path, "https://untrusted.example/record.json")) {
    response_text <- body
    expect_error(
      .nso_service_json("metadata", "form", "123"),
      class = "mongolstats_invalid_response"
    )
  }
  expect_equal(url_reads, 0L)
})

test_that("configuration response text cannot load external limits", {
  withr::local_options(mongolstats.px_base_url = "https://json-config.example/api/v1")
  key <- .nso_config_key()
  withr::defer(if (exists(key, .mongolstats_config_env, inherits = FALSE)) {
    rm(list = key, envir = .mongolstats_config_env)
  })
  path <- withr::local_tempfile(fileext = ".json")
  writeLines('{"maxCells":13,"maxValues":2,"maxCalls":1,"timeWindow":1}', path)
  response_text <- path
  url_reads <- 0L
  local_mocked_bindings(.nso_perform = function(req, ...) {
    httr2::response(200, body = charToRaw(response_text))
  })
  local_mocked_bindings(url = function(...) {
    url_reads <<- url_reads + 1L
    stop("Unexpected external URL read.")
  }, .package = "base")

  for (body in c(path, "https://untrusted.example/config.json")) {
    response_text <- body
    config <- nso_api_config(refresh = TRUE)
    expect_identical(config$status, "unavailable")
    expect_identical(config$origin, "defaults")
    expect_equal(config$maxCells, 1e6)
  }
  expect_equal(url_reads, 0L)
})

test_that("PXWeb response parsers treat file paths and URLs as invalid text", {
  path <- withr::local_tempfile(fileext = ".json")
  writeLines('[{"id":"T1.px","type":"t","text":"Table","path":"P","title":"Table"}]', path)
  response_text <- path
  url_reads <- 0L
  local_mocked_bindings(.nso_perform = function(req, ...) {
    httr2::response(200, body = charToRaw(response_text))
  })
  local_mocked_bindings(url = function(...) {
    url_reads <<- url_reads + 1L
    stop("Unexpected external URL read.")
  }, .package = "base")

  for (body in c(path, "https://untrusted.example/table.json")) {
    response_text <- body
    expect_error(.px_list(), "lexical error")
    expect_error(.px_meta(character(), "T1.px"), "lexical error")
    expect_error(.px_search_remote("T1"), class = "mongolstats_invalid_response")
  }
  expect_equal(url_reads, 0L)
})
