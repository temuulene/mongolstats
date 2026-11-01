render_gate <- function(name, envvars) {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  lines <- readLines(file.path(root, "vignettes", paste0(name, ".Rmd")))
  start <- grep("^```\\{r not-cran-check", lines)[[1]]
  end <- which(lines == "```" & seq_along(lines) > start)[[1]]
  setup <- lines[seq.int(start, end)]
  directory <- withr::local_tempdir(pattern = "mongolstats-rendering-")
  old <- knitr::opts_chunk$get()
  on.exit(knitr::opts_chunk$restore(old), add = TRUE)
  knitr::opts_chunk$set(
    eval = TRUE,
    purl = TRUE,
    fig.path = paste0(normalizePath(directory, winslash = "/"), "/figure-"),
    dev = "png"
  )
  document <- c(
    setup,
    "",
    "```{r rendering-regression, echo=FALSE}",
    "graphics::plot(1:3, main = 'Rendering regression')",
    "```"
  )
  withr::with_envvar(
    envvars,
    knitr::knit(text = document, envir = new.env(), quiet = TRUE)
  )
  length(list.files(directory, pattern = "[.]png$", recursive = TRUE))
}

articles <- c(
  "getting-started",
  "discovery",
  "mapping",
  "environmental-surveillance",
  "ub-health-environment",
  "articles/mortality-analysis"
)

for (article in articles) {
  local({
    name <- article
    testthat::test_that(
      paste(
        name,
        "renders figures in pkgdown with live reference examples disabled"
      ),
      {
        figures <- render_gate(
          name,
          c(IN_PKGDOWN = "true", NOT_CRAN = "", `_R_CHECK_PACKAGE_NAME_` = "")
        )
        testthat::expect_equal(figures, 1L)
      }
    )

    testthat::test_that(
      paste(name, "does not evaluate remote chunks during a package check"),
      {
        figures <- render_gate(
          name,
          c(
            IN_PKGDOWN = "true",
            NOT_CRAN = "true",
            `_R_CHECK_PACKAGE_NAME_` = "mongolstats"
          )
        )
        testthat::expect_equal(figures, 0L)
      }
    )
  })
}
