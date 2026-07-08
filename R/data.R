# Data retrieval via PXWeb

# Map codes to labels using table metadata in en/mn.
# Data columns are named with the fetch-language display text, while the
# other language's metadata only shares the dimension *code* (e.g. the en
# text is "Sex" while the shared code is the Cyrillic word), so labels are
# attached by mapping code -> data column via the fetch-language metadata.
.px_add_labels <- function(df, tbl_id, which = c("none", "en", "mn", "both")) {
  which <- match.arg(which)
  if (identical(which, "none")) {
    return(df)
  }
  resolved <- tryCatch(.px_resolve_table(tbl_id), error = function(e) NULL)
  if (is.null(resolved)) {
    return(df)
  }
  px_file <- resolved$px_file
  paths <- resolved$paths
  fetch_lang <- .px_lang()
  get_meta <- function(lang) {
    tryCatch(
      .px_meta_cached(paths, px_file, lang = lang),
      error = function(e) NULL
    )
  }
  meta_fetch <- get_meta(fetch_lang)
  if (is.null(meta_fetch) || !length(meta_fetch$variables)) {
    return(df)
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
      map <- tibble::tibble(code = codes, lbl = lbls)
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
#' @param include_raw If TRUE, attach the raw PX payload as attribute `px_raw`.
#' @section Table Structure Notes:
#' Some NSO tables have unique dimension structures that affect how `selections`
#' should be constructed:
#' \itemize{
#'   \item \strong{Air Quality Monthly Tables} (e.g., \code{DT_NSO_2400_015V1} to \code{V6}):
#'     These tables do not have a \code{Year} dimension. Instead, they use a running
#'     \code{Month} dimension with integer codes (e.g., \code{"0"} for the most recent month).
#'     Example: \code{selections = list(Month = as.character(0:11))} retrieves the last 12 months.
#' }
#' @return A tibble with one column per dimension and a numeric value column.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' # Fetch population data
#' pop <- nso_data(
#'   tbl_id = "DT_NSO_0300_001V2",
#'   selections = list(Year = "2023")
#' )
#' head(pop)
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
#' @param parallel If TRUE, use future.apply to fetch tables in parallel.
#'   Defaults to the `mongolstats.parallel` option (`FALSE`).
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
  if (is.data.frame(requests)) {
    # expect columns: tbl_id (character), selections (list-column)
    if (!("tbl_id" %in% names(requests) && "selections" %in% names(requests))) {
      cli_abort(c(
        "For PXWeb, provide a data frame with columns {.field tbl_id} and {.field selections} (list-column).",
        "i" = "Column {.field selections} should be a list-column of named lists."
      ))
    }
    reqs <- purrr::pmap(requests[, c("tbl_id", "selections")], list)
  } else if (is.list(requests)) {
    reqs <- requests
  } else {
    cli_abort(c(
      "{.arg requests} must be a list of records or a data frame with {.field tbl_id} + {.field selections}.",
      "i" = "Each record should be a list with elements {.field tbl_id} and {.field selections}."
    ))
  }
  worker <- function(r) {
    tbl <- r$tbl_id
    sel <- r$selections
    df <- tryCatch(
      nso_px_data(
        tbl,
        selections = sel,
        lang = .px_lang(),
        include_raw = FALSE,
        value_name = value_name
      ),
      error = function(e) e
    )
    if (inherits(df, "error")) {
      # Tag the failure; reported collectively after all fetches complete
      return(structure(
        list(tbl_id = tbl, message = conditionMessage(df)),
        class = "mongolstats_failed_fetch"
      ))
    }
    if (nrow(df)) {
      df$tbl_id <- tbl
    }
    .px_add_labels(df, tbl, which = labels)
  }
  if (isTRUE(parallel) && requireNamespace("future.apply", quietly = TRUE)) {
    parts <- future.apply::future_lapply(reqs, worker, future.seed = TRUE)
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
