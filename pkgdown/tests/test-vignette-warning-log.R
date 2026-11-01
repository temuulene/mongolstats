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

testthat::test_that("website warning logging permits a fresh pkgdown destination", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env(parent = globalenv())
  sys.source(file.path(root, "tools", "render_site.R"), envir = env)
  directory <- withr::local_tempdir()
  destination <- file.path(directory, "site")
  previous_hook <- knitr::knit_hooks$get("warning")
  previous_option <- knitr::opts_hooks$get("warning")
  testthat::local_mocked_bindings(
    render = function(...) NULL, .package = "rmarkdown"
  )
  testthat::local_mocked_bindings(
    build_site = function(...) {
      testthat::expect_length(list.files(
        destination, all.files = TRUE,
        no.. = TRUE
      ), 0L)
      knitr::knit(text = c(
        "```{r fresh-site-warning, warning=FALSE}",
        "warning('fresh site warning retained')", "```"
      ), envir = new.env(), quiet = TRUE)
      stop("stop after initialization")
    },
    .package = "pkgdown"
  )
  withr::local_envvar(`_R_CHECK_PACKAGE_NAME_` = "")
  testthat::expect_error(
    env$build_package_site(root, destination), "stop after initialization"
  )
  log <- readLines(file.path(destination, "build-warnings.log"))
  testthat::expect_true(any(grepl("fresh site warning retained", log)))
  testthat::expect_identical(knitr::knit_hooks$get("warning"), previous_hook)
  testthat::expect_identical(knitr::opts_hooks$get("warning"), previous_option)
})
