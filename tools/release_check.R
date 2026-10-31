#!/usr/bin/env Rscript
# Check the built source that will be submitted, including its PDF manual.
required <- c("pkgbuild", "rcmdcheck", "urlchecker")
missing <- required[
  !vapply(required, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing)) {
  stop("Install release tools with pak: ", paste(missing, collapse = ", "))
}
urlchecker::url_check(parallel = FALSE)
arguments <- commandArgs(trailingOnly = TRUE)
source_path <- if (length(arguments)) arguments[[1]] else "."
rcmdcheck::rcmdcheck(
  path = source_path,
  args = "--as-cran",
  env = c("_R_CHECK_CRAN_INCOMING_REMOTE_" = "true"),
  error_on = "warning"
)
