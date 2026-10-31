test_that("provenance retains source identity and source metadata", {
  data <- .nso_attach_provenance(
    tibble::tibble(value = 1),
    "pxweb",
    "T",
    "https://px.example/T",
    selections = list(Year = "2024"),
    metadata = list(list(
      updated = "2026-01-01T00:00:00Z",
      source = "Annual survey",
      label = "Example"
    )),
    comments = list("Revised"),
    retrieved_at = as.POSIXct("2026-10-19", tz = "UTC")
  )
  manifest <- nso_provenance(data)
  expect_equal(manifest$schema_version, 1L)
  expect_equal(manifest$records[[1]]$source_id, "T")
  expect_equal(manifest$records[[1]]$source, "Annual survey")
  expect_equal(manifest$records[[1]]$source_updated, "2026-01-01T00:00:00Z")
  expect_equal(manifest$records[[1]]$comments, list("Revised"))
  expect_match(nso_citation(data), "T", fixed = TRUE)
  expect_equal(nso_table_info(data)$backend, "pxweb")
})

test_that("provenance manifests survive export and reject invalid schemas", {
  data <- .nso_attach_provenance(
    tibble::tibble(value = 1),
    "portal",
    "T",
    "https://portal.example/T"
  )
  path <- tempfile(fileext = ".json")
  on.exit(unlink(path), add = TRUE)
  nso_write_manifest(data, path)
  manifest <- nso_read_manifest(path)
  expect_equal(manifest$records[[1]]$source_id, "T")
  expect_equal(nso_citation(manifest), nso_citation(data))
  writeLines('{"schema_version":99,"records":[]}', path)
  expect_s3_class(
    tryCatch(nso_read_manifest(path), error = identity),
    "mongolstats_manifest_error"
  )
})

test_that("split PX results preserve every source symbol and response metadata", {
  local_mocked_bindings(
    .px_table_meta = function(...) {
      list(
        meta = list(
          title = "Example",
          variables = list(
            list(
              code = "YEAR",
              text = "Year",
              values = list("0", "1"),
              valueTexts = list("2025*", "2024")
            )
          )
        ),
        paths = "Sector",
        px_file = "T.px"
      )
    },
    .px_session_cookie = function(...) NULL,
    .nso_query_limits = function() list(max_cells = 1, max_values = 3000),
    .px_post = function(tbl_id, paths, px_file, body, ...) {
      list(
        columns = list(
          list(code = "YEAR", text = "Year", type = "d"),
          list(code = "V", type = "Value", type = "c")
        ),
        data = list(list(
          key = list(body$query[[1]]$selection$values[[1]]),
          values = list("..")
        )),
        metadata = list(list(
          source = "Survey",
          updated = "2026-01-01T00:00:00Z"
        ))
      )
    }
  )
  out <- nso_data("T", list())
  expect_equal(nrow(out), 2L)
  expect_equal(nso_value_status(out)$Year, c("2025*", "2024"))
  expect_equal(nso_value_status(out)$value_raw, c("..", ".."))
  expect_equal(nso_provenance(out)$records[[1]]$source, "Survey")
  expect_length(nso_provenance(out)$records[[1]]$requests, 2L)
  selected <- nso_data("T", list(Year = "2024"))
  expect_equal(nso_provenance(selected)$records[[1]]$periods, "2024")
  expect_equal(
    nso_provenance(selected)$records[[1]]$resolved_selections$YEAR$label,
    "2024"
  )
})

