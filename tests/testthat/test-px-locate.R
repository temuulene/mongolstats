# Tables that moved folder, or that are newer than the embedded index

local_catalogue <- function(env = parent.frame()) {
  # A tiny catalogue: the table moved from "A" into "A/B"
  idx <- tibble::tibble(
    px_path = c("A", "Z"), px_file = c("T1.px", "T2.px"), tbl_id = c("T1", "T2"),
    tbl_eng_nm = c("Table one", "Table two"), tbl_nm = NA_character_,
    strt_prd = NA_character_, end_prd = NA_character_, list_id = c("A", "Z")
  )
  old <- .mongolstats_px_env$idx
  old_missing <- .mongolstats_px_env$missing
  .mongolstats_px_env$idx <- idx
  .mongolstats_px_env$missing <- NULL
  withr::defer(
    {
      .mongolstats_px_env$idx <- old
      .mongolstats_px_env$missing <- old_missing
    },
    envir = env
  )
  calls <- new.env()
  calls$list <- character()
  testthat::local_mocked_bindings(
    .px_meta_cached = function(paths, table, lang = "en") {
      if (identical(paste(paths, collapse = "/"), "A/B") && table == "T1.px") {
        return(list(title = "Table one", variables = list(list(
          code = "Year", text = "Year", values = list("0"), valueTexts = list("2025")
        ))))
      }
      cli::cli_abort("gone", class = "mongolstats_http_error", status = 400L)
    },
    .px_list_cached = function(paths = character(), lang = "en") {
      key <- paste(paths, collapse = "/")
      calls$list <- c(calls$list, key)
      if (!nzchar(key)) {
        return(data.frame(id = c("A", "Z"), type = "l", text = c("A", "Z")))
      }
      switch(key,
        "A" = data.frame(id = "B", type = "l", text = "B"),
        "A/B" = data.frame(id = "T1.px", type = "t", text = "Table one"),
        "Z" = data.frame(id = character(), type = character(), text = character())
      )
    },
    .px_search_remote = function(query, lang = "en") {
      data.frame(id = character(), path = character(), title = character())
    },
    .package = "mongolstats",
    .env = env
  )
  calls
}

test_that("a table that moved folder is found by walking the catalogue", {
  calls <- local_catalogue()
  expect_snapshot(tm <- .px_table_meta("T1"))
  expect_equal(tm$paths, c("A", "B"))
  expect_equal(tm$meta$title, "Table one")
  # The in-memory index now points at the new folder: no second search
  expect_equal(.px_resolve_table("T1")$row$px_path, "A/B")
  n_list <- length(calls$list)
  .px_table_meta("T1")
  expect_equal(length(calls$list), n_list)
  # The old folder's subtree was searched before the rest of the catalogue
  expect_equal(calls$list[1], "A")
})

test_that("a search hit is used when it checks out", {
  local_catalogue()
  local_mocked_bindings(
    .px_search_remote = function(query, lang = "en") {
      data.frame(id = c("T1.px", "T1.px"), path = c("/Stale", "/A/B"), title = "Table one")
    },
    .px_find_in_catalogue = function(...) stop("should not walk the catalogue")
  )
  expect_message(tm <- .px_table_meta("T1"), class = "mongolstats_table_moved")
  expect_equal(tm$paths, c("A", "B"))
})

test_that("a withdrawn table errors once and is not searched for again", {
  calls <- local_catalogue()
  expect_snapshot(.px_table_meta("T2"), error = TRUE)
  n_list <- length(calls$list)
  expect_error(.px_table_meta("T2"), class = "mongolstats_http_error")
  expect_equal(length(calls$list), n_list)
})

test_that("other HTTP errors are not treated as a moved table", {
  local_catalogue()
  local_mocked_bindings(
    .px_meta_cached = function(...) {
      cli::cli_abort("server down", class = "mongolstats_http_error", status = 503L)
    },
    .px_relocate_table = function(...) stop("should not relocate")
  )
  expect_error(.px_table_meta("T1"), "server down", class = "mongolstats_http_error")
})

test_that("a table missing from the index is looked up with the search API", {
  local_catalogue()
  local_mocked_bindings(
    .px_search_remote = function(query, lang = "en") {
      data.frame(id = "T9.px", path = "/A/B", title = "Table nine", score = 1)
    },
    .px_meta_cached = function(paths, table, lang = "en") list(title = "Table nine", variables = list())
  )
  expect_message(res <- .px_resolve_table("t9"), class = "mongolstats_table_located")
  expect_equal(res$px_file, "T9.px")
  expect_equal(res$paths, c("A", "B"))
  expect_true("T9" %in% .px_index()$tbl_id)
})

test_that("an unknown table still errors when the search finds nothing", {
  local_catalogue()
  expect_snapshot(.px_resolve_table("NOPE"), error = TRUE)
})

test_that("unknown tables are not looked up in offline mode", {
  local_catalogue()
  local_mocked_bindings(.px_search_remote = function(...) stop("network in offline mode"))
  withr::local_options(mongolstats.offline = TRUE)
  expect_error(.px_resolve_table("NOPE"), "not found")
})

test_that(".px_split_path() handles search-API paths", {
  expect_equal(.px_split_path("/A/B"), c("A", "B"))
  expect_equal(.px_split_path("A"), "A")
  expect_equal(.px_split_path(""), character())
  expect_equal(.px_split_path(NULL), character())
})

test_that("search hits that do not answer are skipped", {
  local_catalogue()
  local_mocked_bindings(
    .px_search_remote = function(query, lang = "en") {
      data.frame(id = "T9.px", path = "/Gone", title = "Table nine")
    }
  )
  expect_null(.px_locate_new_table("T9.px"))
})

test_that(".px_search_remote() parses hits and treats an empty answer as none", {
  respond <- function(body) {
    function(req, ...) {
      httr2::response(
        status_code = 200,
        headers = list(`Content-Type` = "application/json"),
        body = charToRaw(body)
      )
    }
  }
  local_mocked_bindings(.nso_perform = respond("[]"))
  expect_equal(nrow(.px_search_remote("nothing")), 0)
  local_mocked_bindings(
    .nso_perform = respond('[{"id":"T1.px","path":"/A/B","title":"Table one","score":1}]')
  )
  hits <- .px_search_remote("T1")
  expect_equal(hits$path, "/A/B")
})

test_that("a 400 for a table still in its folder is not reported as a move", {
  local_catalogue()
  # The listing shows T1 in "A/B", where the index already puts it, but its
  # metadata request fails: a server problem, not a move
  .mongolstats_px_env$idx$px_path[1] <- "A/B"
  local_mocked_bindings(
    .px_meta_cached = function(...) cli::cli_abort("bad request", class = "mongolstats_http_error", status = 400L)
  )
  classes <- character()
  withCallingHandlers(
    expect_error(.px_table_meta("T1"), "bad request", class = "mongolstats_http_error"),
    message = function(m) {
      classes <<- c(classes, class(m))
      invokeRestart("muffleMessage")
    }
  )
  expect_false("mongolstats_table_moved" %in% classes)
  expect_false("t1.px" %in% .mongolstats_px_env$missing)
})
