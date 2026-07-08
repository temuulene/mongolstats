# Session cookie helpers -------------------------------------------------
# Some PXWeb servers require a session cookie (e.g., rxid) before accepting
# POST requests. Seeding it costs one GET, so cache it per base URL/language
# for the R session instead of re-seeding on every data fetch.

.px_cookie_key <- function(lang) {
  paste0(.px_base_url(), "|", lang)
}

.px_session_cookie <- function(paths, px_file, lang = .px_lang()) {
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
  # Build query: every variable in the table is included.
  q <- lapply(vars, function(v) {
    list(
      code = v$code,
      selection = list(
        filter = "item",
        values = I(as.character(resolved_sel[[as.character(v$code)]]))
      )
    )
  })
  body <- list(query = q, response = list(format = "json"))
  # pxweb-style named query for fallback: same shape as resolved_sel
  px_query <- resolved_sel
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
    resp <- tryCatch(.nso_perform(req), error = function(e) e)
    ok <- !(inherits(resp, "error") ||
                (inherits(resp, "httr2_response") &&
                 !is.null(httr2::resp_status(resp)) &&
                 httr2::resp_status(resp) >= 400))
    if (ok) {
      url <- u
      break
    }
  }
  if (inherits(resp, "error") ||
          (inherits(resp, "httr2_response") &&
           !is.null(httr2::resp_status(resp)) &&
           httr2::resp_status(resp) >= 400)) {
    # Drop the cached session cookie: it may have expired, and the next
    # call should reseed rather than reuse a stale session.
    .px_clear_session_cookie(lang)
    # Capture error details for better debugging
    err_details <- if (inherits(resp, "httr2_response")) {
      status <- httr2::resp_status(resp)
      body <- tryCatch(httr2::resp_body_string(resp), error = function(e) {
        "<unable to read>"
      })
      sprintf("HTTP %d. Response: %s", status, substr(body, 1, 200))
    } else if (inherits(resp, "error")) {
      conditionMessage(resp)
    } else {
      "Unknown error"
    }

    if (requireNamespace("pxweb", quietly = TRUE)) {
      # Fallback via pxweb client
      px <- tryCatch(
        pxweb::pxweb_get(url, query = px_query),
        error = function(e) e
      )
      if (!inherits(px, "error")) {
        df <- tryCatch(
          pxweb::pxweb_as_data_frame(
            px,
            column.name.type = "text",
            variable.value.type = "code"
          ),
          error = function(e) NULL
        )
        if (!is.null(df)) {
          return(tibble::as_tibble(df))
        }
      }
    }
    # If fallback not available or failed, rethrow informative error
    cli_abort(
      c(
        "PXWeb request failed for {.val {tbl_id}}.",
        "x" = "{err_details}",
        "i" = "Tried both .px and extensionless endpoints.",
        "i" = "If {.pkg pxweb} is installed, verify selections or try smaller subsets."
      ),
      class = "mongolstats_http_error"
    )
  }
  out <- jsonlite::fromJSON(
    httr2::resp_body_string(resp),
    simplifyVector = FALSE
  )
  # Flatten PXWeb response
  cols <- out$columns
  dat <- out$data
  if (length(dat) == 0) {
    return(tibble::tibble())
  }

  # Filter columns by type (cols is a list, not a data frame)
  dim_cols <- Filter(function(col) !is.null(col$type) && col$type == "d", cols)
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
  # OPTIMIZATION: Use dplyr::bind_rows instead of do.call(rbind, lapply(...))
  keys <- dplyr::bind_rows(lapply(dat, function(d) {
    stats::setNames(as.list(unlist(d$key)), dim_names)
  }))

  vals <- vapply(
    dat,
    function(d) if (length(d$values)) d$values[[1]] else NA_character_,
    character(1)
  )

  # Build final tibble with configurable value column name
  df <- tibble::as_tibble(keys)
  df[[value_name]] <- suppressWarnings(as.numeric(vals))
  # Optionally attach raw PX payload for debugging/advanced use
  if (isTRUE(include_raw)) {
    attr(df, "px_raw") <- out
  }
  df
}
