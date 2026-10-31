#!/usr/bin/env Rscript
source("tools/site_helpers.R")
args <- commandArgs(trailingOnly = TRUE)
directory <- if (length(args)) args[[1]] else "docs"
result <- check_site(directory)
print(result$figures, row.names = FALSE)
cat("Checked", result$html_pages, "HTML pages; no broken local references.\n")
jsonlite::write_json(
  result,
  file.path(directory, "site-checks.json"),
  auto_unbox = TRUE,
  pretty = TRUE
)
