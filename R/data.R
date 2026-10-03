# Data retrieval via PXWeb

# Map codes to labels using table metadata in en/mn.
# Data columns are named with the fetch-language display text, while the
# other language's metadata only shares the dimension *code* (e.g. the en
# text is "Sex" while the shared code is the Cyrillic word), so labels are
# attached by mapping code -> data column via the fetch-language metadata.
# The time column already holds fetch-language labels (see
# .px_label_time()), so its labels are matched on those instead of codes.
.px_add_labels <- function(df, tbl_id, which = c("none", "en", "mn", "both")) {
  which <- match.arg(which)
  if (identical(which, "none")) {
    return(df)
  }
  fetch_lang <- .px_lang()
  # A labelling request that fails must not return silently unlabelled
  # data; only offline mode degrades to codes-only.
  get_meta <- function(lang) {
    .nso_or_offline(.px_table_meta(tbl_id, lang = lang)$meta)
  }
  meta_fetch <- get_meta(fetch_lang)
  if (is.null(meta_fetch) || !length(meta_fetch$variables)) {
    return(df)
  }
  tv <- .px_time_var(meta_fetch$variables)
  time_code <- if (tv) as.character(meta_fetch$variables[[tv]]$code) else NA_character_
  time_label <- if (tv) {
    stats::setNames(
      .px_chr(meta_fetch$variables[[tv]]$valueTexts),
      .px_chr(meta_fetch$variables[[tv]]$values)
    )
  }
  col_by_code <- stats::setNames(
    vapply(
      meta_fetch$variables,
      function(v) .px_first_nonempty(v$text, v$code, "") %||% "",
      character(1)
    ),
    vapply(
      meta_fetch$variables,
      function(v) as.character(v$code %||% ""),
      character(1)
    )
  )
  add_lab <- function(d, vmeta, suffix) {
    if (is.null(vmeta)) {
      return(d)
    }
    for (v in vmeta$variables) {
      col <- unname(col_by_code[as.character(v$code %||% "")])
      if (is.na(col) || !nzchar(col) || !col %in% names(d)) {
        next
      }
      codes <- .px_chr(v$values)
      lbls <- .px_chr(v$valueTexts)
      if (!length(codes) || length(codes) != length(lbls)) {
        next
      }
      key <- if (identical(as.character(v$code), time_code)) unname(time_label[codes]) else codes
      map <- tibble::tibble(code = key, lbl = lbls)
      names(map) <- c(col, paste0(col, suffix))
      d <- dplyr::left_join(d, map, by = col)
    }
    d
  }
  metas <- list(
    en = if (identical(fetch_lang, "en")) meta_fetch else NULL,
    mn = if (identical(fetch_lang, "mn")) meta_fetch else NULL
  )
  if (which %in% c("en", "both") && is.null(metas$en)) {
    metas$en <- get_meta("en")
  }
  if (which %in% c("mn", "both") && is.null(metas$mn)) {
    metas$mn <- get_meta("mn")
  }
  if (which %in% c("en", "both")) {
    df <- add_lab(df, metas$en, "_en")
  }
  if (which %in% c("mn", "both")) {
    df <- add_lab(df, metas$mn, "_mn")
  }
  df
}

