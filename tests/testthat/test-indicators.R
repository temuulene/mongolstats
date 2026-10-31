test_that("curated indicators are explicit reviewed PXWeb concepts", {
  out <- nso_indicators()
  expect_s3_class(out, "tbl_df")
  expect_true(all(out$backend == "pxweb"))
  expect_true(all(out$queryable))
  expect_true(all(grepl("^curated:", out$id)))
  expect_true(all(nzchar(out$definition)))
  expect_true(all(nzchar(out$unit)))
  expect_true(all(nzchar(out$verified_at)))
  expect_true(all(out$source_id %in% .px_index_embedded()$tbl_id))
  expect_true(nrow(nso_indicators("GDP")) >= 1)
  expect_true(nrow(nso_indicators("resident")) >= 1)
  expect_equal(nrow(nso_indicators("no such concept xyz")), 0)
  expect_error(nso_indicators(query = NA), "query")
  expect_error(nso_indicators(refresh = NA), "refresh")
  expect_error(nso_indicators(refresh = TRUE), "curated")
})

test_that("curated lookup resolves aliases without guessing at portal equivalence", {
  x <- nso_indicator("gdp_current")
  expect_equal(x$id, "curated:gdp_current")
  expect_equal(x$source_id, "DT_NSO_0500_001V1")
  expect_equal(x$unit, "million togrogs")
  expect_equal(x$unit_status, "verified_px_response")
  expect_equal(x$verified_at, "2026-10-19")
  expect_equal(nso_indicator("resident_population")$verified_at, "2026-10-19")
  expect_equal(nso_indicator("resident_population")$unit_status, "count_from_statistical_concept")
  expect_equal(nso_indicator("GDP")$id, x$id)
  expect_error(nso_indicator("nonsense"), "Unknown")
  expect_error(nso_indicator(c("GDP", "resident_population")), "id")
  expect_error(nso_indicator_query("portal:DT_NSO_0000_4_4"), "curated")
})

test_that("curated query uses reviewed selections and period labels", {
  q <- nso_indicator_query("gdp_current", periods = c("2023", "2024"))
  expect_s3_class(q, "nso_query")
  expect_equal(q$tbl_id, "DT_NSO_0500_001V1")
  expect_equal(q$selections[["Статистик үзүүлэлт"]], "0")
  expect_equal(q$selections[["Эдийн засгийн салбар"]], "0")
  expect_equal(q$selections[["Жил"]], c("2023", "2024"))
  expect_error(nso_indicator_query("gdp_current", geography = "011"), "geography")
  q <- nso_indicator_query("resident_population", periods = "2024", geography = "011")
  expect_equal(q$selections[["Хүйс"]], "0")
  expect_equal(q$selections[["Бүс"]], "011")
  expect_equal(q$selections[["Он"]], "2024")
  expect_equal(nso_indicator_query("resident_population")$selections[["Бүс"]], "0")
  expect_equal(nso_indicator_query("gdp_current")$selections[["Жил"]], "all")
  expect_error(nso_indicator_query("gdp_current", periods = "0"), "periods")
  expect_error(nso_indicator_query("resident_population", geography = NA), "geography")
})

test_that("portal indicator discovery is separate and filterable", {
  testthat::local_mocked_bindings(
    .portal_registry = function(refresh = FALSE) {
      expect_true(refresh)
      .portal_registry_rows(jsonlite::fromJSON(
        test_path("fixtures", "portal-registry.json"),
        simplifyVector = FALSE
      ))
    }
  )
  out <- nso_indicators("GDP", source = "portal", refresh = TRUE)
  expect_equal(nrow(out), 1)
  expect_equal(out$backend, "portal")
  expect_false(out$template_available)
})

test_that("portal lookups require explicit namespace and reject ambiguous records", {
  testthat::local_mocked_bindings(
    .portal_registry = function(refresh = FALSE) {
      .portal_registry_rows(jsonlite::fromJSON(
        test_path("fixtures", "portal-registry.json"), simplifyVector = FALSE
      ))
    }
  )
  expect_equal(nso_indicator("portal:DT_NSO_0000_4_4")$backend, "portal")
  expect_error(nso_indicator("portal:DT_NSO_DUPLICATE"), "ambiguous")
  expect_error(nso_indicator("portal:DT_NSO_UNKNOWN"), "Unknown")
  expect_error(nso_indicator("DT_NSO_0000_4_4"), "Unknown")
})
