# Internal HTTP utilities for opendata.1212.mn

# Base URL and behavior are option-driven to allow overrides
# Default to HTTPS; users can set options(mongolstats.base_url = "http://...") if needed
.nso_base_url <- function() {
  getOption("mongolstats.base_url", default = "https://opendata.1212.mn")
}

.nso_user_agent <- function() {
  ver <- tryCatch(as.character(utils::packageVersion("mongolstats")), error = function(e) "dev")
  paste0("mongolstats/", ver)
}

.nso_timeout <- function() {
  as.numeric(getOption("mongolstats.timeout", default = 30))
}

.nso_retry_tries <- function() {
  as.integer(getOption("mongolstats.retry_tries", default = 3L))
}

.nso_retry_backoff <- function() {
  # returns a formula or numeric used by httr2::req_retry backoff
  getOption("mongolstats.retry_backoff", default = ~ runif(1, 0.25, 0.75) * 2 ^ (..attempt - 1))
}

.nso_verbose <- function() {
  isTRUE(getOption("mongolstats.verbose", FALSE))
}

.nso_req <- function(path, query = list(type = "json")) {
  req <- httr2::request(.nso_base_url()) |>
    httr2::req_url_path_append(path) |>
    httr2::req_user_agent(.nso_user_agent()) |>
    httr2::req_headers(Accept = "application/json, text/json") |>
    httr2::req_url_query(!!!query) |>
    httr2::req_timeout(.nso_timeout()) |>
    httr2::req_retry(max_tries = .nso_retry_tries(), backoff = .nso_retry_backoff())
  if (.nso_verbose()) {
    url <- tryCatch(httr2::req_url(req), error = function(e) NA_character_)
    message("mongolstats: GET/POST setup for ", url)
  }
  req
}

.nso_perform <- function(req) {
  # Perform request; raise typed error on HTTP failure
  resp <- tryCatch(httr2::req_perform(req), error = function(e) e)
  if (inherits(resp, "error")) {
    cond <- structure(list(message = resp$message, call = NULL),
                      class = c("mongolstats_http_error", "error", "condition"))
    stop(cond)
  }
  status <- httr2::resp_status(resp)
  if (!is.null(status) && status >= 400) {
    desc <- tryCatch(httr2::resp_status_desc(resp), error = function(e) "HTTP error")
    url  <- tryCatch(httr2::req_url(httr2::resp_request(resp)), error = function(e) NA_character_)
    msg  <- paste0("mongolstats HTTP ", status, ": ", desc, if (!is.na(url)) paste0(" [", url, "]") else "")
    cond <- structure(list(message = msg, call = NULL, status = status),
                      class = c("mongolstats_http_error", "error", "condition"))
    stop(cond)
  }
  resp
}

.nso_get <- function(path, query = list(type = "json")) {
  resp <- .nso_req(path, query = query) |>
    .nso_perform()
  txt <- httr2::resp_body_string(resp)
  jsonlite::fromJSON(txt, simplifyVector = FALSE)
}

.nso_post <- function(path, body, query = list(type = "json")) {
  req <- .nso_req(path, query = query) |>
    httr2::req_body_json(body)
  resp <- .nso_perform(req)
  txt <- httr2::resp_body_string(resp)
  jsonlite::fromJSON(txt, simplifyVector = FALSE)
}

.compact <- function(x) {
  # drop NULL elements recursively
  if (is.list(x)) {
    x <- x[!vapply(x, is.null, logical(1))]
    x <- lapply(x, .compact)
  }
  x
}

.as_tibble_df <- function(x) {
  # turn a list of records into a tibble (empty safe)
  if (is.null(x) || length(x) == 0) return(tibble::tibble())
  tibble::as_tibble(jsonlite::fromJSON(jsonlite::toJSON(x), simplifyVector = TRUE))
}
