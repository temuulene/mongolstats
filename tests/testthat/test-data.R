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

# Large selections and time labels ----------------------------------------

test_that(".px_chunk_selections() keeps every request under the cell limit", {
  sel <- list(A = as.character(1:10), B = as.character(1:4), C = "x")
  expect_equal(.px_chunk_selections(sel, 100), list(sel))
  chunks <- .px_chunk_selections(sel, 12)
  expect_true(all(vapply(chunks, function(s) prod(lengths(s)), numeric(1)) <= 12))
  # Together the chunks cover exactly the original cells
  cells <- function(s) do.call(paste, expand.grid(s, stringsAsFactors = FALSE))
  expect_setequal(unlist(lapply(chunks, cells)), cells(sel))
  expect_equal(sum(vapply(chunks, function(s) prod(lengths(s)), numeric(1))), 40)
  # A limit below one value of the largest dimension splits the next one too
  expect_true(all(vapply(.px_chunk_selections(sel, 3), function(s) prod(lengths(s)), numeric(1)) <= 3))
})

fake_px_response <- function(sel) {
  grid <- expand.grid(sel, stringsAsFactors = FALSE)
  list(
    columns = list(
      list(code = "SEX", text = "Sex", type = "d"),
      list(code = "YEAR", text = "Year", type = "d"),
      list(code = "c1", text = "Population", type = "c")
    ),
    data = lapply(seq_len(nrow(grid)), function(i) {
      list(key = list(grid$SEX[i], grid$YEAR[i]), values = list(as.character(i)))
    })
  )
}

local_fake_fetch <- function(env = parent.frame()) {
  calls <- new.env()
  calls$n <- 0L
  testthat::local_mocked_bindings(
    .px_table_meta = function(tbl_id, lang = "en", ...) {
      list(
        meta = list(variables = list(
          list(code = "SEX", text = "Sex", values = list("0", "1"), valueTexts = list("Total", "Male")),
          list(code = "YEAR", text = "Year", values = list("0", "1", "2"), valueTexts = list("2025", "2024", "2023"))
        )),
        px_file = "T.px", paths = character(), row = tibble::tibble(px_path = "")
      )
    },
    .px_session_cookie = function(...) NULL,
    .px_post = function(tbl_id, paths, px_file, body, ...) {
      calls$n <- calls$n + 1L
      sel <- stats::setNames(
        lapply(body$query, function(q) as.character(q$selection$values)),
        vapply(body$query, function(q) q$code, character(1))
      )
      fake_px_response(sel)
    },
    .package = "mongolstats",
    .env = env
  )
  calls
}

test_that("nso_data() reports the time dimension by label", {
  local_fake_fetch()
  out <- nso_data("T", list(Year = c("2024", "2023")))
  expect_setequal(out$Year, c("2024", "2023"))
  expect_setequal(out$Sex, c("0", "1"))
  out_en <- nso_data("T", list(Year = "2025"), labels = "en")
  expect_equal(unique(out_en$Year_en), "2025")
  expect_setequal(out_en$Sex_en, c("Total", "Male"))
})

test_that("nso_data() splits requests above mongolstats.max_cells", {
  calls <- local_fake_fetch()
  whole <- nso_data("T", list())
  expect_equal(calls$n, 1L)
  withr::local_options(mongolstats.max_cells = 2)
  parts <- nso_data("T", list(), include_raw = TRUE)
  expect_equal(calls$n, 1L + 3L)
  expect_equal(nrow(parts), 6)
  expect_setequal(paste(parts$Sex, parts$Year), paste(whole$Sex, whole$Year))
  expect_length(attr(parts, "px_raw"), 3)
})

test_that("nso_package(parallel = TRUE) runs in-process without mirai daemons", {
  skip_if_not_installed("mirai")
  skip_if_not_installed("carrier")
  skip_if(mirai::daemons_set())
  local_mocked_bindings(
    .nso_package_fetch = function(r, labels, value_name, opts) {
      tibble::tibble(tbl_id = r$tbl_id, value = 1)
    }
  )
  reqs <- list(list(tbl_id = "A", selections = list()), list(tbl_id = "B", selections = list()))
  expect_message(out <- nso_package(reqs, parallel = TRUE), class = "mongolstats_no_daemons")
  expect_equal(out$tbl_id, c("A", "B"))
})

test_that("nso_package(parallel = TRUE) fetches on mirai daemons", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("mirai")
  skip_if_not_installed("carrier")
  # Daemons load the installed package, which matches this code only
  # during R CMD check
  skip_if_not(identical(Sys.getenv("_R_CHECK_PACKAGE_NAME_"), "mongolstats"))
  mirai::daemons(2)
  withr::defer(mirai::daemons(0))
  reqs <- lapply(c("2023", "2024"), function(y) {
    list(tbl_id = "DT_NSO_0300_001V2", selections = list(Sex = "Total", Age = "Total", Year = y))
  })
  out <- nso_package(reqs, parallel = TRUE, labels = "en")
  expect_setequal(out$Year, c("2023", "2024"))
  expect_true(all(out$Sex_en == "Total"))
})
