test_that("numeric observations keep the original source symbols", {
  values <- c("0", "..", "...", NA, "", " 2.5 ", "Inf", "unknown")
  out <- .nso_parse_values(values)
  expect_identical(out$value_raw, values)
  expect_equal(out$value, c(0, NA, NA, NA, NA, 2.5, NA, NA))
  expect_equal(
    out$value_status,
    c(
      "observed",
      "symbol",
      "symbol",
      "missing",
      "missing",
      "observed",
      "symbol",
      "symbol"
    )
  )
})

test_that("PX parsing exposes symbol status without changing default columns", {
  payload <- list(
    columns = list(
      list(code = "A", text = "Area", type = "d"),
      list(code = "V", text = "Value", type = "c")
    ),
    data = list(
      list(key = list("x"), values = list("..")),
      list(key = list("y"), values = list("0"))
    )
  )
  out <- .px_flatten_response(payload)
  expect_named(out, c("Area", "value"))
  expect_equal(nso_value_status(out)$value_raw, c("..", "0"))
  expect_equal(nso_value_status(out)$value_status, c("symbol", "observed"))
})

test_that("multiple content values cannot be silently discarded", {
  payload <- list(
    columns = list(
      list(code = "A", text = "Area", type = "d"),
      list(code = "V", text = "First", type = "c"),
      list(code = "W", text = "Second", type = "c")
    ),
    data = list(list(key = list("x"), values = list("10", "20")))
  )
  expect_s3_class(
    tryCatch(.px_flatten_response(payload), error = identity),
    "mongolstats_invalid_response"
  )
})

test_that("malformed PX objects cannot be mistaken for empty data", {
  payloads <- list(
    list(error = "unavailable"),
    list(),
    NULL,
    TRUE,
    list(columns = NULL, data = list()),
    list(columns = list(), data = NULL),
    list(columns = "unavailable", data = list()),
    list(columns = list(), data = "unavailable"),
    list(columns = list(TRUE), data = list()),
    list(columns = list(), data = list(TRUE))
  )
  for (payload in payloads) {
    error <- tryCatch(.px_flatten_response(payload), error = identity)
    expect_s3_class(error, "mongolstats_invalid_response")
  }
  empty <- .px_flatten_response(list(
    columns = list(
      list(code = "A", text = "Area", type = "d"),
      list(code = "V", text = "Value", type = "c")
    ),
    data = list()
  ))
  expect_s3_class(empty, "tbl_df")
  expect_equal(nrow(empty), 0L)
})

test_that("malformed PX fetches preserve the typed error and failure context", {
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
      httr2::response(200, url = req$url, body = charToRaw("{}"))
    }
  )
  error <- tryCatch(nso_data("T", list(Year = "2024")), error = identity)
  expect_s3_class(error, "mongolstats_invalid_response")
  failure <- nso_provenance(error)$failures[[1]]
  expect_equal(failure$selections$Year, "2024")
  expect_equal(failure$resolved_selections$YEAR$label, "2024")
  expect_equal(failure$chunk_index, 1L)
  expect_length(failure$requests, 1L)
})
