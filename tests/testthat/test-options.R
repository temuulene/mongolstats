test_that("nso_options sets and gets options", {
  old <- nso_options(mongolstats.lang = "mn")
  on.exit(options(old), add = TRUE)
  expect_equal(getOption("mongolstats.lang"), "mn")
})

test_that("nso_options value can be verified with getOption", {
  old <- nso_options(mongolstats.lang = "en")
  on.exit(options(old), add = TRUE)
  expect_equal(getOption("mongolstats.lang"), "en")
})

test_that("nso_options() rejects invalid values without changing options", {
  before <- nso_options()
  expect_snapshot(nso_options(mongolstats.lang = "fr"), error = TRUE)
  expect_snapshot(
    nso_options(mongolstats.default_labels = "english"),
    error = TRUE
  )
  expect_snapshot(nso_options(mongolstats.timeout = -1), error = TRUE)
  expect_snapshot(nso_options(mongolstats.retry_tries = 0), error = TRUE)
  expect_snapshot(nso_options(mongolstats.offline = "yes"), error = TRUE)
  expect_identical(nso_options(), before)
})

test_that("nso_options() warns about unknown option names", {
  expect_snapshot(old <- nso_options(mongolstats.langauge = "mn"))
  on.exit(options(old), add = TRUE)
})

test_that(".px_lang() errors on an unsupported language set via options()", {
  old <- options(mongolstats.lang = "fr")
  on.exit(options(old), add = TRUE)
  expect_snapshot(.px_lang(), error = TRUE)
})

test_that(".nso_progress returns logical", {
  expect_type(.nso_progress(), "logical")
})

test_that("offline enable/disable toggles option", {
  nso_offline_enable()
  on.exit(nso_offline_disable(), add = TRUE)
  expect_true(getOption("mongolstats.offline"))
  nso_offline_disable()
  expect_false(getOption("mongolstats.offline"))
})

test_that("numeric options reject non-finite values atomically", {
  before <- nso_options()
  for (nm in c(
    "timeout",
    "max_cells",
    "max_values",
    "retry_tries",
    "request_interval"
  )) {
    for (value in c(Inf, -Inf, NaN)) {
      dots <- stats::setNames(list(value), paste0("mongolstats.", nm))
      expect_error(do.call(nso_options, dots), "must be")
    }
  }
  expect_error(nso_options(mongolstats.request_interval = 0), "must be")
  expect_error(nso_options(mongolstats.retry_backoff = Inf), "must be")
  expect_identical(nso_options(), before)
})

test_that("service and scheduling options propagate to workers", {
  old <- nso_options(
    mongolstats.portal_base_url = "https://portal.example",
    mongolstats.metadata_base_url = "https://metadata.example",
    mongolstats.rate_limit_dir = tempdir(),
    mongolstats.request_interval = 2,
    mongolstats.max_values = 2500
  )
  on.exit(options(old), add = TRUE)
  captured <- .nso_capture_options()
  expect_equal(captured$mongolstats.portal_base_url, "https://portal.example")
  expect_equal(
    captured$mongolstats.metadata_base_url,
    "https://metadata.example"
  )
  expect_equal(captured$mongolstats.rate_limit_dir, tempdir())
  expect_equal(captured$mongolstats.request_interval, 2)
  expect_equal(captured$mongolstats.max_values, 2500)
  expect_error(nso_options(mongolstats.portal_base_url = ""), "must be")
  expect_error(
    nso_options(mongolstats.metadata_base_url = NA_character_),
    "must be"
  )
})

test_that("request constructors validate options set directly", {
  withr::local_options(mongolstats.timeout = Inf)
  expect_error(.nso_request("https://data.nso.mn/api/indicator"), "must be")
})

test_that("duplicated option names are rejected before any change", {
  before <- nso_options()
  on.exit(options(before), add = TRUE)
  expect_error(
    nso_options(mongolstats.timeout = 2, mongolstats.timeout = Inf),
    "unique"
  )
  expect_identical(nso_options(), before)
  expect_error(
    nso_options(mongolstats.lang = "mn", mongolstats.lang = "en"),
    "unique"
  )
  expect_identical(nso_options(), before)
})

test_that("numeric retry backoff constructs a constant-delay request", {
  withr::local_options(mongolstats.retry_backoff = 0)
  expect_s3_class(
    .nso_request("https://data.nso.mn/api/indicator"),
    "httr2_request"
  )
  backoff <- .nso_retry_backoff()
  expect_type(backoff, "closure")
  expect_equal(backoff(1L), 0)
  expect_equal(backoff(5L), 0)
  withr::local_options(mongolstats.retry_backoff = 2.5)
  expect_equal(.nso_retry_backoff()(3L), 2.5)
})
