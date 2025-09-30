# Internal HTTP utilities for opendata.1212.mn

nso_base_url <- "http://opendata.1212.mn"

.nso_user_agent <- function() {
  ver <- tryCatch(as.character(utils::packageVersion("mongolstats")), error = function(e) "dev")
  paste0("mongolstats/", ver)
}

.nso_req <- function(path, query = list(type = "json")) {
  httr2::request(nso_base_url) |>
    httr2::req_url_path_append(path) |>
    httr2::req_user_agent(.nso_user_agent()) |>
    httr2::req_headers(Accept = "application/json, text/json") |>
    httr2::req_url_query(!!!query) |>
    httr2::req_retry(max_tries = 3, backoff = ~ 0.5 * 2 ^ ..attempt)
}

.nso_get <- function(path, query = list(type = "json")) {
  resp <- .nso_req(path, query = query) |>
    httr2::req_perform()
  txt <- httr2::resp_body_string(resp)
  jsonlite::fromJSON(txt, simplifyVector = FALSE)
}

.nso_post <- function(path, body, query = list(type = "json")) {
  resp <- .nso_req(path, query = query) |>
    httr2::req_body_json(body) |>
    httr2::req_perform()
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
