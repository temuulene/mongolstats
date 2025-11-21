## PXWeb client for data.1212.mn

.px_base_url <- function() {
  getOption("mongolstats.px_base_url", default = "https://data.1212.mn/api/v1")
}

.px_lang <- function() {
  lng <- getOption("mongolstats.lang", default = "en")
  if (!lng %in% c("en", "mn")) {
    lng <- "en"
  }
  lng
}

.px_db <- function() {
  getOption("mongolstats.px_db", default = "NSO")
}

.px_url <- function(..., lang = .px_lang(), db = .px_db()) {
  segs <- unlist(list(...), recursive = TRUE, use.names = FALSE)
  parts <- c(.px_base_url(), lang, db, segs)
  parts <- vapply(
    parts,
    function(p) gsub("^/+|/+$", "", as.character(p)),
    character(1)
  )
  if (length(parts) > 1) {
    parts[-1] <- vapply(parts[-1], curl::curl_escape, character(1))
  }
  paste(parts, collapse = "/")
}

#' List PXWeb children under a path
#' @importFrom utils head tail
#' @importFrom curl curl_escape
#' @keywords internal
.px_list <- function(paths = character(), lang = .px_lang()) {
  url <- do.call(.px_url, as.list(c(paths, lang = lang)))
  res <- httr2::request(url) |>
    httr2::req_user_agent(.nso_user_agent()) |>
    httr2::req_timeout(.nso_timeout()) |>
    httr2::req_retry(
      max_tries = .nso_retry_tries(),
      backoff = .nso_retry_backoff()
    ) |>
    .nso_perform()
  txt <- .px_strip_bom(httr2::resp_body_string(res))
  jsonlite::fromJSON(txt, simplifyVector = TRUE)
}

#' Get PXWeb table metadata
#' @keywords internal
.px_meta <- function(paths, table, lang = .px_lang()) {
  url <- .px_url(paths, table, lang = lang)
  res <- httr2::request(url) |>
    httr2::req_user_agent(.nso_user_agent()) |>
    httr2::req_timeout(.nso_timeout()) |>
    httr2::req_retry(
      max_tries = .nso_retry_tries(),
      backoff = .nso_retry_backoff()
    ) |>
    .nso_perform()
  txt <- .px_strip_bom(httr2::resp_body_string(res))
  jsonlite::fromJSON(txt, simplifyVector = FALSE)
}

# Internal cached wrappers
.px_list_cached <- function(paths = character(), lang = .px_lang()) {
  if (
    isTRUE(.mongolstats_cache_env$enabled) &&
      !is.null(.mongolstats_cache_env$px_list_memo)
  ) {
    .mongolstats_cache_env$px_list_memo(paths, lang)
  } else {
    .px_list(paths, lang)
  }
}

.px_meta_cached <- function(paths, table, lang = .px_lang()) {
  if (
    isTRUE(.mongolstats_cache_env$enabled) &&
      !is.null(.mongolstats_cache_env$px_meta_memo)
  ) {
    .mongolstats_cache_env$px_meta_memo(paths, table, lang)
  } else {
    .px_meta(paths, table, lang)
  }
}

.px_strip_bom <- function(x) {
  if (is.character(x) && length(x) > 0) {
    # Remove UTF-8 BOM if present
    if (startsWith(x, "\uFEFF")) {
      x <- substring(x, 2)
    }
  }
  x
}

.px_first_nonempty <- function(...) {
  args <- list(...)
  for (a in args) {
    if (!is.null(a) && length(a) > 0 && nzchar(as.character(a))) {
      return(as.character(a))
    }
  }
  NULL
}

.px_chr <- function(x) {
  if (is.null(x)) {
    return(character())
  }
  as.character(x)
}
