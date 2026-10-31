.nso_service_url <- function(service, ..., query = list()) {
  service <- match.arg(service, c("portal", "metadata"))
  base <- getOption(
    paste0("mongolstats.", service, "_base_url"),
    paste0(
      "https://",
      if (service == "portal") "data" else "metadata",
      ".nso.mn"
    )
  )
  parsed <- tryCatch(httr2::url_parse(base), error = function(e) NULL)
  if (
    is.null(parsed) ||
      !parsed$scheme %in% c("http", "https") ||
      !nzchar(parsed$hostname %||% "") ||
      nzchar(parsed$username %||% "") ||
      nzchar(parsed$password %||% "") ||
      nzchar(parsed$query %||% "") ||
      nzchar(parsed$fragment %||% "")
  ) {
    cli_abort(
      "The {.field {service}} service base URL must be an HTTP URL without credentials, a query, or a fragment."
    )
  }
  segments <- as.character(unlist(list(...), use.names = FALSE))
  if (
    anyNA(segments) ||
      any(
        !nzchar(segments) |
          segments %in% c(".", "..") |
          grepl("[/\\\\]", segments)
      )
  ) {
    cli_abort(
      "Service path segments must be non-empty identifiers without path separators."
    )
  }
  if (!length(segments) || segments[1] != "api") {
    segments <- c("api", segments)
  }
  url <- paste(
    c(sub("/+$", "", base), vapply(segments, curl::curl_escape, character(1))),
    collapse = "/"
  )
  req <- httr2::request(url)
  if (length(query)) {
    req <- do.call(httr2::req_url_query, c(list(req), query))
  }
  req$url
}

.nso_service_json <- function(service, ..., query = list(), body = NULL) {
  url <- .nso_service_url(service, ..., query = query)
  req <- .nso_request(url)
  if (!is.null(body)) {
    req <- httr2::req_body_json(req, body)
  }
  resp <- .nso_perform(req)
  tryCatch(
    jsonlite::parse_json(
      .px_strip_bom(httr2::resp_body_string(resp)),
      simplifyVector = FALSE
    ),
    error = function(e) {
      cli_abort(
        "The {.field {service}} service returned invalid JSON.",
        class = c("mongolstats_invalid_response", "mongolstats_http_error"),
        parent = e
      )
    }
  )
}
