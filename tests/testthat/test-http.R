# Error classes from the HTTP layer. Both tests run offline.

test_that("the default retry delay does not need stats on the search path", {
  withr::local_options(mongolstats.retry_backoff = NULL)
  backoff <- .nso_retry_backoff()
  environment(backoff) <- baseenv()
  delay <- rlang::as_function(backoff)(1L)
  expect_type(delay, "double")
  expect_gte(delay, 0.25)
  expect_lte(delay, 0.75)
})

test_that("network failures raise mongolstats_http_error, not offline error", {
  skip_on_cran()
  old <- options(
    mongolstats.px_base_url = "http://127.0.0.1:9/api/v1",
    mongolstats.retry_tries = 1L,
    mongolstats.timeout = 2
  )
  on.exit(options(old), add = TRUE)
  err <- tryCatch(.px_list(character(), lang = "en"), error = function(e) e)
  expect_s3_class(err, "mongolstats_http_error")
  expect_false(inherits(err, "mongolstats_offline_error"))
})

test_that("HTTP errors include the request URL", {
  skip_on_cran()
  old <- options(
    mongolstats.px_base_url = "http://127.0.0.1:9/api/v1",
    mongolstats.retry_tries = 1L,
    mongolstats.timeout = 2
  )
  on.exit(options(old), add = TRUE)
  err <- tryCatch(.px_list(character(), lang = "en"), error = function(e) e)
  expect_s3_class(err, "mongolstats_http_error")
  expect_match(conditionMessage(err), "127.0.0.1", fixed = TRUE)
})

test_that("verbose mode logs the request URL", {
  skip_on_cran()
  old <- options(
    mongolstats.px_base_url = "http://127.0.0.1:9/api/v1",
    mongolstats.verbose = TRUE,
    mongolstats.retry_tries = 1L,
    mongolstats.timeout = 2
  )
  on.exit(options(old), add = TRUE)
  expect_message(
    tryCatch(.px_list(character(), lang = "en"), error = function(e) NULL),
    "127.0.0.1"
  )
})

test_that("offline mode raises mongolstats_offline_error", {
  withr::local_options(mongolstats.offline = TRUE)
  expect_error(
    .px_list(character(), lang = "en"),
    class = "mongolstats_offline_error"
  )
})

test_that("upstream error text is not interpolated as a cli template", {
  local_mocked_bindings(
    req_perform = function(req, ...) stop("server said {oops}"),
    .package = "httr2"
  )
  err <- tryCatch(.px_list(character(), lang = "en"), error = function(e) e)
  expect_s3_class(err, "mongolstats_http_error")
  expect_match(conditionMessage(err), "server said {oops}", fixed = TRUE)
})

test_that("NSO request spacing has a one-second floor", {
  withr::local_options(mongolstats.request_interval = 0.01)
  expect_equal(.nso_request_interval(), 1)
  withr::local_options(mongolstats.request_interval = 2)
  expect_equal(.nso_request_interval(), 2)
  expect_true(.nso_is_nso_url("https://metadata.nso.mn/api/database"))
  expect_true(.nso_is_nso_url("https://data.1212.mn/api/v1/en"))
  expect_false(.nso_is_nso_url("https://metadata.nso.mn.example/api"))
  expect_false(.nso_is_nso_url("https://px/en/table.px"))
})

test_that("request reservations persist across scheduling calls", {
  directory <- withr::local_tempdir()
  now <- 100
  sleeps <- numeric()
  local_mocked_bindings(
    .nso_clock = function() now,
    .nso_sleep = function(seconds) {
      sleeps <<- c(sleeps, seconds)
      now <<- now + seconds
    }
  )
  .nso_rate_schedule(directory, 1)
  .nso_rate_schedule(directory, 1)
  .nso_rate_schedule(directory, 2)
  expect_equal(sleeps, c(1, 2))
  expect_equal(as.numeric(readLines(file.path(directory, "last-request"))), 103)
})

test_that("each retry is scheduled and the request lock is released on error", {
  skip_if_not_installed("filelock")
  directory <- withr::local_tempdir()
  withr::local_options(mongolstats.rate_limit_dir = directory)
  attempts <- 0L
  local_mocked_bindings(.nso_rate_schedule = function(...) {
    attempts <<- attempts + 1L
  })
  local_mocked_bindings(
    req_perform = function(...) {
      signalCondition(structure(
        list(message = "attempt"),
        class = c("httr2_perform", "condition")
      ))
      signalCondition(structure(
        list(message = "attempt"),
        class = c("httr2_perform", "condition")
      ))
      stop("unavailable")
    },
    .package = "httr2"
  )
  expect_error(
    .nso_perform(.nso_request("https://data.nso.mn/api/indicator")),
    class = "mongolstats_http_error"
  )
  expect_equal(attempts, 2L)
  lock <- filelock::lock(file.path(directory, "requests.lock"), timeout = 0)
  expect_false(is.null(lock))
  filelock::unlock(lock)
})

