skip_if_no_mock_dir <- function(name) {
  p <- testthat::test_path(name)
  if (!dir.exists(p)) {
    testthat::skip(paste("missing mock dir:", name))
  }
  files <- list.files(
    p,
    all.files = TRUE,
    recursive = TRUE,
    include.dirs = FALSE
  )
  if (length(files) == 0) testthat::skip(paste("empty mock dir:", name))
}

skip_if_offline_env <- function() {
  if (!curl::has_internet()) testthat::skip("offline")
}

# Replay recorded PXWeb fixtures from tests/testthat/<dir>.
#
# Real PXWeb URLs embed the catalogue folder path, which makes fixture paths
# longer than the 100 bytes R CMD build can store portably (the fixtures were
# silently dropped from the built package). During replay, table URLs are
# shortened to https://px/<lang>/<table file>; tools/record_fixtures.R
# renames freshly recorded files to the same short layout.
with_px_fixtures <- function(dir, code) {
  testthat::skip_if_not_installed("httptest2")
  skip_if_no_mock_dir(dir)
  testthat::local_mocked_bindings(
    .px_url = function(..., lang = .px_lang(), db = .px_db()) {
      segs <- unlist(list(...), recursive = TRUE, use.names = FALSE)
      paste(c("https://px", lang, utils::tail(segs, 1)), collapse = "/")
    },
    .package = "mongolstats"
  )
  httptest2::with_mock_dir(dir, code)
}
