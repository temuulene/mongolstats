metadata_fixture <- function(name) {
  jsonlite::read_json(testthat::test_path("fixtures", paste0("metadata-", name, ".json")))
}

test_that("metadata distinguishes questionnaire fields and retains source semantics", {
  local_mocked_bindings(.nso_metadata_request = function(...) {
    metadata_fixture("indicator")
  })
  x <- nso_metadata("indicator", 12925, include_raw = TRUE)
  expect_s3_class(x, "nso_metadata")
  expect_identical(x$key, "metadata:indicator:12925")
  expect_identical(x$type, "indicator")
  expect_identical(x$name_en, NA_character_)
  expect_identical(x$years$generated_date, 2022L)
  expect_s3_class(x$dates$methodology_date, "Date")
  expect_identical(x$dates$methodology_date, as.Date(NA_character_))
  expect_identical(x$raw$id, 12925L)
  expect_identical(x$access$data_access_confirmed, FALSE)
  expect_contains(x$quality_flags$code, "suspect_unit")
  expect_contains(x$quality_flags$code, "missing_date")
  expect_setequal(nso_related(x)$key, c(
    "metadata:table:992", "metadata:database:526",
    "metadata:organization:1", "metadata:classification:2293"
  ))
  related <- nso_related(x)
  expect_identical(related$name_mn[related$type == "table"], "Бүлэг 3. Эрүүл мэнд")
})

test_that("years and UTC calendar dates do not become epoch timestamps", {
  local_mocked_bindings(.nso_metadata_request = function(...) {
    list(
      id = 1024, name = "Form", collection_started_date = 2007L,
      form_generated_date = "2007", form_updated_date = "2024",
      confirmed_date = "2024-01-11T00:00:00.000Z", is_active = TRUE
    )
  })
  withr::local_envvar(TZ = "America/Vancouver")
  x <- nso_metadata("form", "1024")
  expect_identical(x$dates$confirmed_date, as.Date("2024-01-11"))
  expect_identical(x$years$collection_started_date, 2007L)
  expect_identical(x$years$form_updated_date, 2024L)
  expect_null(x$raw)
})

test_that("invalid dates and inactive test records are flagged conservatively", {
  local_mocked_bindings(.nso_metadata_request = function(...) {
    list(
      id = 1, name = "TEST record", is_active = FALSE,
      confirmed_date = "2024-02-31", updated_date = "bad date"
    )
  })
  x <- nso_metadata("form", 1)
  expect_setequal(x$quality_flags$code, c("invalid_date", "inactive", "test_record"))
  expect_identical(x$dates$confirmed_date, as.Date(NA_character_))
})

test_that("classification empty responses never imply complete codebooks", {
  local_mocked_bindings(.nso_metadata_request = function(...) {
    metadata_fixture("classification")
  })
  x <- nso_classification(3446)
  expect_s3_class(x, "tbl_df")
  expect_identical(nrow(x), 0L)
  expect_type(x$code, "character")
  expect_identical(attr(x, "completeness"), "empty")
  expect_contains(attr(x, "quality_flags")$code, "empty_codebook")
  expect_identical(attr(x, "metadata")$key, "metadata:classification:3446")
})

test_that("classification codes and versions remain source-qualified strings", {
  local_mocked_bindings(.nso_metadata_request = function(...) {
    list(
      id = 5L, name = "Codes", version = "2024", is_active = TRUE,
      classificationCode = list(
        list(code = "001", definition = "First", version = "1"),
        list(code = "002", definition = "Second", parent_code = "001")
      )
    )
  })
  x <- nso_classification(5)
  expect_identical(x$code, c("001", "002"))
  expect_identical(x$version, c("1", "2024"))
  expect_identical(x$parent_code, c(NA_character_, "001"))
  expect_identical(attr(x, "completeness"), "unverified")
})

test_that("database forms and related records are discoverable without conflating IDs", {
  local_mocked_bindings(.nso_metadata_request = function(...) {
    metadata_fixture("database")
  })
  x <- nso_metadata("database", 526)
  expect_identical(x$years$start_date, 2007L)
  expect_setequal(nso_related(x)$type, c("organization", "table", "form"))
  forms <- nso_forms(526)
  expect_identical(forms$key, "metadata:form:1024")
  expect_identical(forms$records[[1]]$dates$confirmed_date, as.Date("2024-01-11"))
  expect_identical(x$access$data_access_confirmed, FALSE)
})

