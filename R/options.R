## Package options helper

#' Set or get mongolstats options
#'
#' Convenience wrapper around [base::options()] for mongolstats. Values are
#' validated before anything is set: for example `mongolstats.lang` must be
#' `"en"` or `"mn"`, and `mongolstats.timeout` a positive number. Names that
#' are not mongolstats options are set with a warning, which catches typos.
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
  nms <- names(dots)
  if (is.null(nms) || any(!nzchar(nms))) {
    cli_abort("All arguments to {.fn nso_options} must be named.")
  }
  # Validate everything first so a bad value leaves all options untouched
  for (nm in nms) {
    .nso_check_option(nm, dots[[nm]])
  }
  unknown <- setdiff(nms, .nso_option_names)
  if (length(unknown)) {
    known <- .nso_option_names # nolint object_usage_linter. Used in cli_warn() below.
    cli_warn(c(
      "{.val {unknown}} {?is not a/are not} mongolstats option{?s}; set anyway.",
      "i" = "Known options: {.val {known}}."
    ))
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

# Validate one option value; NULL (unset) is always allowed. Options not
# listed here (e.g. mongolstats.retry_backoff, which may be a number, a
# function, or a formula) are not checked.
.nso_check_option <- function(name, value, call = rlang::caller_env()) {
  if (is.null(value)) {
    return(invisible())
  }
  is_flag <- function(x) is.logical(x) && length(x) == 1L && !is.na(x)
  is_string <- function(x) is.character(x) && length(x) == 1L && !is.na(x) && nzchar(x)
  is_positive <- function(x) is.numeric(x) && length(x) == 1L && !is.na(x) && x > 0
  choices <- list(
    mongolstats.lang = c("en", "mn"),
    mongolstats.default_labels = c("none", "code", "en", "mn", "both")
  )
  ok <- switch(name,
    mongolstats.lang = ,
    mongolstats.default_labels = is_string(value) && value %in% choices[[name]],
    mongolstats.px_base_url = ,
    mongolstats.px_db = ,
    mongolstats.value_name = is_string(value),
    mongolstats.timeout = is_positive(value),
    mongolstats.retry_tries = is_positive(value) && value == round(value),
    mongolstats.verbose = ,
    mongolstats.offline = ,
    mongolstats.progress = ,
    mongolstats.parallel = ,
    mongolstats.attach_raw = is_flag(value),
    TRUE
  )
  if (isTRUE(ok)) {
    return(invisible())
  }
  expected <- switch(name, # nolint object_usage_linter. Used in cli_abort() below.
    mongolstats.lang = ,
    mongolstats.default_labels = "one of {.or {.val {choices[[name]]}}}",
    mongolstats.px_base_url = ,
    mongolstats.px_db = ,
    mongolstats.value_name = "a single non-empty string",
    mongolstats.timeout = "a single positive number (seconds)",
    mongolstats.retry_tries = "a single positive whole number",
    "{.code TRUE} or {.code FALSE}"
  )
  got <- if (is.atomic(value) && length(value) == 1L) "{.val {value}}" else "{.obj_type_friendly {value}}"
  # `expected` and `got` are fixed templates from this function, never user text
  cli_abort(
    paste0("{.field {name}} must be ", expected, ", not ", got, "."),
    call = call
  )
}
