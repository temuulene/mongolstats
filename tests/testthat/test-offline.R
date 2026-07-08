test_that("offline mode blocks network calls but allows object creation", {
  skip_on_cran()
  # Ensure offline
  nso_offline_enable()
  on.exit(nso_offline_disable(), add = TRUE)

  # Creating a query does not hit the network
  q <- nso_query("DT_NSO_0300_001V2", list(Year = "2024"))
  expect_s3_class(q, "nso_query")

  # Networked discovery should not perform requests; functions may return empty results
  res <- nso_sectors()
  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 0)
})

test_that("offline mode skips session-cookie seeding entirely", {
  nso_offline_enable()
  old <- options(mongolstats.px_base_url = "http://127.0.0.1:9/api/v1")
  on.exit(
    {
      nso_offline_disable()
      options(old)
    },
    add = TRUE
  )
  n_before <- length(.mongolstats_px_env$cookies)
  expect_null(.px_session_cookie(character(), "x.px"))
  # No entry cached: nothing was seeded, so the next online call reseeds
  expect_equal(length(.mongolstats_px_env$cookies), n_before)
})
