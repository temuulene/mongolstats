.nso_parse_values <- function(values) {
  raw <- as.character(values)
  value <- suppressWarnings(as.numeric(raw))
  observed <- is.finite(value)
  missing <- is.na(raw) | !nzchar(trimws(raw))
  value[!observed] <- NA_real_
  tibble::tibble(
    value_raw = raw,
    value_status = ifelse(
      missing,
      "missing",
      ifelse(observed, "observed", "symbol")
    ),
    value = value
  )
}

#' Inspect source values and observation status
#'
#' Returns source values separately from numeric observations. Unknown source
#' symbols are preserved without assigning them an undocumented meaning.
#' Status is `"observed"` for finite numbers, `"missing"` for empty or missing
#' values, and `"symbol"` for other source text, including non-finite numbers.
#' Save this table alongside transformed or exported data because ordinary
#' transformations may discard attributes.
#'
#' @param x A result from [nso_data()], [nso_fetch()], [nso_package()], or
#'   [nso_portal_data()].
#' @return A tibble containing observation keys, `value_raw`, and `value_status`,
#'   or an empty tibble if source status was not retained.
#' @examples
#' # Constructed records illustrate numeric values and an unresolved symbol.
#' observations <- data.frame(
#'   period = c("2023", "2024"),
#'   value = c(12, NA_real_),
#'   value_raw = c("12", ".."),
#'   value_status = c("observed", "symbol")
#' )
#' nso_value_status(observations)
#'
#' # Ordinary data without retained status have no source-value records.
#' nso_value_status(data.frame(value = 12))
#' @export
nso_value_status <- function(x) {
  status <- attr(x, "nso_value_status", exact = TRUE)
  if (!is.null(status)) {
    return(status)
  }
  if (is.data.frame(x) && all(c("value_raw", "value_status") %in% names(x))) {
    return(tibble::as_tibble(x))
  }
  tibble::tibble()
}
