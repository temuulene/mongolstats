test_that("service URLs escape arguments and reject unsafe bases", {
  withr::local_options(mongolstats.metadata_base_url = "https://meta.example")
  expect_equal(
    .nso_service_url("metadata", "api", "indicator", "123"),
    "https://meta.example/api/indicator/123"
  )
  expect_match(
    .nso_service_url("metadata", "api", "database", query = list(org = 1)),
    "org=1",
    fixed = TRUE
  )
  expect_s3_class(
    tryCatch(.nso_service_url("metadata", ".."), error = identity),
    "error"
  )
  withr::local_options(
    mongolstats.metadata_base_url = "https://user:secret@meta.example"
  )
  expect_s3_class(
    tryCatch(.nso_service_url("metadata", "api"), error = identity),
    "error"
  )
})

test_that("service requests parse JSON and retain the offline boundary", {
  local_mocked_bindings(.nso_perform = function(req) {
    httr2::response(
      200,
      url = req$url,
      body = charToRaw('{"id":1,"name":"Example"}')
    )
  })
  expect_equal(.nso_service_json("metadata", "api", "indicator", "1")$id, 1L)
})

test_that("malformed service responses have a typed error", {
  local_mocked_bindings(.nso_perform = function(req) {
    httr2::response(
      200,
      url = req$url,
      body = charToRaw("<html>Unavailable</html>")
    )
  })
  err <- tryCatch(
    .nso_service_json("metadata", "api", "indicator", "1"),
    error = identity
  )
  expect_s3_class(err, "mongolstats_invalid_response")
})
