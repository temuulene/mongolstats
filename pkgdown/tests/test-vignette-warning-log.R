testthat::test_that("live article checks retain hidden warnings for maintainers", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env(parent = globalenv())
  sys.source(file.path(root, "tools", "check_vignettes.R"), envir = env)
  directory <- withr::local_tempdir()
  file <- file.path(directory, "warning-example.Rmd")
  writeLines(c(
    "```{r warning-example, warning=FALSE}",
    "warning('retained analytical warning')", "```"
  ), file)
  withr::local_envvar(`_R_CHECK_PACKAGE_NAME_` = "")
  env$check_vignettes(file.path(directory, "out"), files = file)
  log <- readLines(file.path(directory, "out", "build-warnings.log"))
  rendered <- readLines(file.path(directory, "out", "warning-example.md"))
  testthat::expect_true(any(grepl("retained analytical warning", log)))
  testthat::expect_false(any(grepl("## Warning", rendered)))
})
