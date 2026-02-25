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
