test_that("nso_package() explains a bare record passed as `requests`", {
  expect_snapshot(
    nso_package(list(tbl_id = "DT_NSO_0300_001V2", selections = list())),
    error = TRUE
  )
})

test_that("nso_package() validates each record before fetching", {
  local_mocked_bindings(
    nso_px_data = function(...) stop("should not be called")
  )
  expect_snapshot(
    nso_package(list(list(selections = list(Year = "2024")))),
    error = TRUE
  )
  expect_snapshot(
    nso_package(list(list(tbl_id = "T", selections = "2024"))),
    error = TRUE
  )
  expect_snapshot(nso_package("T"), error = TRUE)
})

test_that("nso_package() workers run with the caller's options", {
  local_mocked_bindings(
    nso_px_data = function(tbl_id, selections, lang, ...) {
      tibble::tibble(lang = lang, offline = getOption("mongolstats.offline"))
    },
    .px_add_labels = function(df, ...) df
  )
  old <- options(mongolstats.lang = "en", mongolstats.offline = FALSE)
  on.exit(options(old), add = TRUE)
  # A parallel worker starts with the package defaults; the captured
  # options must be re-applied inside it and restored afterwards.
  opts <- list(mongolstats.lang = "mn", mongolstats.offline = TRUE)
  out <- .nso_package_fetch(
    list(tbl_id = "T", selections = list()),
    labels = "none",
    value_name = "value",
    opts = opts
  )
  expect_equal(out$lang, "mn")
  expect_true(out$offline)
  expect_equal(getOption("mongolstats.lang"), "en")
  expect_false(getOption("mongolstats.offline"))
})

test_that(".nso_capture_options() captures every package option", {
  opts <- .nso_capture_options()
  expect_setequal(names(opts), names(nso_options()))
  expect_equal(opts$mongolstats.lang, getOption("mongolstats.lang"))
})
