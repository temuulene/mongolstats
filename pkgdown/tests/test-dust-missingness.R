testthat::test_that("dust charts handle a source with no complete observed station-years", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env(parent = globalenv())
  sys.source(file.path(root, "inst", "examples", "analysis-helpers.R"), envir = env)
  env$dust_fixture <- tidyr::expand_grid(
    `Station location` = c("A", "B"), Month_en = sprintf("2024-%02d", 1:12)
  ) |>
    dplyr::mutate(`Station location_en` = rep(c("Ulaanbaatar", "Darkhan"), each = 12), value = NA_real_)
  env$nso_data <- function(...) env$dust_fixture
  # Evaluate the actual article chunks so empty results also exercise the joins
  # and plotting code, not just the numerical helper.
  lines <- readLines(file.path(root, "vignettes", "environmental-surveillance.Rmd"), encoding = "UTF-8")
  text <- c("```{r setup}", "library(mongolstats)", "library(mongolmaps)",
            "library(dplyr)", "library(tidyr)", "library(ggplot2)", "library(stringr)", "```", "")
  for (label in c("dust-days", "dust-map")) {
    start <- grep(paste0("^```\\{r ", label, ","), lines)[[1]]
    end <- which(lines == "```" & seq_along(lines) > start)[[1]]
    text <- c(text, lines[seq.int(start, end)], "")
  }
  directory <- withr::local_tempdir()
  old <- knitr::opts_chunk$get()
  on.exit(knitr::opts_chunk$restore(old), add = TRUE)
  knitr::opts_chunk$set(eval = TRUE, fig.path = paste0(directory, "/dust-"))
  knitr::knit(text = text, envir = env, quiet = TRUE)
  testthat::expect_equal(nrow(env$dust_summary), 0L)
  testthat::expect_true(all(is.na(env$dust_annual$dust_days)))
  testthat::expect_equal(nrow(env$dust_points), 0L)
  testthat::expect_equal(length(list.files(directory, pattern = "[.]png$")), 2L)
})
