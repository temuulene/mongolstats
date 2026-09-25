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
  expect_snapshot(nso_options(mongolstats.default_labels = "english"), error = TRUE)
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
