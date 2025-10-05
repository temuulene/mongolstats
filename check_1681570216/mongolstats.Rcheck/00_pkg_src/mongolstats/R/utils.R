#' @keywords internal
#' @noRd
.ms_to_chr <- function(v, n) {
  if (is.null(v) || length(v) == 0) return(rep(NA_character_, n))
  if (is.list(v)) return(vapply(v, function(x) if (length(x)) as.character(x[[1]]) else NA_character_, character(1)))
  as.character(v)
}

#' @keywords internal
#' @noRd
.nso_progress <- function() {
  isTRUE(getOption("mongolstats.progress", TRUE))
}
