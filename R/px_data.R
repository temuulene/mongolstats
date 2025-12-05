# Fetch data from a PXWeb table
# Returns tibble with one column per dimension plus a numeric `value` column.
nso_px_data <- function(tbl_id, selections, lang = .px_lang(), include_raw = FALSE, value_name = "value") {
  stopifnot(is.list(selections))
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) {
    tbl_id
  } else {
    paste0(tbl_id, ".px")
  }
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) {
    stop("Table not found in PXWeb index: ", tbl_id)
  }
  paths <- if (nzchar(row$px_path[1])) {
    strsplit(row$px_path[1], "/", fixed = TRUE)[[1]]
  } else {
    character()
  }
  meta <- .px_meta_cached(paths, px_file, lang = lang)
  vars <- meta$variables
  # Seed cookie if server uses Set-Cookie (e.g., rxid) to accept POST
  cookie <- NULL
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
  # Build query: ensure every variable in the table is included.
  q <- list()
  sel_names <- tolower(names(selections))
  for (v in vars) {
    vname <- tolower(.px_first_nonempty(v$text, v$code, ""))
    vv <- .px_chr(v$values)
    vt <- .px_chr(v$valueTexts)
    if (vname %in% sel_names) {
      # User-provided selection for this variable
      vals <- as.character(selections[[which(sel_names == vname)[1]]])
      # If labels provided, map to codes (prioritize codes over labels)
      if (length(vt) && !all(vals %in% vv) && any(vals %in% vt)) {
        idxs <- match(vals, vt)
        vals <- vv[idxs]
      }
      # Validate
      if (length(vv) && !all(vals %in% vv)) {
        bad <- unique(setdiff(vals, vv))
        ex_codes <- paste(utils::head(vv, 5), collapse = ", ")
        ex_labs <- tryCatch(
          {
            labs <- .px_chr(v$valueTexts)
            if (length(labs)) {
              paste(utils::head(labs, 5), collapse = ", ")
            } else {
              NA_character_
            }
          },
          error = function(e) NA_character_
        )
        msg <- sprintf(
          "Invalid selection for '%s': %s. Available codes include: %s",
          .px_first_nonempty(v$text, v$code, vname),
          paste(bad, collapse = ", "),
          ex_codes
        )
        if (!is.na(ex_labs)) {
          msg <- paste0(msg, "; labels include: ", ex_labs)
        }
        stop(msg)
      }
      q[[length(q) + 1]] <- list(
        code = v$code,
        selection = list(filter = "item", values = I(as.character(vals)))
      )
    } else {
      # Not specified: select all explicit codes for this variable
      q[[length(q) + 1]] <- list(
        code = v$code,
        selection = list(filter = "item", values = I(as.character(vv)))
      )
    }
  }
  body <- list(query = q, response = list(format = "json"))
  # Build pxweb-style named query for fallback
  px_query <- stats::setNames(
    vector("list", length(vars)),
    vapply(vars, function(v) v$code, character(1))
  )
  for (v in vars) {
    vname <- .px_first_nonempty(v$text, v$code, "")
    vv <- .px_chr(v$values)
    vt <- .px_chr(v$valueTexts)
    if (tolower(vname) %in% sel_names) {
      vals <- as.character(selections[[which(sel_names == tolower(vname))[1]]])
      if (length(vt) && !all(vals %in% vv) && any(vals %in% vt)) {
        vals <- vv[match(vals, vt)]
      }
      px_query[[v$code]] <- vals
    } else {
      px_query[[v$code]] <- vv
    }
  }
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
      message("mongolstats: POST to ", u)
      message("mongolstats: Cookie: ", if (is.null(cookie)) "NULL" else cookie)
      message(
        "mongolstats: Body: ",
        substr(jsonlite::toJSON(body, auto_unbox = TRUE), 1, 200)
      )
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
    msg <- sprintf(
      "PXWeb request failed; tried both .px and extensionless endpoints. %s. If 'pxweb' is installed, verify selections or try smaller subsets.",
      err_details
    )
    stop(structure(
      list(message = msg, call = NULL),
      class = c("mongolstats_http_error", "error", "condition")
    ))
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
