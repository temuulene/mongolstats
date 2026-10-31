portal_fixture <- function(name) {
  jsonlite::fromJSON(testthat::test_path("fixtures", paste0("portal-", name, ".json")), simplifyVector = FALSE)
}

test_that("portal observations preserve source identity, labels, and symbols", {
  out <- .portal_flatten(portal_fixture("series"), "DT_NSO_0000_4_4", "both")
  expect_s3_class(out, "tbl_df")
  expect_equal(out$backend, rep("portal", 4))
  expect_equal(out$source_id, rep("DT_NSO_0000_4_4", 4))
  expect_equal(out$code, c("CO9999", "CO9999", "UNMAPPED", "CO9999"))
  expect_equal(out$code1, c("2", "2", "3", "3"))
  expect_equal(out$code_mn[1], "Улсын дүн")
  expect_true(all(is.na(out$code_en)))
  expect_equal(out$code5_en[1], "Official fifth label")
  expect_equal(out$value_raw, c("152025.4", "..", "0", NA_character_))
  expect_equal(out$value, c(152025.4, NA, 0, NA))
  expect_equal(out$value_status, c("observed", "symbol", "observed", "missing"))
  expect_equal(out$period, c("2002", "2003", "2004*", "2004*"))
  expect_equal(out$date, as.Date(c("2002-01-01", "2003-01-01", "2004-01-01", "2004-01-01")))
  expect_equal(out$frequency, rep("year", 4))
  expect_false("code6" %in% names(out))
})

test_that("portal label choices retain codes and only requested official labels", {
  x <- portal_fixture("series")
  code <- .portal_flatten(x, "DT_NSO_0000_4_4", "code")
  mn <- .portal_flatten(x, "DT_NSO_0000_4_4", "mn")
  en <- .portal_flatten(x, "DT_NSO_0000_4_4", "en")
  expect_false(any(grepl("_(mn|en)$", names(code))))
  expect_true("code_mn" %in% names(mn))
  expect_false("code_en" %in% names(mn))
  expect_true("code_en" %in% names(en))
  expect_false("code_mn" %in% names(en))
})

test_that("portal input validation precedes requests", {
  for (bad in list("../other", "DT_NSO_1?x=y", "", NA_character_, c("a", "b"))) {
    expect_error(nso_portal_data(bad), "indicator_id")
  }
  expect_error(nso_portal_data("DT_NSO_1", area = "../1"), "area")
  expect_error(nso_portal_data("DT_NSO_1", dimension = "code/../"), "dimension")
  expect_error(nso_portal_data("DT_NSO_1", graph_type = "line?x=y"), "graph_type")
  expect_error(nso_portal_data("DT_NSO_1", include_raw = NA), "include_raw")
  expect_error(nso_portal_data("DT_NSO_1", periods = c("2004", NA)), "periods")
})

test_that("portal fetching builds an explicit URL and keeps provenance and raw data", {
  seen <- character()
  testthat::local_mocked_bindings(
    .portal_request = function(...) {
      seen <<- c(seen, paste(c(...), collapse = "/"))
      portal_fixture("series")
    },
    .portal_registry = function(refresh = FALSE) .portal_registry_rows(portal_fixture("registry"))
  )
  out <- nso_portal_data("DT_NSO_0000_4_4", periods = "2004*", include_raw = TRUE)
  expect_equal(seen, "indicator/data/DT_NSO_0000_4_4-code-1-line")
  expect_equal(nrow(out), 2)
  expect_true(all(out$unit == "сая.төг"))
  expect_true(all(out$source == "Үндэсний Статистикийн Хороо"))
  expect_length(attr(out, "portal_raw"), 4)
  expect_true(is.list(attr(out, "nso_provenance")))
  expect_null(attr(nso_portal_data("DT_NSO_0000_4_4"), "portal_raw"))
})