test_that("database listings retain pagination and filter only the returned page", {
  calls <- list()
  local_mocked_bindings(.nso_metadata_request = function(resource, id = NULL,
                                                         query = list(), body = NULL) {
    calls[[length(calls) + 1L]] <<- list(resource = resource, query = query)
    list(
      data = list(list(id = 526L, name = "Өрхийн судалгаа", sector = 17L)),
      allresults = 46L, currentPage = 2L, lastPage = 2L, perPage = 30L
    )
  })
  x <- nso_metadata_search(type = "database", organization = 1, sector = 17, page = 2)
  expect_identical(calls[[1]]$query, list(org = "1", page = 2L))
  expect_identical(x$key, "metadata:database:526")
  expect_identical(attr(x, "pagination")$current_page, 2L)
  expect_identical(attr(x, "pagination")$total, 46L)
  expect_identical(attr(x, "coverage"), "returned_page")
  expect_identical(attr(x, "exhaustive"), FALSE)
})

test_that("public search uses the observed body and exposes limited coverage", {
  calls <- list()
  local_mocked_bindings(.nso_metadata_request = function(resource, id = NULL,
                                                         query = list(), body = NULL) {
    calls[[1]] <<- list(resource = resource, body = body)
    list(response = jsonlite::toJSON(list(hits = list(
      total = list(value = 100L),
      hits = list(list(`_source` = list(
        `_type` = "indicator",
        indicator_id = 12925L, indicator_name = "Нас", tbl_id = 992L,
        db_id = 526L
      )))
    )), auto_unbox = TRUE))
  })
  x <- nso_metadata_search("нас", type = "indicator")
  expect_identical(calls[[1]], list(resource = "elastic", body = list(values = "нас")))
  expect_identical(x$key, "metadata:indicator:12925")
  expect_identical(x$name_mn, "Нас")
  expect_identical(attr(x, "coverage"), "server_search_window")
  expect_identical(attr(x, "exhaustive"), FALSE)
})

test_that("metadata validates entity and query boundaries before requests", {
  expect_error(nso_metadata("database", "DT_NSO_0000_4_4"), "positive integer")
  expect_error(nso_metadata("database", "../1"), "positive integer")
  expect_error(nso_metadata("database", 1.5), "positive integer")
  expect_error(nso_metadata("database", c(1, 2)), "positive integer")
  expect_error(nso_metadata("other", 1), "type")
  expect_error(nso_related(list()), "nso_metadata")
  expect_error(nso_metadata_search(page = 0), "positive integer")
  expect_error(nso_metadata_search(type = "indicator"), "query")
  expect_error(nso_metadata_search("health", page = 2), "pagination")
  expect_error(nso_metadata_search(), "organization")
})

test_that("metadata handles absent names and large numeric identifiers", {
  local_mocked_bindings(.nso_metadata_request = function(...) {
    list(id = 1000000)
  })
  x <- nso_metadata("form", 1000000)
  expect_identical(x$id, "1000000")
  expect_identical(x$name_mn, NA_character_)
  expect_identical(nrow(x$quality_flags), 0L)
})

test_that("metadata rejects malformed detail and search schemas", {
  local_mocked_bindings(.nso_metadata_request = function(...) list(id = 2L))
  expect_error(nso_metadata("form", 1), class = "mongolstats_metadata_schema_error")
  expect_error(nso_metadata_search("health"), class = "mongolstats_metadata_schema_error")
  expect_error(nso_metadata_search(organization = 1), class = "mongolstats_metadata_schema_error")
})

test_that("classification flags duplicate codes and preserves raw details on request", {
  local_mocked_bindings(.nso_metadata_request = function(...) {
    list(id = 5L, classificationCode = list(
      list(code = "01", definition = "First"),
      list(code = "01", definition = "Other")
    ))
  })
  x <- nso_classification(5, include_raw = TRUE)
  expect_identical(attr(x, "completeness"), "incomplete")
  expect_contains(attr(x, "quality_flags")$code, "invalid_codes")
  expect_identical(attr(x, "metadata")$raw$id, 5L)
})

test_that("response catalogues retain source text and signal limited scope", {
  local_mocked_bindings(.nso_metadata_request = function(...) {
    list(list(id = 1L, name = "Үндэсний статистикийн хороо"))
  })
  x <- nso_metadata_search(type = "organization")
  expect_identical(x$key, "metadata:organization:1")
  expect_identical(attr(x, "coverage"), "response_catalog")
  expect_identical(attr(x, "exhaustive"), FALSE)
  expect_error(nso_metadata_search(type = "sector", organization = 1), "filters")
  expect_error(nso_metadata_search(type = "sector", page = 2), "pagination")
  expect_error(nso_metadata_search("health", type = "sector"), "supports")
})

test_that("window filters exclude unresolved metadata explicitly", {
  local_mocked_bindings(.nso_metadata_request = function(...) {
    list(response = jsonlite::toJSON(list(hits = list(hits = list(
      list(`_source` = list(`_type` = "database", db_id = 1, db_name = "One")),
      list(`_source` = list(`_type` = "database", db_id = 2, db_name = "Two", org_id = 1)),
      list(`_source` = list(`_type` = "form", form_id = 3, form_name = "Form", org_id = 1)),
      list(`_source` = list(`_type` = "unknown", id = 4))
    ))), auto_unbox = TRUE))
  })
  x <- nso_metadata_search("name", organization = 1)
  expect_identical(x$id, "2")
  expect_identical(attr(x, "unresolved_filter_rows"), 1L)
})

