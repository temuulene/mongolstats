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
