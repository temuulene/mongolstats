#!/usr/bin/env Rscript
options(warn = 1)
cat("FULLSITE: starting pkgdown site build\n")

pkg_root <- normalizePath(".")
user_lib <- file.path(pkg_root, ".Rlib")
if (!dir.exists(user_lib)) dir.create(user_lib, recursive = TRUE)
.libPaths(c(user_lib, .libPaths()))
cat("FULLSITE: using lib =", .libPaths()[1], "\n")

need <- c("pkgdown","knitr","rmarkdown","roxygen2")
avail <- rownames(installed.packages(lib.loc = .libPaths()[1]))
miss <- setdiff(need, intersect(need, avail))
if (length(miss)) {
  cat("FULLSITE: installing packages:", paste(miss, collapse=", "), "\n")
  install.packages(miss, repos = "https://cloud.r-project.org", lib = .libPaths()[1], dependencies = TRUE)
}

ensure_pandoc <- function() {
  suppressMessages(requireNamespace("rmarkdown", quietly = TRUE))
  found <- rmarkdown::pandoc_available()
  if (!found) {
    cand <- c(
      Sys.getenv("RSTUDIO_PANDOC", unset = NA_character_),
      "C:/Program Files/Pandoc",
      "C:/Program Files/Quarto/bin/tools"
    )
    cand <- unique(na.omit(cand))
    for (d in cand) {
      if (nzchar(d) && dir.exists(d)) {
        Sys.setenv(RSTUDIO_PANDOC = d)
        if (rmarkdown::pandoc_available()) {
          found <- TRUE
          break
        }
      }
    }
  }
  info <- rmarkdown::find_pandoc()
  v <- tryCatch(as.character(info$version), error = function(e) NA_character_)
  d <- tryCatch(if (is.null(info$dir)) "" else as.character(info$dir), error = function(e) "")
  cat("FULLSITE: pandoc version=", v, " dir=", d, "\n", sep = "")
  found
}

has_pandoc <- ensure_pandoc()

cat("FULLSITE: regenerating Rd via roxygen2\n")
try(roxygen2::roxygenise(), silent = FALSE)

if (!has_pandoc) {
  stop("Pandoc not available; cannot build pkgdown site.")
}

cat("FULLSITE: building pkgdown site into ./docs\n")
pkgdown::build_site(preview = FALSE, install = FALSE)
cat("FULLSITE: done\n")

