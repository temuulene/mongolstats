#!/usr/bin/env Rscript
options(warn=1)
cat("PKGDOWN: installing deps and building site\n")
user_lib <- file.path(normalizePath("."), ".Rlib")
if (!dir.exists(user_lib)) dir.create(user_lib, recursive = TRUE)
.libPaths(c(user_lib, .libPaths()))

need <- c("pkgdown","knitr","rmarkdown")
avail <- rownames(installed.packages(lib.loc = .libPaths()[1]))
miss <- setdiff(need, intersect(need, avail))
if (length(miss)) install.packages(miss, repos = "https://cloud.r-project.org", lib = .libPaths()[1], dependencies = TRUE)

if (rmarkdown::pandoc_available()) {
  try(pkgdown::build_site(preview = FALSE, install = TRUE), silent = FALSE)
} else {
  message("Pandoc not available; skipping site build. Install Pandoc or RStudio.")
}
cat("PKGDOWN: done\n")
