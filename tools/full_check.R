#!/usr/bin/env Rscript
options(warn = 1)
cat("FULLCHECK: starting full R CMD check with vignettes\n")

pkg_root <- normalizePath(".")
user_lib <- file.path(pkg_root, ".Rlib")
if (!dir.exists(user_lib)) {
  dir.create(user_lib, recursive = TRUE)
}
.libPaths(c(user_lib, .libPaths()))
cat("FULLCHECK: using lib =", .libPaths()[1], "\n")

need <- c("rcmdcheck", "roxygen2", "knitr", "rmarkdown")
avail <- rownames(installed.packages(lib.loc = .libPaths()[1]))
miss <- setdiff(need, intersect(need, avail))
if (length(miss)) {
  cat("FULLCHECK: installing packages:", paste(miss, collapse = ", "), "\n")
  install.packages(
    miss,
    repos = "https://cloud.r-project.org",
    lib = .libPaths()[1],
    dependencies = TRUE
  )
}

args <- commandArgs(trailingOnly = TRUE)
arg_vals <- setNames(rep(NA_character_, length(args)), rep("", length(args)))
if (length(args)) {
  for (a in args) {
    kv <- strsplit(a, "=", fixed = TRUE)[[1]]
    if (length(kv) == 2) arg_vals[kv[1]] <- kv[2]
  }
}

# Try to ensure Pandoc is discoverable by rmarkdown
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
  d <- tryCatch(
    if (is.null(info$dir)) "" else as.character(info$dir),
    error = function(e) ""
  )
  cat("FULLCHECK: pandoc version=", v, " dir=", d, "\n", sep = "")
  found
}

`%||%` <- function(x, y) if (is.null(x)) y else x

has_pandoc <- ensure_pandoc()

cat("FULLCHECK: regenerating Rd via roxygen2\n")
try(roxygen2::roxygenise(), silent = FALSE)

check_dir <- file.path(
  pkg_root,
  paste0("check_", as.integer(runif(1, 1e9, 2e9)))
)
dir.create(check_dir, showWarnings = FALSE)

args <- c("--no-manual", "--as-cran")
build_args <- NULL
if (!isTRUE(has_pandoc)) {
  cat("FULLCHECK: Pandoc not available, building without vignettes\n")
  build_args <- c("--no-build-vignettes")
}

cat("FULLCHECK: running rcmdcheck (this may take a while)\n")
# Suppress known benign warnings from system2("quarto", "-V") on Windows
res <- suppressWarnings(rcmdcheck::rcmdcheck(
  args = args,
  build_args = build_args,
  error_on = "never",
  check_dir = check_dir
))
cat("FULLCHECK: done\n")

status <- if (length(res$errors)) {
  "errors"
} else if (length(res$warnings)) {
  "warnings"
} else {
  "note-or-clean"
}
cat(sprintf(
  "FULLCHECK: summary: %d errors, %d warnings, %d notes\n",
  length(res$errors),
  length(res$warnings),
  length(res$notes)
))

if (length(res$errors)) {
  cat("Errors:\n")
  print(res$errors)
}
if (length(res$warnings)) {
  cat("Warnings:\n")
  print(res$warnings)
}
if (length(res$notes)) {
  cat("Notes:\n")
  print(res$notes)
}

invisible(TRUE)
