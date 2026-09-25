test_that("mn_boundaries() raises mongolstats_http_error when the download fails", {
  local_mocked_bindings(.gb_gj_url = function(...) "http://127.0.0.1:9/mng.geojson")
  old <- options(mongolstats.retry_tries = 1L, mongolstats.timeout = 2)
  on.exit(options(old), add = TRUE)
  expect_error(
    mn_boundaries("ADM1", refresh = TRUE),
    class = "mongolstats_http_error"
  )
})

test_that(".gb_gj_url() errors clearly when the API gives no download URL", {
  local_mocked_bindings(
    .nso_perform = function(req, ...) {
      httr2::response(
        status_code = 200,
        headers = list(`Content-Type` = "application/json"),
        body = charToRaw("{}")
      )
    }
  )
  expect_snapshot(.gb_gj_url("MNG", "ADM1"), error = TRUE)
  expect_error(.gb_gj_url("MNG", "ADM1"), class = "mongolstats_http_error")
})