test_that("offline requests do not create scheduling files", {
  directory <- file.path(tempdir(), paste0("request-offline-", Sys.getpid()))
  withr::local_options(
    mongolstats.offline = TRUE,
    mongolstats.rate_limit_dir = directory
  )
  expect_error(
    .nso_perform(.nso_request("https://metadata.nso.mn/api/database")),
    class = "mongolstats_offline_error"
  )
  expect_false(dir.exists(directory))
})

test_that("fixture hosts avoid the shared scheduler", {
  local_mocked_bindings(.nso_with_request_lock = function(...) {
    stop("unexpected lock")
  })
  local_mocked_bindings(
    req_perform = function(...) "fixture",
    .package = "httr2"
  )
  expect_identical(
    .nso_perform(.nso_request("https://px/en/table.px")),
    "fixture"
  )
})

test_that("NSO redirects are performed and scheduled separately", {
  skip_if_not_installed("filelock")
  withr::local_options(mongolstats.rate_limit_dir = withr::local_tempdir())
  attempts <- 0L
  requests <- list()
  local_mocked_bindings(.nso_rate_schedule = function(...) {
    attempts <<- attempts + 1L
  })
  local_mocked_bindings(
    req_perform = function(req, ...) {
      requests[[length(requests) + 1L]] <<- req
      signalCondition(structure(
        list(message = "attempt"),
        class = c("httr2_perform", "condition")
      ))
      if (length(requests) == 1L) {
        httr2::response(
          status_code = 303,
          headers = list(location = "/api/new")
        )
      } else {
        httr2::response(status_code = 200)
      }
    },
    .package = "httr2"
  )
  req <- .nso_request("https://data.nso.mn/api/old") |>
    httr2::req_body_json(list(query = "value"))
  response <- .nso_perform(req)
  expect_equal(httr2::resp_status(response), 200)
  expect_equal(attempts, 2L)
  expect_false(requests[[1]]$options$followlocation)
  expect_identical(requests[[2]]$url, "https://data.nso.mn/api/new")
  expect_identical(requests[[2]]$method, "GET")
  expect_null(requests[[2]]$body)
})

test_that("redirects cannot disclose NSO credentials to another service", {
  skip_if_not_installed("filelock")
  withr::local_options(mongolstats.rate_limit_dir = withr::local_tempdir())
  local_mocked_bindings(
    req_perform = function(req, ...) {
      httr2::response(
        status_code = 307,
        headers = list(location = "https://other.example/path")
      )
    },
    .package = "httr2"
  )
  expect_error(
    .nso_perform(.nso_request("https://data.nso.mn/api/old")),
    "outside the NSO services"
  )
})

test_that("cross-host NSO redirects drop sensitive headers and retain 307 bodies", {
  skip_if_not_installed("filelock")
  withr::local_options(mongolstats.rate_limit_dir = withr::local_tempdir())
  requests <- list()
  local_mocked_bindings(
    req_perform = function(req, ...) {
      requests[[length(requests) + 1L]] <<- req
      if (length(requests) == 1L) {
        httr2::response(
          status_code = 307,
          headers = list(location = "https://metadata.nso.mn/api/new")
        )
      } else {
        httr2::response(status_code = 200)
      }
    },
    .package = "httr2"
  )
  req <- .nso_request("https://data.nso.mn/api/old") |>
    httr2::req_body_json(list(query = "value")) |>
    httr2::req_headers(Cookie = "session=private", Authorization = "private")
  .nso_perform(req)
  expect_null(requests[[2]]$headers$Cookie)
  expect_null(requests[[2]]$headers$Authorization)
  expect_identical(requests[[2]]$body, requests[[1]]$body)
})

test_that("request lock waiting is bounded by the validated timeout", {
  skip_if_not_installed("filelock")
  withr::local_options(mongolstats.timeout = 2)
  observed <- NULL
  local_mocked_bindings(
    lock = function(path, timeout, ...) {
      observed <<- timeout
      NULL
    },
    .package = "filelock"
  )
  expect_error(
    .nso_with_request_lock(TRUE, withr::local_tempdir()),
    "scheduling lock"
  )
  expect_equal(observed, 2000)
})

test_that("absolute NSO domain names retain scheduling and redirect protection", {
  expect_true(.nso_is_nso_url("https://data.nso.mn./api/indicator"))
  expect_true(.nso_is_nso_url("https://DATA.1212.MN.:443/api/v1/en/"))
  expect_false(.nso_is_nso_url("https://data.nso.mn.example./api/indicator"))
  skip_if_not_installed("filelock")
  withr::local_options(mongolstats.rate_limit_dir = withr::local_tempdir())
  attempts <- 0L
  local_mocked_bindings(.nso_rate_schedule = function(...) {
    attempts <<- attempts + 1L
  })
  local_mocked_bindings(
    req_perform = function(req, ...) {
      signalCondition(structure(
        list(message = "attempt"),
        class = c("httr2_perform", "condition")
      ))
      httr2::response(status_code = 200)
    },
    .package = "httr2"
  )
  expect_equal(
    httr2::resp_status(.nso_perform(.nso_request(
      "https://data.nso.mn./api/indicator"
    ))),
    200
  )
  expect_equal(attempts, 1L)
})
