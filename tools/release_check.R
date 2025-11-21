#!/usr/bin/env Rscript
cat("Running release checks...\n")
pkgs <- c("rcmdcheck", "urlchecker")
inst <- rownames(installed.packages())
miss <- setdiff(pkgs, inst)
if (length(miss)) {
  install.packages(miss, repos = "https://cloud.r-project.org")
}

try(
  {
    urlchecker::url_check()
  },
  silent = TRUE
)

try(
  {
    rcmdcheck::rcmdcheck(
      args = c('--as-cran', '--no-manual'),
      error_on = 'warning'
    )
  },
  silent = FALSE
)
cat("Done.\n")