test_that("batch results retain provenance and status for all tables", {
  local_mocked_bindings(.nso_package_fetch = function(r, ...) {
    if (r$tbl_id == "FAILED") {
      return(structure(
        list(tbl_id = r$tbl_id, message = "Unavailable"),
        class = "mongolstats_failed_fetch"
      ))
    }
    out <- .nso_attach_provenance(
      tibble::tibble(value = 1, tbl_id = r$tbl_id),
      "pxweb",
      r$tbl_id,
      "https://px.example/T"
    )
    attr(out, "nso_value_status") <- tibble::tibble(
      value_raw = "1",
      value_status = "observed"
    )
    out
  })
  requests <- lapply(c("A", "B"), function(id) {
    list(tbl_id = id, selections = list())
  })
  out <- nso_package(requests)
  expect_equal(
    vapply(nso_provenance(out)$records, function(r) r$source_id, character(1)),
    c("A", "B")
  )
  expect_equal(nso_value_status(out)$tbl_id, c("A", "B"))
  partial <- suppressWarnings(nso_package(c(
    requests,
    list(list(tbl_id = "FAILED", selections = list()))
  )))
  expect_equal(nso_provenance(partial)$failures[[1]]$source_id, "FAILED")
})

test_that("manifest validation rejects malformed fields and failure records", {
  data <- .nso_attach_provenance(
    tibble::tibble(value = 1),
    "pxweb",
    "T",
    "https://px.example/T"
  )
  original <- unclass(nso_provenance(data))
  path <- tempfile(fileext = ".json")
  on.exit(unlink(path), add = TRUE)
  bad_fields <- list(
    retrieved_at = "yesterday",
    url = "javascript:alert(1)",
    title = list(bogus = FALSE),
    source_updated = TRUE,
    metadata = 44,
    result_rows = -1,
    request_index = 0,
    metadata_hash = "not a fingerprint",
    language = c("en", "mn"),
    requests = list(FALSE),
    selections = 1,
    responses = list(list(url = "https://px.example/T")),
    completed_status = list(FALSE)
  )
  for (field in names(bad_fields)) {
    malformed <- original
    malformed$records[[1]][[field]] <- bad_fields[[field]]
    jsonlite::write_json(malformed, path, auto_unbox = TRUE, null = "null")
    expect_s3_class(
      tryCatch(nso_read_manifest(path), error = identity),
      "mongolstats_manifest_error"
    )
  }
  original$failures <- list(FALSE, 99)
  jsonlite::write_json(original, path, auto_unbox = TRUE, null = "null")
  expect_s3_class(
    tryCatch(nso_read_manifest(path), error = identity),
    "mongolstats_manifest_error"
  )
})

test_that("invalid manifests cannot overwrite a valid exported sidecar", {
  data <- .nso_attach_provenance(
    tibble::tibble(value = 1),
    "pxweb",
    "T",
    "https://px.example/T",
    metadata = list(source = c("Survey", "Census"))
  )
  path <- tempfile(fileext = ".json")
  on.exit(unlink(path), add = TRUE)
  nso_write_manifest(data, path)
  original <- readLines(path)
  malformed <- nso_provenance(data)
  malformed$failures <- list(FALSE)
  expect_s3_class(
    tryCatch(
      nso_write_manifest(malformed, path, overwrite = TRUE),
      error = identity
    ),
    "mongolstats_manifest_error"
  )
  expect_equal(readLines(path), original)
  expect_identical(
    nso_read_manifest(path)$records[[1]]$source,
    c("Survey", "Census")
  )
  expect_s3_class(
    tryCatch(
      nso_read_manifest('{"schema_version":1,"records":[],"failures":[]}'),
      error = identity
    ),
    "mongolstats_manifest_error"
  )
})

