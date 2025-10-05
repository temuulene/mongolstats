skip_if_no_mock_dir <- function(name) {
  p <- testthat::test_path(name)
  if (!dir.exists(p)) testthat::skip(paste("missing mock dir:", name))
  files <- list.files(p, all.files = TRUE, recursive = TRUE, include.dirs = FALSE)
  if (length(files) == 0) testthat::skip(paste("empty mock dir:", name))
}

skip_if_offline_env <- function() {
  if (!curl::has_internet()) testthat::skip("offline")
}
