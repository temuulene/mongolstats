# Internal HTTP utilities for NSO endpoints (PXWeb)

.nso_user_agent <- function() {
  ver <- tryCatch(
    as.character(utils::packageVersion("mongolstats")),
    error = function(e) "dev"
  )
  paste0("mongolstats/", ver)
}

.nso_timeout <- function() {
  value <- getOption("mongolstats.timeout", default = 30)
  .nso_check_option("mongolstats.timeout", value)
  as.numeric(value)
}

.nso_retry_tries <- function() {
  value <- getOption("mongolstats.retry_tries", default = 3L)
  .nso_check_option("mongolstats.retry_tries", value)
  as.integer(value)
}

.nso_retry_backoff <- function() {
  # returns a function/formula or numeric used by httr2::req_retry backoff;
  # as an rlang lambda the attempt number is `.x` (`..attempt` does not
  # exist and crashed the request on the first retry)
  value <- getOption(
    "mongolstats.retry_backoff",
    default = ~ stats::runif(1, 0.25, 0.75) * 2^(.x - 1)
  )
  .nso_check_option("mongolstats.retry_backoff", value)
  if (is.numeric(value)) {
    return(function(attempt) value)
  }
  value
}

.nso_verbose <- function() {
  isTRUE(getOption("mongolstats.verbose", FALSE))
}

.nso_offline <- function() {
  isTRUE(getOption("mongolstats.offline", FALSE))
}

# Largest number of cells requested in one PXWeb query; bigger selections
# are split (data.1212.mn reports maxCells = 1,000,000 at /api/v1/en/?config).
.nso_max_cells <- function() {
  value <- getOption("mongolstats.max_cells", default = 1e6)
  .nso_check_option("mongolstats.max_cells", value)
  as.numeric(value)
}

.nso_url_host <- function(url) {
  sub("\\.$", "", tolower(httr2::url_parse(url)$hostname %||% ""))
}

# All NSO hosts share the same schedule because the service policy is per IP.
.nso_is_nso_url <- function(url) {
  grepl("(^|\\.)(nso\\.mn|1212\\.mn)$", .nso_url_host(url))
}

.nso_request_interval <- function() {
  value <- getOption("mongolstats.request_interval", default = 1)
  .nso_check_option("mongolstats.request_interval", value)
  config <- .mongolstats_config_env[[.nso_config_key()]]
  allowance <- if (is.null(config)) 1 else config$timeWindow / config$maxCalls
  max(1, as.numeric(value), allowance)
}

.nso_rate_dir <- function() {
  value <- getOption(
    "mongolstats.rate_limit_dir",
    default = file.path(tools::R_user_dir("mongolstats", "cache"), "requests")
  )
  .nso_check_option("mongolstats.rate_limit_dir", value)
  value
}

.nso_clock <- function() as.numeric(Sys.time())
.nso_sleep <- function(seconds) Sys.sleep(seconds)

# Called with requests.lock held, once before each actual network attempt.
# Keeping the timestamp on disk coordinates independently launched workers.
.nso_rate_schedule <- function(directory, interval) {
  stamp <- file.path(directory, "last-request")
  previous <- tryCatch(
    suppressWarnings(as.numeric(readLines(stamp, n = 1L, warn = FALSE))),
    error = function(e) numeric()
  )
  now <- .nso_clock()
  if (length(previous) == 1L && is.finite(previous)) {
    # A backwards clock adjustment should not create an unbounded wait.
    previous <- min(previous, now)
    delay <- previous + interval - now
    if (delay > 0) .nso_sleep(delay)
  }
  writeLines(sprintf("%.6f", .nso_clock()), stamp)
  invisible(NULL)
}

.nso_with_request_lock <- function(code, directory = .nso_rate_dir()) {
  if (!dir.exists(directory)) {
    dir.create(directory, recursive = TRUE, showWarnings = FALSE)
  }
  if (!dir.exists(directory)) {
    cli_abort("Cannot create request scheduling directory {.path {directory}}.")
  }
  lock <- filelock::lock(
    file.path(directory, "requests.lock"),
    timeout = min(.nso_timeout() * 1000, .Machine$integer.max)
  )
  if (is.null(lock)) {
    cli_abort("Cannot acquire the NSO request scheduling lock.")
  }
  on.exit(filelock::unlock(lock), add = TRUE)
  force(code)
}