test_that("metadata dictionaries retain official categories without asserting access", {
  calls <- NULL
  local_mocked_bindings(.nso_metadata_request = function(resource, ...) {
    calls <<- resource
    list(list(id = 2L, code = "JOININ", name = "Нээлттэй өгөгдлийн жагсаалтад орсон"))
  })
  x <- nso_metadata_dictionary("licence")
  expect_identical(calls, "licence")
  expect_identical(x$key, "metadata:licence:2")
  expect_identical(x$code, "JOININ")
  expect_identical(x$name_en, NA_character_)
  expect_identical(attr(x, "coverage"), "response_catalog")
  expect_error(nso_metadata_dictionary("create"), "dictionary")
})

test_that("raw retention arguments are validated on every public accessor", {
  withr::local_options(mongolstats.offline = TRUE)
  expect_error(nso_metadata("form", 1, include_raw = NA), "include_raw")
  expect_error(nso_forms(526, include_raw = "yes"), "include_raw")
  expect_error(nso_classification(3446, include_raw = logical()), "include_raw")
})

test_that("metadata transport delegates to the shared service and preserves offline errors", {
  calls <- NULL
  local_mocked_bindings(.nso_service_json = function(service, ..., query = list(), body = NULL) {
    calls <<- list(service = service, path = unlist(list(...)), query = query, body = body)
    list(id = 1L, name = "Form")
  })
  expect_identical(nso_metadata("form", 1)$key, "metadata:form:1")
  expect_identical(calls$service, "metadata")
  expect_identical(calls$path, c("form", "1"))
})

test_that("metadata offline mode blocks requests before performing network I/O", {
  withr::local_options(mongolstats.offline = TRUE)
  expect_error(nso_metadata("form", 1), class = "mongolstats_offline_error")
  expect_error(nso_metadata_search("health"), class = "mongolstats_offline_error")
})

test_that("embedded search JSON is parsed only as response text", {
  path <- withr::local_tempfile(fileext = ".json")
  writeLines('{"hits":{"hits":[]}}', path)
  local_mocked_bindings(.nso_metadata_request = function(...) list(response = path))
  expect_error(nso_metadata_search("health"), class = "mongolstats_metadata_schema_error")
})

test_that("ordinary typed fields preserve units and value type for interpretation", {
  local_mocked_bindings(.nso_metadata_request = function(...) metadata_fixture("indicator"))
  x <- nso_metadata("indicator", 12925)
  expect_null(x$raw)
  expect_identical(x$context$unit$id, 16L)
  expect_identical(x$context$unit$name_mn, "төгрөг")
  expect_identical(x$context$unit$name_en, NA_character_)
  expect_identical(x$context$value_type$id, 2L)
  expect_identical(x$context$value_type$name_mn, "Тоо")
  expect_contains(x$quality_flags$code, "suspect_unit")
})

test_that("ordinary typed forms preserve collection source and dissemination context", {
  local_mocked_bindings(.nso_metadata_request = function(...) metadata_fixture("form"))
  x <- nso_metadata("form", 1024)
  expect_null(x$raw)
  expect_identical(x$source, "metadata")
  expect_identical(x$context$source$records[[1]]$id, 2L)
  expect_identical(x$context$source$records[[2]]$id, 1L)
  expect_identical(x$context$source$other, "")
  expect_identical(x$context$dissemination$id, 7L)
  expect_identical(x$context$dissemination$name_mn, "Улс")
  expect_identical(
    x$context$owner_department,
    "Нийгмийн статистикийн газрын Өрхөд суурилсан судалгааны хэлтэс"
  )
  expect_identical(x$years$collection_started_date, 2007L)
})

test_that("original date fields remain available beside parsed dates without raw response", {
  local_mocked_bindings(.nso_metadata_request = function(...) {
    list(
      id = 1024L, confirmed_date = "2024-01-11T00:00:00.000Z",
      methodology_date = NULL, collection_started_date = 2007L,
      updated_date = "invalid date"
    )
  })
  x <- nso_metadata("form", 1024)
  expect_null(x$raw)
  expect_identical(x$date_fields$confirmed_date, "2024-01-11T00:00:00.000Z")
  expect_identical(x$dates$confirmed_date, as.Date("2024-01-11"))
  expect_named(
    x$date_fields,
    c("confirmed_date", "methodology_date", "collection_started_date", "updated_date")
  )
  expect_null(x$date_fields$methodology_date)
  expect_identical(x$date_fields$collection_started_date, 2007L)
  expect_identical(x$years$collection_started_date, 2007L)
  expect_identical(x$date_fields$updated_date, "invalid date")
  expect_identical(x$dates$updated_date, as.Date(NA_character_))
  expect_contains(x$quality_flags$field, "updated_date")
})