#' Fetch statistical data for a table (PXWeb)
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_0300_001V2").
#' @param selections Named list mapping variable labels (e.g., Year, Sex) to desired codes or labels.
#' @param labels Label handling: "none" (codes only), "en", "mn", or "both".
#'   "code" is accepted as an alias for "none" (matching [nso_fetch()]).
#' @param value_name Name of the numeric value column in the result (default: "value").
#' @param include_raw If TRUE, attach the raw PX payload as attribute `px_raw`
#'   (a list of payloads when the request was split, see below).
#' @section Time dimensions:
#' NSO codes periods by position: in every table, code `"0"` is the latest
#' period, so a period's code changes whenever a new one is published. The
#' time dimension (years, quarters, months or dates) is therefore always
#' returned by its label, such as `"2024"` or `"2024-03"`, whatever `labels`
#' is; [nso_period_date()] converts these labels to dates. Other dimensions
#' are returned as codes unless `labels` asks for labels.
#'
#' Select periods by label (`Year = "2024"`), with [nso_period_seq()]
#' (`Month = nso_period_seq("202401", "202412", by = "M")`), or with
#' [nso_latest_periods()]. Periods match whatever format the table uses, so
#' `"202403"`, `"2024-03"` and `"2024M3"` select the same month.
#' @section Large requests:
#' data.1212.mn answers at most 1,000,000 cells per request. Larger
#' selections are split into several requests and the results combined;
#' set `options(mongolstats.max_cells = )` to change the limit.
#' @return A tibble with one column per dimension and a numeric value column.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' # Population of Mongolia by sex in the two latest years
#' pop <- nso_data(
#'   tbl_id = "DT_NSO_0300_001V2",
#'   selections = list(
#'     Sex = c("Male", "Female"),
#'     Age = "Total",
#'     Year = nso_latest_periods("DT_NSO_0300_001V2", n = 2)
#'   ),
#'   labels = "en"
#' )
#' pop
#' @export
nso_data <- function(
  tbl_id,
  selections,
  labels = c("none", "en", "mn", "both"),
  value_name = getOption("mongolstats.value_name", "value"),
  include_raw = getOption("mongolstats.attach_raw", FALSE)
) {
  if (missing(labels)) {
    labels <- getOption("mongolstats.default_labels", "none")
  }
  # Accept the nso_fetch() vocabulary too: "code" is an alias for "none"
  if (identical(labels, "code")) labels <- "none"
  labels <- match.arg(labels)
  check_tbl_id(tbl_id)
  check_selections(selections)
  out <- nso_px_data(
    tbl_id,
    selections = selections,
    lang = .px_lang(),
    include_raw = include_raw,
    value_name = value_name
  )
  .px_add_labels(out, tbl_id, which = labels)
}

#' Fetch multiple tables and bind (PXWeb)
#' @param requests A list of records, each with `tbl_id` and `selections` (named list)
#' @param labels Label handling as in `nso_data()`
#' @param parallel If TRUE, fetch tables in parallel with
#'   [purrr::in_parallel()] (requires the mirai and carrier packages). Start
#'   background workers first with `mirai::daemons(4)`; without them the
#'   tables are fetched one at a time. Workers load the installed copy of
#'   mongolstats. Defaults to the `mongolstats.parallel` option (`FALSE`).
#' @param value_name Name of the numeric value column in the result (default: "value").
#' @param strict If TRUE, error when any table fails to fetch. If FALSE
#'   (default), failed tables are dropped from the result with a warning
#'   naming them.
#' @return A tibble combining data from all requested tables, with a `tbl_id` column
#'   identifying the source table. Tables that failed to fetch are omitted
#'   (with a warning) unless `strict = TRUE`.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' reqs <- list(
#'   list(tbl_id = "DT_NSO_0300_001V2", selections = list(Year = "2023"))
#' )
#' combined <- nso_package(reqs)
#' @export
nso_package <- function(
  requests,
  labels = c("none", "en", "mn", "both"),
  parallel = getOption("mongolstats.parallel", FALSE),
  value_name = getOption("mongolstats.value_name", "value"),
  strict = FALSE
) {
  if (missing(labels)) {
    labels <- getOption("mongolstats.default_labels", "none")
  }
  # Accept the nso_fetch() vocabulary too: "code" is an alias for "none"
  if (identical(labels, "code")) labels <- "none"
  labels <- match.arg(labels)
  reqs <- .nso_package_requests(requests)
  # Parallel workers start with the package defaults from .onLoad(), so the
  # caller's options (language, offline mode, timeouts, base URL) are
  # captured here and re-applied inside each fetch.
  opts <- .nso_capture_options()
  worker <- function(r) {
    .nso_package_fetch(r, labels = labels, value_name = value_name, opts = opts)
  }
  if (isTRUE(parallel)) {
    rlang::check_installed(c("mirai", "carrier"), reason = "to fetch tables in parallel.")
    if (!mirai::daemons_set()) {
      cli_inform(
        c(
          "i" = "No {.pkg mirai} daemons are running, so tables are fetched one at a time.",
          " " = "Start workers first, e.g. with {.code mirai::daemons(4)}."
        ),
        class = "mongolstats_no_daemons"
      )
    }
    # in_parallel() ships the function and the objects named here to each
    # worker; `fetch` keeps a reference to the mongolstats namespace, which
    # the worker loads from its library.
    parts <- purrr::map(
      reqs,
      purrr::in_parallel(
        function(r) fetch(r, labels = labels, value_name = value_name, opts = opts),
        fetch = .nso_package_fetch,
        labels = labels,
        value_name = value_name,
        opts = opts
      )
    )
  } else if (
    length(reqs) > 1 &&
      .nso_progress() &&
      interactive()
  ) {
    cli::cli_progress_bar(name = "Fetching tables", total = length(reqs))
    parts <- vector("list", length(reqs))
    for (i in seq_along(reqs)) {
      parts[[i]] <- worker(reqs[[i]])
      cli::cli_progress_update()
    }
    cli::cli_progress_done()
  } else {
    parts <- lapply(reqs, worker)
  }
  is_failed <- vapply(parts, inherits, logical(1), "mongolstats_failed_fetch")
  if (any(is_failed)) {
    failed_ids <- vapply(parts[is_failed], function(f) f$tbl_id, character(1)) # nolint object_usage_linter. Used in cli conditions below.
    first_msg <- parts[is_failed][[1]]$message # nolint object_usage_linter. Used in cli conditions below.
    if (isTRUE(strict)) {
      cli_abort(
        c(
          "Failed to fetch {sum(is_failed)} table{?s}: {.val {failed_ids}}.",
          "x" = "First error: {first_msg}"
        ),
        class = "mongolstats_http_error"
      )
    }
    cli_warn(c(
      "Failed to fetch {sum(is_failed)} table{?s}: {.val {failed_ids}}; dropped from the result.",
      "x" = "First error: {first_msg}",
      "i" = "Use {.code strict = TRUE} to raise an error instead."
    ))
  }
  dplyr::bind_rows(parts[!is_failed])
}

