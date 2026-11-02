testthat::test_that("the mortality article executes offline and updates a non-December peak", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  directory <- withr::local_tempdir()
  env <- new.env(parent = globalenv())
  periods <- format(seq(as.Date("2016-01-01"), as.Date("2025-12-01"), by = "month"), "%Y-%m")
  aimags <- as.character(101:121)
  regional <- tidyr::expand_grid(Region = c("5", aimags), Month_en = periods)
  month <- as.integer(substr(regional$Month_en, 6, 7))
  # January is deliberately the peak, unlike the old frozen narrative.
  regional$value <- 20 + match(regional$Region, c("5", aimags)) + ifelse(month == 1L, 30, month %% 3)
  national <- dplyr::summarise(regional, value = sum(value), .by = "Month_en")
  national$Region <- "0"
  all_months <- dplyr::bind_rows(regional, national)
  all_months$Region_en <- all_months$Region
  all_months$Month <- all_months$Month_en
  env$nso_dim_values <- function(tbl_id, dim, labels = "en") {
    if (dim == "Month") {
      return(tibble::tibble(code = periods, label_en = periods))
    }
    if (dim == "Region") {
      return(tibble::tibble(code = c("0", "5", aimags), label_en = c("Total", "Capital", aimags)))
    }
    if (dim == "Year") {
      return(tibble::tibble(code = as.character(2016:2025), label_en = as.character(2016:2025)))
    }
    names <- c("Deaths", "Injury and poisoning", "cardiovascular", "respiratory", "digestive", "Cancer", "Other")
    tibble::tibble(code = as.character(0:6), label_en = names)
  }
  env$nso_data <- function(tbl_id, selections, labels = "en") {
    if (tbl_id == "DT_NSO_2100_027V1") {
      causes <- tidyr::expand_grid(Indicator = as.character(0:6), Year_en = as.character(2016:2025))
      names <- c("Deaths", "Injury and poisoning", "cardiovascular", "respiratory", "digestive", "Cancer", "Other")
      causes$Indicator_en <- names[as.integer(causes$Indicator) + 1L]
      causes$value <- c(10000, 1000, 3000, 500, 500, 2000, 3000)[as.integer(causes$Indicator) + 1L]
      return(causes)
    }
    data <- all_months[all_months$Region %in% selections$Region & all_months$Month_en %in% selections$Month, ]
    if (tbl_id == "DT_NSO_2100_027V3") data$value <- floor(data$value * 0.4)
    data
  }
  old_chunks <- knitr::opts_chunk$get()
  old_knit <- knitr::opts_knit$get()
  on.exit(
    {
      knitr::opts_chunk$restore(old_chunks)
      knitr::opts_knit$restore(old_knit)
    },
    add = TRUE
  )
  withr::local_envvar(c(IN_PKGDOWN = "true", NOT_CRAN = "", `_R_CHECK_PACKAGE_NAME_` = ""))
  knitr::opts_chunk$set(eval = TRUE, purl = TRUE, fig.path = paste0(directory, "/figure-"))
  knitr::opts_knit$set(root.dir = root)
  output <- file.path(directory, "mortality.md")
  knitr::knit(file.path(root, "vignettes", "articles", "mortality-analysis.Rmd"),
    output = output, envir = env, quiet = TRUE
  )
  testthat::expect_equal(env$peak_month$month, 1L)
  testthat::expect_equal(env$peak_no_covid$month, 1L)
  testthat::expect_true(all(env$hospital_pair$nonhospital_deaths >= 0))
  text <- paste(readLines(output), collapse = "\n")
  testthat::expect_match(text, "highest equal-year monthly mean is in January")
  testthat::expect_equal(length(list.files(directory, pattern = "[.]svg$")), 9L)
})