test_that("portal empty responses have a usable schema and failed requests propagate", {
  testthat::local_mocked_bindings(
    .portal_request = function(...) list(),
    .portal_registry = function(refresh = FALSE) .portal_registry_rows(portal_fixture("registry"))
  )
  out <- nso_portal_data("DT_NSO_0000_4_4")
  expect_equal(nrow(out), 0)
  expect_true(all(c("period", "date", "value", "value_raw", "value_status") %in% names(out)))
  testthat::local_mocked_bindings(
    .portal_request = function(...) rlang::abort("Unavailable", class = "mongolstats_http_error")
  )
  expect_error(nso_portal_data("DT_NSO_0000_4_4"), class = "mongolstats_http_error")
})

test_that("unexpected portal schemas and mixed source identities are rejected", {
  expect_error(.portal_flatten(list(error = "bad"), "DT_NSO_1", "code"), class = "mongolstats_portal_schema_error")
  expect_error(.portal_flatten(list(list(period = "2024")), "DT_NSO_1", "code"), "dtval_co")
  x <- portal_fixture("series")
  x[[1]]$tbl_id <- "DT_NSO_OTHER"
  expect_error(.portal_flatten(x, "DT_NSO_0000_4_4", "code"), "source")
  x <- portal_fixture("series")
  x[[1]]$dtval_co <- list(1, 2)
  expect_error(.portal_flatten(x, "DT_NSO_0000_4_4", "code"), class = "mongolstats_portal_schema_error")
})

test_that("portal catalog distinguishes invalid and duplicate IDs", {
  out <- .portal_registry_rows(portal_fixture("registry"))
  expect_equal(out$backend, rep("portal", 5))
  expect_equal(out$queryable, c(TRUE, FALSE, FALSE, TRUE, TRUE))
  expect_equal(out$quality_flags, c("", "missing_id", "invalid_id", "duplicate_id", "duplicate_id"))
  expect_equal(out$id[1], "portal:DT_NSO_0000_4_4")
  expect_true(all(is.na(out$px_table_id)))
})

test_that("datamart discovery exposes aggregate configuration without claiming a query contract", {
  testthat::local_mocked_bindings(.portal_request = function(...) {
    expect_equal(list(...), list("datamart"))
    portal_fixture("datamarts")
  })
  out <- nso_portal_datamarts()
  expect_s3_class(out, "tbl_df")
  expect_equal(out$id, "1")
  expect_equal(out$name, "Засаг захиргаа")
  expect_false(out$query_supported)
  expect_true(is.list(out$configuration))
  expect_true(is.list(attr(out, "nso_provenance")))
})

test_that("ambiguous portal periods retain source labels without guessed frequencies", {
  rows <- list(list(period = "2025-1", dtval_co = "4", code = "CO9999"))
  out <- .portal_flatten(rows, "DT_NSO_1", "code")
  expect_equal(out$period, "2025-1")
  expect_true(is.na(out$date))
  expect_true(is.na(out$frequency))
  rows[[1]]$period <- "2025-Q1"
  expect_equal(.portal_flatten(rows, "DT_NSO_1", "code")$frequency, "quarter")
})

test_that("portal metadata failures are explicit but observations remain usable", {
  testthat::local_mocked_bindings(
    .portal_request = function(...) portal_fixture("series"),
    .portal_registry = function(refresh = FALSE) rlang::abort("No catalog", class = "mongolstats_http_error")
  )
  expect_warning(
    out <- nso_portal_data("DT_NSO_0000_4_4"),
    class = "mongolstats_portal_metadata_warning"
  )
  expect_equal(nrow(out), 4)
  expect_true(all(is.na(out$unit)))
  expect_true(all(is.na(out$source)))
})

