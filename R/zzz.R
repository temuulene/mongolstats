.onLoad <- function(libname, pkgname) {
  op <- options()
  op.mongolstats <- list(
    mongolstats.px_base_url = "https://data.1212.mn/api/v1",
    mongolstats.portal_base_url = "https://data.nso.mn",
    mongolstats.metadata_base_url = "https://metadata.nso.mn",
    mongolstats.lang = "en",
    mongolstats.px_db = "NSO",
    mongolstats.timeout = 30,
    mongolstats.retry_tries = 3L,
    mongolstats.retry_backoff = NULL, # use default from R/http.R when NULL
    mongolstats.verbose = FALSE,
    mongolstats.offline = FALSE,
    mongolstats.progress = TRUE,
    mongolstats.parallel = FALSE,
    mongolstats.default_labels = "none",
    mongolstats.value_name = "value",
    mongolstats.attach_raw = FALSE,
    mongolstats.max_cells = 1e6,
    mongolstats.max_values = 3000,
    mongolstats.request_interval = 1,
    mongolstats.rate_limit_dir = file.path(tools::R_user_dir("mongolstats", "cache"), "requests")
  )
  to_set <- !(names(op.mongolstats) %in% names(op))
  if (any(to_set)) {
    options(op.mongolstats[to_set])
  }
  invisible()
}