# `fetch` is bound inside the worker function by purrr::in_parallel() (see
# nso_package()), which R CMD check cannot see.
utils::globalVariables("fetch")

# Normalize and validate nso_package() requests into a list of records,
# each a list with a single-string `tbl_id` and a list `selections`.
.nso_package_requests <- function(requests, call = rlang::caller_env()) {
  if (is.data.frame(requests)) {
    # expect columns: tbl_id (character), selections (list-column)
    if (!("tbl_id" %in% names(requests) && "selections" %in% names(requests))) {
      cli_abort(
        c(
          "For PXWeb, provide a data frame with columns {.field tbl_id} and {.field selections} (list-column).",
          "i" = "Column {.field selections} should be a list-column of named lists."
        ),
        call = call
      )
    }
    requests <- purrr::pmap(requests[, c("tbl_id", "selections")], list)
  } else if (!is.list(requests)) {
    cli_abort(
      c(
        "{.arg requests} must be a list of records or a data frame with {.field tbl_id} + {.field selections}.",
        "i" = "Each record should be a list with elements {.field tbl_id} and {.field selections}."
      ),
      call = call
    )
  } else if ("tbl_id" %in% names(requests)) {
    cli_abort(
      c(
        "{.arg requests} must be a list of records, not a single record.",
        "i" = "Wrap a single request in {.fn list}: {.code list(list(tbl_id = ..., selections = ...))}."
      ),
      call = call
    )
  }
  for (i in seq_along(requests)) {
    r <- requests[[i]]
    tbl <- if (is.list(r)) r$tbl_id
    if (!is.character(tbl) || length(tbl) != 1L || is.na(tbl)) {
      cli_abort(
        "Request {i} must be a list with a single-string {.field tbl_id}.",
        call = call
      )
    }
    if (!is.list(r$selections)) {
      cli_abort(
        c(
          "Request {i} ({.val {tbl}}) must have {.field selections} as a named list.",
          "i" = "Use {.code selections = list(Year = \"2024\")}."
        ),
        call = call
      )
    }
  }
  requests
}

# Fetch one nso_package() record under the caller's options `opts` (from
# .nso_capture_options()). Failures are returned as a tagged record so they
# can be reported together once every fetch has completed.
.nso_package_fetch <- function(r, labels, value_name, opts) {
  old <- options(opts)
  on.exit(options(old), add = TRUE)
  tbl <- r$tbl_id
  # Labelling is inside the tryCatch too: a failed metadata request for
  # labels must mark this table as failed, not abort the whole batch.
  tryCatch(
    {
      df <- nso_px_data(
        tbl,
        selections = r$selections,
        lang = .px_lang(),
        include_raw = FALSE,
        value_name = value_name
      )
      if (nrow(df)) {
        df$tbl_id <- tbl
      }
      .px_add_labels(df, tbl, which = labels)
    },
    error = function(e) {
      structure(
        list(tbl_id = tbl, message = conditionMessage(e)),
        class = "mongolstats_failed_fetch"
      )
    }
  )
}
