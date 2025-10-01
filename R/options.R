## Package options helper

#' Set or get mongolstats options
#'
#' Convenience wrapper around [base::options()] for mongolstats.
#'
#' @param ... Named options to set. If empty, returns a named list of current
#'   mongolstats options.
#' @return Invisibly, the previous values of the options changed, or a list of
#'   current values when called with no arguments.
#' @export
nso_options <- function(...) {
  opts_prefix <- c(
    "mongolstats.base_url",
    "mongolstats.timeout",
    "mongolstats.retry_tries",
    "mongolstats.retry_backoff",
    "mongolstats.verbose",
    "mongolstats.default_labels"
  )
  dots <- list(...)
  if (!length(dots)) {
    return(invisible(stats::setNames(lapply(opts_prefix, getOption), nm = opts_prefix)))
  }
  old <- lapply(names(dots), getOption)
  names(old) <- names(dots)
  do.call(options, dots)
  invisible(old)
}

