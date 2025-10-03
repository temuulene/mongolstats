.px_strip_bom <- function(x) {
  if (is.character(x) && length(x) == 1L) {
    sub("^\\ufeff", "", x)
  } else {
    x
  }
}

.px_first_nonempty <- function(...) {
  args <- list(...)
  for (a in args) {
    if (is.null(a) || !length(a)) next
    val <- as.character(a)[1]
    if (!is.na(val) && nzchar(val)) return(val)
  }
  NULL
}