test_that("a failed later chunk retains completed response context without partial data", {
  local_mocked_bindings(
    .px_table_meta = function(...) {
      list(
        meta = list(
          title = "Example",
          variables = list(
            list(
              code = "YEAR",
              text = "Year",
              values = list("0", "1"),
              valueTexts = list("2025*", "2024")
            )
          )
        ),
        paths = "Sector",
        px_file = "T.px"
      )
    },
    .px_session_cookie = function(...) NULL,
    .nso_query_limits = function() list(max_cells = 1),
    .px_post = function(tbl_id, paths, px_file, body, ...) {
      code <- body$query[[1]]$selection$values[[1]]
      if (code == "1") {
        rlang::abort(
          "Second chunk unavailable",
          class = "mongolstats_http_error"
        )
      }
      list(
        columns = list(
          list(code = "YEAR", text = "Year", type = "d"),
          list(code = "V", text = "Value", type = "c")
        ),
        data = list(list(key = list(code), values = list(".."))),
        metadata = list(list(
          source = "Survey",
          updated = "2026-01-01T00:00:00Z"
        ))
      )
    }
  )
  error <- tryCatch(
    nso_data("T", list(Year = c("2025*", "2024"))),
    error = identity
  )
  expect_s3_class(error, "mongolstats_http_error")
  manifest <- nso_provenance(error)
  expect_length(manifest$records, 0L)
  failure <- manifest$failures[[1]]
  expect_equal(failure$selections$Year, c("2025*", "2024"))
  expect_equal(failure$resolved_selections$YEAR$label, c("2025*", "2024"))
  expect_equal(failure$chunk_index, 2L)
  expect_length(failure$requests, 2L)
  expect_length(failure$responses, 1L)
  expect_equal(failure$responses[[1]]$metadata[[1]]$source, "Survey")
  expect_equal(failure$completed_status$Year, "2025*")
  expect_equal(failure$completed_status$value_raw, "..")
  path <- tempfile(fileext = ".json")
  on.exit(unlink(path), add = TRUE)
  nso_write_manifest(error, path)
  expect_equal(nso_read_manifest(path)$failures[[1]]$chunk_index, 2L)
})

test_that("batch manifests distinguish repeated table requests including strict errors", {
  local_mocked_bindings(
    .px_table_meta = function(...) {
      list(
        meta = list(
          title = "Example",
          variables = list(
            list(
              code = "YEAR",
              text = "Year",
              values = list("0", "1"),
              valueTexts = list("2024", "2023")
            )
          )
        ),
        paths = "Sector",
        px_file = "T.px"
      )
    },
    .px_session_cookie = function(...) NULL,
    .px_post = function(tbl_id, paths, px_file, body, ...) {
      code <- body$query[[1]]$selection$values[[1]]
      if (code == "1") {
        rlang::abort("Unavailable", class = "mongolstats_http_error")
      }
      list(
        columns = list(
          list(code = "YEAR", text = "Year", type = "d"),
          list(code = "V", text = "Value", type = "c")
        ),
        data = list(list(key = list(code), values = list("1")))
      )
    }
  )
  requests <- lapply(c("2024", "2023"), function(year) {
    list(tbl_id = "T", selections = list(Year = year))
  })
  out <- suppressWarnings(nso_package(requests))
  expect_named(out, c("Year", "value", "tbl_id"))
  expect_equal(out$Year, "2024")
  expect_equal(nso_provenance(out)$records[[1]]$request_index, 1L)
  expect_equal(nso_value_status(out)$request_index, 1L)
  failure <- nso_provenance(out)$failures[[1]]
  expect_equal(failure$request_index, 2L)
  expect_equal(failure$selections$Year, "2023")
  expect_equal(failure$resolved_selections$YEAR$label, "2023")
  error <- tryCatch(nso_package(requests, strict = TRUE), error = identity)
  expect_s3_class(error, "mongolstats_http_error")
  expect_equal(nso_provenance(error)$failures[[1]]$request_index, 2L)
})

test_that("failed labels preserve the already fetched data context", {
  local_mocked_bindings(
    nso_px_data = function(...) {
      out <- .nso_attach_provenance(
        tibble::tibble(Year = "2024", value = NA_real_),
        "pxweb",
        "T",
        "https://px.example/T",
        selections = list(Year = "2024"),
        metadata = list(source = "Survey")
      )
      attr(out, "nso_value_status") <- tibble::tibble(
        Year = "2024",
        value_raw = "..",
        value_status = "symbol"
      )
      out
    },
    .px_add_labels = function(...) {
      rlang::abort("Labels unavailable", class = "mongolstats_http_error")
    }
  )
  out <- suppressWarnings(nso_package(
    list(list(tbl_id = "T", selections = list(Year = "2024"))),
    labels = "en"
  ))
  expect_equal(nrow(out), 0L)
  failure <- nso_provenance(out)$failures[[1]]
  expect_equal(failure$stage, "labels")
  expect_equal(failure$completed_records[[1]]$source, "Survey")
  expect_equal(failure$completed_status$value_raw, "..")
  expect_equal(failure$request_index, 1L)
})

