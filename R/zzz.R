.onLoad <- function(libname, pkgname) {
  op <- options()
  op.mongolstats <- list(
    mongolstats.base_url = "https://data.1212.mn/pxweb",
    mongolstats.px_base_url = "https://data.1212.mn/api/v1",
    mongolstats.lang = "en",
    mongolstats.px_db = "NSO",
    mongolstats.timeout = 30,
    mongolstats.retry_tries = 3L,
    mongolstats.retry_backoff = NULL, # use default from R/http.R when NULL
    mongolstats.verbose = FALSE,
    mongolstats.offline = FALSE,
    mongolstats.progress = TRUE,
    mongolstats.default_labels = "none",
    mongolstats.value_name = "value",
    mongolstats.attach_raw = FALSE
  )
  to_set <- !(names(op.mongolstats) %in% names(op))
  if (any(to_set)) {
    options(op.mongolstats[to_set])
  }
  invisible()
}
