testthat::test_that("dust charts handle a source with no complete observed station-years", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env(parent = globalenv())
  env$run_vignette <- TRUE
  sys.source(file.path(root, "inst", "examples", "analysis-helpers.R"), envir = env)
  env$dust_fixture <- tidyr::expand_grid(
    `Station location` = c("A", "B"),
    Month_en = format(seq(as.Date("2005-01-01"), as.Date("2024-12-01"), by = "month"), "%Y-%m")
  ) |>
    dplyr::mutate(
      `Station location_en` = dplyr::if_else(`Station location` == "A", "Ulaanbaatar", "Darkhan"),
      value = NA_real_
    )
  env$nso_data <- function(...) env$dust_fixture
  # Evaluate the actual article chunks so empty results also exercise the joins
  # and plotting code, not just the numerical helper.
  lines <- readLines(file.path(root, "vignettes", "environmental-surveillance.Rmd"), encoding = "UTF-8")
  text <- c(
    "```{r setup}", "library(mongolstats)", "library(mongolmaps)",
    "library(dplyr)", "library(tidyr)", "library(ggplot2)", "library(stringr)", "```", ""
  )
  for (label in c("dust-data", "dust-days", "dust-map-data", "dust-map")) {
    start <- grep(paste0("^```\\{r ", label, "[,}]"), lines)[[1]]
    end <- which(lines == "```" & seq_along(lines) > start)[[1]]
    text <- c(text, lines[seq.int(start, end)], "")
  }
  directory <- withr::local_tempdir()
  old <- knitr::opts_chunk$get()
  on.exit(knitr::opts_chunk$restore(old), add = TRUE)
  knitr::opts_chunk$set(eval = TRUE, comment = "#>", fig.path = paste0(directory, "/dust-"))
  rendered <- knitr::knit(text = text, envir = env, quiet = TRUE)
  testthat::expect_lt(sum(grepl("^#>", strsplit(rendered, "\n")[[1]])), 50L)
  testthat::expect_match(rendered, "Usable years", fixed = TRUE)
  testthat::expect_match(rendered, "No complete observed station-years", fixed = TRUE)
  testthat::expect_match(rendered, 'alt="No complete observed station-years', fixed = TRUE)
  testthat::expect_equal(nrow(env$dust_summary), 0L)
  testthat::expect_true(all(is.na(env$dust_annual$dust_days)))
  testthat::expect_equal(nrow(env$dust_points), 0L)
  testthat::expect_equal(length(list.files(directory, pattern = "[.]png$")), 2L)
})
