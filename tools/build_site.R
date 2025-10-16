#!/usr/bin/env Rscript
options(warn = 1)
cat("PKGDOWN: installing deps and building site\n")
# Allow overriding the local library location via env var to avoid
# filesystem quirks (e.g., network mounts, permissions). Fallback to ./.Rlib.
user_lib <- Sys.getenv("MONGOLSTATS_SITE_LIB", unset = NA_character_)
if (is.na(user_lib) || !nzchar(user_lib)) {
  user_lib <- file.path(normalizePath("."), ".Rlib")
}
if (!dir.exists(user_lib)) {
  dir.create(user_lib, recursive = TRUE)
}
.libPaths(c(user_lib, .libPaths()))

need <- c(
  "pkgdown",
  "knitr",
  "rmarkdown",
  "roxygen2",
  "curl",
  "remotes",
  "pxweb"
)
avail <- rownames(installed.packages(lib.loc = .libPaths()[1]))
miss <- setdiff(need, intersect(need, avail))
if (length(miss)) {
  install.packages(
    miss,
    repos = "https://cloud.r-project.org",
    lib = .libPaths()[1],
    dependencies = NA
  )
}

if (rmarkdown::pandoc_available()) {
  # Refresh docs, install the local package into the project .Rlib, then build the site.
  try(roxygen2::roxygenise(), silent = FALSE)
  try(
    remotes::install_local(
      ".",
      upgrade = "never",
      lib = .libPaths()[1],
      dependencies = NA
    ),
    silent = FALSE
  )
  try(pkgdown::build_site(preview = FALSE, install = FALSE), silent = FALSE)
} else {
  message(
    "Pandoc not available; skipping site build. Install Pandoc or RStudio."
  )
}
cat("PKGDOWN: done\n")