test_that("provenance identifies the effective successful PX endpoint", {
  local_mocked_bindings(
    .px_table_meta = function(...) {
      list(
        meta = list(
          variables = list(
            list(
              code = "YEAR",
              text = "Year",
              values = list("0"),
              valueTexts = list("2024")
            )
          )
        ),
        paths = "Sector",
        px_file = "T.px"
      )
    },
    .px_session_cookie = function(...) NULL,
    .nso_perform = function(req) {
      if (grepl("[.]px$", req$url)) {
        rlang::abort("Not found", class = "mongolstats_http_error")
      }
      httr2::response(
        200,
        url = req$url,
        body = charToRaw(paste0(
          '{"columns":[{"code":"YEAR","text":"Year","type":"d"},{"code":"V","text":"Value","type":"c"}],',
          '"data":[{"key":["0"],"values":["1"]}]}'
        ))
      )
    }
  )
  out <- nso_data("T", list())
  record <- nso_provenance(out)$records[[1]]
  expect_match(record$url, "/Sector/T$")
  expect_equal(record$responses[[1]]$url, record$url)
  expect_equal(
    record$responses[[1]]$request$query[[1]]$selection$values,
    I("0")
  )
})

test_that("PX response text cannot cause a local JSON file to be read", {
  path <- tempfile(fileext = ".json")
  on.exit(unlink(path), add = TRUE)
  writeLines('{"columns":[],"data":[]}', path)
  local_mocked_bindings(.nso_perform = function(req) {
    httr2::response(200, url = req$url, body = charToRaw(path))
  })
  error <- tryCatch(.px_post("T", "Sector", "T.px", list()), error = identity)
  expect_s3_class(error, "mongolstats_invalid_response")
})

test_that("failure sidecars also support a first failed chunk and no completed rows", {
  local_mocked_bindings(
    .px_table_meta = function(...) {
      list(
        meta = list(
          variables = list(
            list(
              code = "YEAR",
              text = "Year",
              values = list("0"),
              valueTexts = list("2024")
            )
          )
        ),
        paths = "Sector",
        px_file = "T.px"
      )
    },
    .px_session_cookie = function(...) NULL,
    .px_post = function(...) {
      rlang::abort("Unavailable", class = "mongolstats_http_error")
    }
  )
  error <- tryCatch(nso_data("T", list(Year = "2024")), error = identity)
  path <- tempfile(fileext = ".json")
  on.exit(unlink(path), add = TRUE)
  nso_write_manifest(error, path)
  failure <- nso_read_manifest(path)$failures[[1]]
  expect_equal(failure$chunk_index, 1L)
  expect_length(failure$responses, 0L)
  expect_equal(nrow(failure$completed_status), 0L)
})

test_that("direct labeling failures expose the completed fetch in their condition", {
  local_mocked_bindings(
    nso_px_data = function(...) {
      .nso_attach_provenance(
        tibble::tibble(value = 1),
        "pxweb",
        "T",
        "https://px.example/T"
      )
    },
    .px_add_labels = function(...) {
      rlang::abort("Unavailable", class = "mongolstats_http_error")
    }
  )
  error <- tryCatch(
    nso_data("T", list(Year = "2024"), labels = "en"),
    error = identity
  )
  failure <- nso_provenance(error)$failures[[1]]
  expect_equal(failure$stage, "labels")
  expect_equal(failure$completed_records[[1]]$result_rows, 1L)
})
