# Session cookie helpers -------------------------------------------------
# Some PXWeb servers require a session cookie (e.g., rxid) before accepting
# POST requests. Seeding it costs one GET, so cache it per base URL/language
# for the R session instead of re-seeding on every data fetch.

.px_cookie_key <- function(lang) {
  paste0(.px_base_url(), "|", lang)
}

.px_session_cookie <- function(paths, px_file, lang = .px_lang()) {
  # Offline mode must not fire the seeding GET (it bypasses .nso_perform())
  if (.nso_offline()) {
    return(NULL)
  }
  key <- .px_cookie_key(lang)
  if (is.null(.mongolstats_px_env$cookies)) {
    .mongolstats_px_env$cookies <- list()
  }
  hit <- .mongolstats_px_env$cookies[[key]]
  if (!is.null(hit)) {
    # NA_character_ is the cached "server sets no cookie" sentinel
    return(if (is.na(hit)) NULL else hit)
  }
  cookie <- NULL
  seeded <- FALSE
  try(
    {
      seed <- httr2::request(.px_url(paths, px_file, lang = lang)) |>
        httr2::req_user_agent(.nso_user_agent()) |>
        httr2::req_timeout(.nso_timeout()) |>
        httr2::req_retry(
          max_tries = .nso_retry_tries(),
          backoff = .nso_retry_backoff()
        ) |>
        httr2::req_perform()
      seeded <- TRUE
      setck <- tryCatch(
        httr2::resp_header(seed, "set-cookie"),
        error = function(e) NULL
      )
      if (!is.null(setck) && is.character(setck) && length(setck)) {
        rx <- regmatches(setck, regexpr("rxid=[^;]+", setck))
        if (length(rx) && nzchar(rx[1])) cookie <- rx[1]
      }
    },
    silent = TRUE
  )
  # Only cache when the seed request succeeded; a failed GET should not
  # pin "no cookie" for the whole session.
  if (seeded) {
    .mongolstats_px_env$cookies[[key]] <- cookie %||% NA_character_
  }
  cookie
}

.px_clear_session_cookie <- function(lang = .px_lang()) {
  key <- .px_cookie_key(lang)
  if (!is.null(.mongolstats_px_env$cookies)) {
    .mongolstats_px_env$cookies[[key]] <- NULL
  }
  invisible(NULL)
}

# Fetch data from a PXWeb table
# Returns tibble with one column per dimension plus a numeric `value` column.
nso_px_data <- function(tbl_id, selections, lang = .px_lang(), include_raw = FALSE, value_name = "value") {
  check_selections(selections)
  resolved <- .px_resolve_table(tbl_id)
  px_file <- resolved$px_file
  paths <- resolved$paths
  meta <- .px_meta_cached(paths, px_file, lang = lang)
  vars <- meta$variables
  # Map selections to codes first; errors on unknown dimensions/values
  # before any further network activity.
  resolved_sel <- .px_map_selections(vars, selections)
  # Session cookie (e.g., rxid), cached per base URL for the session
  cookie <- .px_session_cookie(paths, px_file, lang = lang)
  body <- .px_query_body(vars, resolved_sel)
  url <- .px_url(paths, px_file, lang = lang)
  # Try both with and without the .px suffix as some PXWeb servers differ
  url_variants <- unique(c(url, sub("\\.px$", "", url)))
  resp <- NULL
  for (u in url_variants) {
    req <- httr2::request(u) |>
      httr2::req_user_agent(.nso_user_agent()) |>
      httr2::req_timeout(.nso_timeout()) |>
      httr2::req_retry(
        max_tries = .nso_retry_tries(),
        backoff = .nso_retry_backoff()
      )
    if (!is.null(cookie)) {
      req <- httr2::req_headers(req, Cookie = cookie)
    }
    req <- req |> httr2::req_body_json(body)
    # Debug: log request details if verbose
    if (.nso_verbose()) {
      cli_inform(c(
        "mongolstats: POST to {.url {u}}",
        "Cookie: {if (is.null(cookie)) 'NULL' else cookie}",
        "Body: {substr(jsonlite::toJSON(body, auto_unbox = TRUE), 1, 200)}"
      ))
    }
    # .nso_perform() raises mongolstats_http_error for transport and HTTP
    # failures; only those move on to the next URL variant. Anything else,
    # notably mongolstats_offline_error, propagates unchanged.
    resp <- tryCatch(.nso_perform(req), mongolstats_http_error = function(e) e)
    if (!inherits(resp, "error")) {
      break
    }
  }
  if (inherits(resp, "error")) {
    # Drop the cached session cookie: it may have expired, and the next
    # call should reseed rather than reuse a stale session.
    .px_clear_session_cookie(lang)
    # PXWeb explains rejected queries in the response body
    server_msg <- tryCatch( # nolint object_usage_linter. Used in cli_abort() below.
      substr(httr2::resp_body_string(resp$parent$resp), 1, 200),
      error = function(e) NULL
    )
    cli_abort(
      c(
        "PXWeb request failed for {.val {tbl_id}}.",
        "x" = if (length(server_msg) && nzchar(server_msg)) "Server response: {server_msg}",
        "i" = "Tried both .px and extensionless endpoints.",
        "i" = "Check selections with {.fn nso_dims} or request a smaller subset."
      ),
      class = "mongolstats_http_error",
      parent = resp
    )
  }
  out <- jsonlite::fromJSON(
    httr2::resp_body_string(resp),
    simplifyVector = FALSE
  )
  df <- .px_flatten_response(out, value_name = value_name)
  # Optionally attach raw PX payload for debugging/advanced use
  if (isTRUE(include_raw)) {
    attr(df, "px_raw") <- out
  }
  df
}

# Flatten a PXWeb JSON response (list with $columns and $data) into a tibble
# with one column per dimension plus a numeric value column. Per the PXWeb
# convention key columns are typed "d" (dimension) or "t" (time); NSO
# currently types its time column "d", but both must be kept because each
# row's $key spans every non-content column; dropping "t" columns would
# misalign the keys with the column names.
.px_flatten_response <- function(out, value_name = "value") {
  cols <- out$columns
  dat <- out$data
  if (length(dat) == 0) {
    return(tibble::tibble())
  }

  # Filter columns by type (cols is a list, not a data frame)
  dim_cols <- Filter(
    function(col) !is.null(col$type) && col$type %in% c("d", "t"),
    cols
  )
  dim_names <- vapply(
    seq_along(dim_cols),
    function(i) {
      nm <- .px_first_nonempty(
        dim_cols[[i]]$text,
        dim_cols[[i]]$code,
        paste0("dim", i)
      )
      if (is.null(nm)) {
        nm <- paste0("dim", i)
      }
      nm
    },
    character(1)
  )
  dim_names <- make.unique(dim_names)

  # Build data frame of keys and values
  keys <- dplyr::bind_rows(lapply(dat, function(d) {
    stats::setNames(as.list(unlist(d$key)), dim_names)
  }))

  vals <- vapply(
    dat,
    function(d) if (length(d$values)) d$values[[1]] else NA_character_,
    character(1)
  )

  df <- tibble::as_tibble(keys)
  df[[value_name]] <- suppressWarnings(as.numeric(vals))
  df
}
