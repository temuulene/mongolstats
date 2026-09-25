## Package options helper

#' Set or get mongolstats options
#'
#' Convenience wrapper around [base::options()] for mongolstats.
#'
#' @param ... Named options to set. If empty, returns a named list of current
#'   mongolstats options.
#' @return Invisibly, the previous values of the options changed, or a list of
#'   current values when called with no arguments.
#' @examples
#' # Get all current mongolstats options
#' nso_options()
#'
#' # Set an option (save old value for restoration)
#' old <- nso_options(mongolstats.default_labels = "en")
#'
#' # Restore original value
#' options(old)
#' @export
nso_options <- function(...) {
  dots <- list(...)
  if (!length(dots)) {
    return(invisible(.nso_capture_options()))
  }
  old <- lapply(names(dots), getOption)
  names(old) <- names(dots)
  do.call(options, dots)
  invisible(old)
}

.nso_option_names <- c(
  "mongolstats.px_base_url",
  "mongolstats.lang",
  "mongolstats.px_db",
  "mongolstats.timeout",
  "mongolstats.retry_tries",
  "mongolstats.retry_backoff",
  "mongolstats.verbose",
  "mongolstats.offline",
  "mongolstats.default_labels",
  "mongolstats.progress",
  "mongolstats.parallel",
  "mongolstats.value_name",
  "mongolstats.attach_raw"
)

# Current values of all package options as a named list suitable for
# options(); unset options are NULL.
.nso_capture_options <- function() {
  stats::setNames(lapply(.nso_option_names, getOption), .nso_option_names)
}