test_that("contradictory registry units are not silently selected", {
  rows <- portal_fixture("registry")
  rows[[2]] <- rows[[1]]
  rows[[2]]$measure_type <- "different unit"
  testthat::local_mocked_bindings(
    .portal_request = function(...) portal_fixture("series"),
    .portal_registry = function(refresh = FALSE) .portal_registry_rows(rows)
  )
  out <- nso_portal_data("DT_NSO_0000_4_4")
  expect_true(all(is.na(out$unit)))
  expect_true(all(!is.na(out$source)))
})

test_that("portal registry refresh and endpoint changes have separate caches", {
  old_registry <- .mongolstats_portal_env$registry
  old_url <- .mongolstats_portal_env$url
  on.exit(
    {
      .mongolstats_portal_env$registry <- old_registry
      .mongolstats_portal_env$url <- old_url
    },
    add = TRUE
  )
  .mongolstats_portal_env$registry <- NULL
  calls <- 0L
  endpoint <- "https://example.test/first/indicator"
  testthat::local_mocked_bindings(
    .portal_request = function(...) {
      calls <<- calls + 1L
      portal_fixture("registry")
    },
    .nso_service_url = function(...) endpoint
  )
  expect_equal(nrow(.portal_registry()), 5)
  .portal_registry()
  expect_equal(calls, 1L)
  .portal_registry(refresh = TRUE)
  expect_equal(calls, 2L)
  endpoint <- "https://example.test/second/indicator"
  .portal_registry()
  expect_equal(calls, 3L)
})

test_that("portal request helper uses the shared service transport", {
  testthat::local_mocked_bindings(.nso_service_json = function(service, ...) {
    expect_equal(service, "portal")
    expect_equal(list(...), list("indicator"))
    list()
  })
  expect_equal(.portal_request("indicator"), list())
})

test_that("malformed portal record arrays do not look like empty responses", {
  for (bad in list(NULL, "text", list(error = "no access"), list(1))) {
    expect_error(.portal_records(bad), class = "mongolstats_portal_schema_error")
  }
  rows <- list(list(period = NULL, dtval_co = "1"))
  expect_error(.portal_flatten(rows, "DT_NSO_1", "code"), "period")
  expect_error(.portal_scalar(list(x = list("one", "two")), "x"), class = "mongolstats_portal_schema_error")
  expect_error(
    .portal_flatten(list(list(period = "", dtval_co = "1")), "DT_NSO_1", "code"),
    class = "mongolstats_portal_schema_error"
  )
})

test_that("portal data distinguishes an empty JSON array from an empty object", {
  payload <- jsonlite::parse_json("[]")
  local_mocked_bindings(
    .portal_request = function(...) payload,
    .portal_registry = function(...) .portal_registry_rows(list())
  )
  expect_equal(nrow(nso_portal_data("DT_NSO_0000_4_4")), 0L)

  payload <- jsonlite::parse_json("{}")
  expect_error(
    nso_portal_data("DT_NSO_0000_4_4"),
    class = "mongolstats_portal_schema_error"
  )
})

test_that("a malformed portal registry refresh preserves the previous catalog", {
  old_registry <- .mongolstats_portal_env$registry
  old_url <- .mongolstats_portal_env$url
  on.exit(
    {
      .mongolstats_portal_env$registry <- old_registry
      .mongolstats_portal_env$url <- old_url
    },
    add = TRUE
  )
  withr::local_options(
    mongolstats.portal_base_url = "https://portal-schema.example"
  )
  payload <- portal_fixture("registry")
  local_mocked_bindings(.portal_request = function(...) payload)
  previous <- nso_indicators(source = "portal", refresh = TRUE)

  payload <- jsonlite::parse_json("{}")
  expect_error(
    nso_indicators(source = "portal", refresh = TRUE),
    class = "mongolstats_portal_schema_error"
  )
  expect_identical(nso_indicators(source = "portal"), previous)

  payload <- jsonlite::parse_json("[]")
  empty <- nso_indicators(source = "portal", refresh = TRUE)
  expect_equal(nrow(empty), 0L)
  expect_identical(nso_indicators(source = "portal"), empty)
})
