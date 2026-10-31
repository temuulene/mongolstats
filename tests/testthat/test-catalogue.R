test_that("catalogue status distinguishes rows from distinct tables", {
  local_mocked_bindings(.px_index = function(...) {
    tibble::tibble(tbl_id = c("A", "A", "B"))
  })
  out <- nso_catalogue_status()
  expect_equal(out$entries, 3L)
  expect_equal(out$tables, 2L)
  expect_equal(out$backend, "pxweb")
})

test_that("live search includes records missing from the bundled index", {
  local_mocked_bindings(.px_search_remote = function(...) {
    data.frame(
      id = "NEW.px",
      path = "/Sector",
      title = "New series",
      published = "2026-10-19"
    )
  })
  out <- nso_search("New", live = TRUE)
  expect_equal(out$tbl_id, "NEW")
  expect_equal(out$tbl_eng_nm, "New series")
  expect_equal(attr(out, "catalogue")$coverage, "search_window")
})

test_that("a partial crawl does not replace a complete catalogue", {
  original <- .mongolstats_px_env$idx
  on.exit(.mongolstats_px_env$idx <- original, add = TRUE)
  .mongolstats_px_env$idx <- tibble::tibble(tbl_id = "COMPLETE")
  local_mocked_bindings(nso_px_tables = function() {
    out <- tibble::tibble(tbl_id = "PARTIAL")
    attr(out, "catalogue") <- list(
      coverage = "partial",
      failed_paths = "Sector"
    )
    out
  })
  path <- tempfile(fileext = ".json")
  on.exit(unlink(path), add = TRUE)
  err <- tryCatch(nso_rebuild_px_index(path), error = identity)
  expect_s3_class(err, "mongolstats_incomplete_index")
  expect_equal(.mongolstats_px_env$idx$tbl_id, "COMPLETE")
  expect_identical(file.exists(path), FALSE)
})

test_that("rebuilt catalogue metadata survives disk reload and matches its index", {
  original <- .mongolstats_px_env$idx
  on.exit(.mongolstats_px_env$idx <- original, add = TRUE)
  built <- list(
    coverage = "complete",
    failed_paths = character(),
    origin = "live_crawl",
    indexed_at = "2026-10-19T00:00:00Z"
  )
  local_mocked_bindings(nso_px_tables = function() {
    out <- tibble::tibble(tbl_id = "CURRENT")
    attr(out, "catalogue") <- built
    out
  })
  dir <- withr::local_tempdir()
  path <- file.path(dir, "index.json")
  nso_rebuild_px_index(path)
  .mongolstats_px_env$idx <- .px_index_read(path)
  expect_equal(attr(.mongolstats_px_env$idx, "catalogue"), built)
  expect_equal(nso_catalogue_status()$indexed_at, built$indexed_at)
  expect_equal(nso_catalogue_status()$coverage, "complete")
  expect_true(is.data.frame(jsonlite::fromJSON(path)))

  jsonlite::write_json(data.frame(tbl_id = "CHANGED"), path, dataframe = "rows")
  expect_null(attr(.px_index_read(path), "catalogue"))
  writeLines("false", paste0(path, ".metadata.json"))
  expect_null(attr(.px_index_read(path), "catalogue"))
})

test_that("catalogue files without a matching service stamp have unknown freshness", {
  dir <- withr::local_tempdir()
  path <- file.path(dir, "index.json")
  jsonlite::write_json(data.frame(tbl_id = "OLD"), path, dataframe = "rows")
  expect_equal(.px_index_read(path)$tbl_id, "OLD")
  expect_null(attr(.px_index_read(path), "catalogue"))
  stamp <- list(
    schema_version = 1L,
    index_sha256 = digest::digest(file = path, algo = "sha256"),
    base_url = "https://different.example/api",
    database = .px_db(),
    catalogue = list(
      coverage = "complete",
      indexed_at = "2026-10-19T00:00:00Z",
      failed_paths = character(),
      origin = "live_crawl"
    )
  )
  jsonlite::write_json(stamp, paste0(path, ".metadata.json"), auto_unbox = TRUE)
  expect_null(attr(.px_index_read(path), "catalogue"))
})

test_that("live search distinguishes an upstream error object from no matches", {
  body <- "{\"error\":\"Search index unavailable\"}"
  local_mocked_bindings(.nso_perform = function(...) {
    httr2::response(
      status_code = 200,
      headers = list(`content-type` = "application/json"),
      body = charToRaw(body),
      url = "https://data.1212.mn/api/v1/en/NSO"
    )
  })
  expect_error(
    nso_search("GDP", live = TRUE),
    class = "mongolstats_invalid_response"
  )
  body <- "[]"
  expect_equal(nrow(nso_search("nonexistent", live = TRUE)), 0L)
  body <- "{}"
  expect_error(
    nso_search("GDP", live = TRUE),
    class = "mongolstats_invalid_response"
  )
})
