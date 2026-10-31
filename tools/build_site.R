#!/usr/bin/env Rscript
# Use the recorded documentation tool versions for reproducible output.
site_lib <- Sys.getenv("MONGOLSTATS_SITE_LIB")
if (nzchar(site_lib)) {
  dir.create(site_lib, recursive = TRUE, showWarnings = FALSE)
  .libPaths(c(site_lib, .libPaths()))
}

pak::pkg_install(c("pkgdown@2.1.3", "roxygen2@8.0.0", "local::."), ask = FALSE)
if (!rmarkdown::pandoc_available()) {
  stop("Pandoc is required to build the website.")
}
roxygen2::roxygenise()
source("tools/render_site.R")
build_package_site()