# Transparent curl redirects would bypass the per-attempt schedule. Follow
# them here instead, keeping transferred credentials within the original host.
.nso_perform_transfers <- function(req, path = NULL) {
  for (redirect in 0:10) {
    req <- httr2::req_options(req, followlocation = FALSE)
    resp <- httr2::req_perform(req, path = path)
    status <- httr2::resp_status(resp)
    if (!status %in% c(301L, 302L, 303L, 307L, 308L)) {
      return(resp)
    }
    location <- httr2::resp_header(resp, "location")
    if (redirect == 10L || is.null(location) || !nzchar(location)) {
      cli_abort(
        "NSO redirect limit reached or the redirect has no destination."
      )
    }
    next_req <- httr2::req_url_relative(req, location)
    if (!.nso_is_nso_url(next_req$url)) {
      cli_abort("NSO redirected the request outside the NSO services.")
    }
    current_url <- httr2::url_parse(req$url)
    next_url <- httr2::url_parse(next_req$url)
    downgrade <- identical(current_url$scheme, "https") &&
      !identical(next_url$scheme, "https")
    secure <- next_url$scheme %in% c("http", "https") && !downgrade
    if (!secure) {
      cli_abort("NSO redirected the request to an insecure destination.")
    }
    if (!identical(.nso_url_host(req$url), .nso_url_host(next_req$url))) {
      # A fresh request excludes cookie jars and authentication policies too.
      next_req <- .nso_request(next_req$url)
      next_req$body <- req$body
      next_req$fields <- req$fields
      next_req$method <- req$method
      keep <- !tolower(names(req$headers)) %in%
        c("authorization", "cookie", "proxy-authorization")
      next_req$headers <- req$headers[keep]
    }
    method <- req$method %||% if (is.null(req$body)) "GET" else "POST"
    if (
      status == 303L || (status %in% c(301L, 302L) && identical(method, "POST"))
    ) {
      next_req$body <- NULL
      next_req$fields <- list()
      next_req <- next_req |>
        httr2::req_headers(`Content-Type` = NULL, `Content-Length` = NULL) |>
        httr2::req_method("GET")
    }
    req <- next_req
  }
}

# Requests use the shared scheduler in .nso_perform(), including retries.
.nso_request <- function(url) {
  httr2::request(url) |>
    httr2::req_user_agent(.nso_user_agent()) |>
    httr2::req_timeout(.nso_timeout()) |>
    httr2::req_retry(
      max_tries = .nso_retry_tries(),
      backoff = .nso_retry_backoff()
    )
}

# `path`, when given, streams the response body to that file (see
# httr2::req_perform()).
.nso_perform <- function(req, path = NULL) {
  if (.nso_offline()) {
    cli_abort(
      "mongolstats is in offline mode; network requests are disabled.",
      class = "mongolstats_offline_error"
    )
  }
  if (.nso_verbose()) {
    url <- req$url %||% NA_character_ # nolint object_usage_linter. Used in cli_inform() below.
    cli_inform("mongolstats: request to {.url {url}}")
  }
  # Perform request; raise typed error on failure. httr2 already errors on
  # HTTP 4xx/5xx, so both transport and HTTP failures land here.
  perform <- function() .nso_perform_transfers(req, path = path)
  resp <- tryCatch(
    if (.nso_is_nso_url(req$url)) {
      directory <- .nso_rate_dir()
      interval <- .nso_request_interval()
      .nso_with_request_lock(
        withCallingHandlers(
          perform(),
          # httr2 signals this before every curl transfer, including retries
          # and authentication refreshes. Mock responses perform no transfer.
          httr2_perform = function(cnd) .nso_rate_schedule(directory, interval)
        ),
        directory = directory
      )
    } else {
      httr2::req_perform(req, path = path)
    },
    error = function(e) e
  )
  if (inherits(resp, "error")) {
    status <- if (inherits(resp, "httr2_http")) {
      tryCatch(httr2::resp_status(resp$resp), error = function(e) NULL)
    } else {
      NULL
    }
    # The upstream message travels as the parent condition. Pasting it into
    # the cli template instead would parse any literal `{` in a server or
    # curl message as a glue expression and crash the error itself.
    # nolint start: object_usage_linter. Used in cli_abort() below.
    detail <- paste0(
      if (!is.null(status)) paste0(" (status ", status, ")"),
      if (!is.null(req$url)) paste0(" [", req$url, "]")
    )
    # nolint end: object_usage_linter.
    cli_abort(
      "mongolstats HTTP error{detail}.",
      class = "mongolstats_http_error",
      status = status,
      parent = resp
    )
  }
  resp
}

#' Enable offline mode
#'
#' When enabled, HTTP requests are prevented and functions that require
#' the network will raise a clear offline error. Cached metadata can still
#' be used if already available via `nso_cache_enable()`.
#'
#' @return Invisibly, `TRUE`.
#' @examples
#' old <- nso_options(mongolstats.offline = FALSE)
#' # Enable offline mode
#' nso_offline_enable()
#'
#' # Check the option was set
#' getOption("mongolstats.offline")
#'
#' # Restore the original setting
#' options(old)
#' @export
nso_offline_enable <- function() {
  options(mongolstats.offline = TRUE)
  invisible(TRUE)
}

#' Disable offline mode
#'
#' @return Invisibly, `TRUE`.
#' @examples
#' old <- nso_options(mongolstats.offline = TRUE)
#' nso_offline_disable()
#' options(old)
#' @export
nso_offline_disable <- function() {
  options(mongolstats.offline = FALSE)
  invisible(TRUE)
}
