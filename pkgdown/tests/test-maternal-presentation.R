testthat::test_that("unavailable maternal estimates do not produce an empty comparison", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env(parent = globalenv())
  env$run_vignette <- TRUE
  env$mmr_units <- tibble::tibble(
    Region = mongolmaps::mn_aimags()$nso_code,
    Region_en = mongolmaps::mn_aimags()$name,
    mmr = NA_real_, lower = NA_real_, upper = NA_real_
  )
  env$mmr_period <- "2015-2024"
  env$national_mmr <- tibble::tibble(mmr = 31)
  lines <- readLines(file.path(root, "vignettes", "mapping.Rmd"), encoding = "UTF-8")
  text <- c("```{r setup, message=FALSE}", "library(mongolmaps)", "library(dplyr)", "library(ggplot2)", "```", "")
  for (label in c("maternal-map", "maternal-intervals")) {
    start <- grep(paste0("^```\\{r ", label, ","), lines)[[1]]
    end <- which(lines == "```" & seq_along(lines) > start)[[1]]
    text <- c(text, lines[seq.int(start, end)], "")
  }
  old <- knitr::opts_chunk$get()
  on.exit(knitr::opts_chunk$restore(old), add = TRUE)
  directory <- withr::local_tempdir()
  knitr::opts_chunk$set(eval = TRUE, fig.path = paste0(directory, "/maternal-"))
  rendered <- knitr::knit(text = text, envir = env, quiet = TRUE)
  testthat::expect_match(rendered, "No area has a complete observed estimate", fixed = TRUE)
  testthat::expect_match(rendered, 'alt="No area has a complete observed estimate', fixed = TRUE)
  testthat::expect_length(list.files(directory, pattern = "[.]png$"), 2L)
})
