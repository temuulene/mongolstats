library(testthat)

# Source package files so tests can run without installation
invisible(lapply(list.files("R", full.names = TRUE), source))

testthat::test_dir("tests/testthat", reporter = "summary")
