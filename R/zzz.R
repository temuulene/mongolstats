.onLoad <- function(libname, pkgname) {
  op <- options()
  op.mongolstats <- list(
    mongolstats.base_url = "https://opendata.1212.mn",
    mongolstats.timeout = 30,
    mongolstats.retry_tries = 3L,
    mongolstats.retry_backoff = NULL, # use default from R/http.R when NULL
    mongolstats.verbose = FALSE,
    mongolstats.default_labels = "none"
  )
  to_set <- !(names(op.mongolstats) %in% names(op))
  if (any(to_set)) options(op.mongolstats[to_set])
  invisible()
}

