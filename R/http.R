# Internal HTTP utilities for NSO endpoints (PXWeb)

.nso_user_agent <- function() {
  ver <- tryCatch(
    as.character(utils::packageVersion("mongolstats")),
    error = function(e) "dev"
  )
  paste0("mongolstats/", ver)
}

.nso_timeout <- function() {
  as.numeric(getOption("mongolstats.timeout", default = 30))
}

.nso_retry_tries <- function() {
  as.integer(getOption("mongolstats.retry_tries", default = 3L))
}

.nso_retry_backoff <- function() {
  # returns a function/formula or numeric used by httr2::req_retry backoff;
  # as an rlang lambda the attempt number is `.x` (`..attempt` does not
  # exist and crashed the request on the first retry)
  getOption(
    "mongolstats.retry_backoff",
    default = ~ runif(1, 0.25, 0.75) * 2^(.x - 1)
  )
}

.nso_verbose <- function() {
  isTRUE(getOption("mongolstats.verbose", FALSE))
}

.nso_offline <- function() {
  isTRUE(getOption("mongolstats.offline", FALSE))
}

.nso_perform <- function(req) {
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
  resp <- tryCatch(httr2::req_perform(req), error = function(e) e)
  if (inherits(resp, "error")) {
    status <- if (inherits(resp, "httr2_http")) {
      tryCatch(httr2::resp_status(resp$resp), error = function(e) NULL)
    } else {
      NULL
    }
    # The upstream message travels as the parent condition. Pasting it into
    # the cli template instead would parse any literal `{` in a server or
    # curl message as a glue expression and crash the error itself.
    detail <- paste0( # nolint object_usage_linter. Used in cli_abort() below.
      if (!is.null(status)) paste0(" (status ", status, ")"),
      if (!is.null(req$url)) paste0(" [", req$url, "]")
    )
    cli_abort(
      "mongolstats HTTP error{detail}.",
      class = "mongolstats_http_error",
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
#' # Enable offline mode
#' nso_offline_enable()
#'
#' # Check the option was set
#' getOption("mongolstats.offline")
#'
#' # Disable to restore normal operation
#' nso_offline_disable()
#' @export
nso_offline_enable <- function() {
  options(mongolstats.offline = TRUE)
  invisible(TRUE)
}

#' Disable offline mode
#'
#' @return Invisibly, `TRUE`.
#' @examples
#' nso_offline_disable()
#' @export
nso_offline_disable <- function() {
  options(mongolstats.offline = FALSE)
  invisible(TRUE)
}
