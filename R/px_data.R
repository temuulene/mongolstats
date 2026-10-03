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
      seed <- .nso_request(.px_url(paths, px_file, lang = lang)) |>
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
# Selections larger than the server's cell limit are split into several
# requests. The time dimension is reported by label (see .px_label_time()).
nso_px_data <- function(tbl_id, selections, lang = .px_lang(), include_raw = FALSE, value_name = "value") {
  check_selections(selections)
  tm <- .px_table_meta(tbl_id, lang = lang)
  vars <- tm$meta$variables
  # Map selections to codes first; errors on unknown dimensions/values
  # before any further network activity.
  resolved_sel <- .px_map_selections(vars, selections)
  chunks <- .px_chunk_selections(resolved_sel, .nso_max_cells())
  # Session cookie (e.g., rxid), cached per base URL for the session
  cookie <- .px_session_cookie(tm$paths, tm$px_file, lang = lang)
  show_progress <- length(chunks) > 1L && .nso_progress() && interactive()
  if (show_progress) {
    cli::cli_progress_bar("Fetching {.val {tbl_id}} in parts", total = length(chunks))
  }
  raws <- vector("list", length(chunks))
  parts <- vector("list", length(chunks))
  for (k in seq_along(chunks)) {
    body <- .px_query_body(vars, chunks[[k]])
    raws[[k]] <- .px_post(tbl_id, tm$paths, tm$px_file, body, cookie = cookie, lang = lang)
    parts[[k]] <- .px_flatten_response(raws[[k]], value_name = value_name)
    if (show_progress) cli::cli_progress_update()
  }
  df <- .px_label_time(dplyr::bind_rows(parts), vars, raws[[1]]$columns)
  # Optionally attach raw PX payload for debugging/advanced use
  if (isTRUE(include_raw)) {
    attr(df, "px_raw") <- if (length(raws) == 1L) raws[[1]] else raws
  }
  df
}

# POST one PXWeb query and return the parsed JSON response.
.px_post <- function(tbl_id, paths, px_file, body, cookie = NULL, lang = .px_lang()) {
  url <- .px_url(paths, px_file, lang = lang)
  # Try both with and without the .px suffix as some PXWeb servers differ
  url_variants <- unique(c(url, sub("\\.px$", "", url)))
  resp <- NULL
  for (u in url_variants) {
    req <- .nso_request(u)
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
      status = resp$status,
      parent = resp
    )
  }
  jsonlite::fromJSON(httr2::resp_body_string(resp), simplifyVector = FALSE)
}

# Split resolved selections (named list of value codes, one element per
# dimension) so that no request asks for more than `max_cells` cells. The
# dimension with the most values is split first; a dimension is only split
# further when single values of it are still too large.
.px_chunk_selections <- function(sel, max_cells) {
  n <- as.numeric(lengths(sel))
  if (!length(sel) || prod(n) <= max_cells) {
    return(list(sel))
  }
  j <- which.max(n)
  per <- max(1, floor(max_cells / prod(n[-j])))
  pieces <- split(sel[[j]], ceiling(seq_along(sel[[j]]) / per))
  unlist(
    lapply(unname(pieces), function(p) {
      s <- sel
      s[[j]] <- p
      .px_chunk_selections(s, max_cells)
    }),
    recursive = FALSE
  )
}

# Replace the time dimension's positional codes ("0" is the latest period)
# with its labels ("2025", "2026-08"), which keep their meaning when NSO
# publishes a new period. `columns` is the response's `$columns`.
.px_label_time <- function(df, vars, columns) {
  tv <- .px_time_var(vars)
  if (!tv || !nrow(df)) {
    return(df)
  }
  v <- vars[[tv]]
  dims <- .px_dim_columns(columns)
  col <- dims$name[match(as.character(v$code), dims$code)]
  codes <- .px_chr(v$values)
  labels <- .px_chr(v$valueTexts)
  if (is.na(col) || !col %in% names(df) || length(codes) != length(labels)) {
    return(df)
  }
  df[[col]] <- labels[match(df[[col]], codes)]
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

  dim_names <- .px_dim_columns(cols)$name
  n_dim <- length(dim_names)

  # Collect all keys into one row-major character matrix instead of binding
  # one small data frame per row (which dominated fetch time on large
  # tables).
  keys <- lapply(dat, function(d) as.character(unlist(d$key)))
  bad <- which(lengths(keys) != n_dim)
  if (length(bad)) {
    cli_abort(
      c(
        "Malformed PXWeb response: row {bad[1]} has {length(keys[[bad[1]]])} key{?s}, expected {n_dim}.",
        "i" = "Dimension columns: {.val {dim_names}}."
      ),
      class = "mongolstats_http_error"
    )
  }
  df <- if (n_dim) {
    key_mat <- matrix(unlist(keys, use.names = FALSE), ncol = n_dim, byrow = TRUE)
    tibble::as_tibble(stats::setNames(
      lapply(seq_len(n_dim), function(j) key_mat[, j]),
      dim_names
    ))
  } else {
    tibble::tibble(.rows = length(dat))
  }

  vals <- vapply(
    dat,
    function(d) if (length(d$values)) as.character(d$values[[1]]) else NA_character_,
    character(1)
  )
  df[[value_name]] <- suppressWarnings(as.numeric(vals))
  df
}

# Dimension columns of a PXWeb response (`$columns`) as a tibble of `code`
# and `name`, the column name used in the flattened data (display text,
# made unique). Key columns are typed "d" or "t"; content columns "c".
.px_dim_columns <- function(columns) {
  dim_cols <- Filter(
    function(col) !is.null(col$type) && col$type %in% c("d", "t"),
    columns
  )
  names <- vapply(
    seq_along(dim_cols),
    function(i) {
      .px_first_nonempty(dim_cols[[i]]$text, dim_cols[[i]]$code, paste0("dim", i)) %||%
        paste0("dim", i)
    },
    character(1)
  )
  tibble::tibble(
    code = vapply(dim_cols, function(col) as.character(col$code %||% NA_character_), character(1)),
    name = make.unique(names)
  )
}
