# Public aggregate portal ----------------------------------------------------

#' Fetch a statistical series from the government data portal
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Retrieves the public aggregate endpoint used by `data.nso.mn`. This service
#' has an unversioned interface and a separate identifier and geography scheme
#' from PXWeb. Similar titles or identifiers do not establish equivalence.
#'
#' @param indicator_id Portal identifier from [nso_indicators()] with
#'   `source = "portal"`, without the `portal:` prefix.
#' @param area Portal area parameter, as a nonnegative integer string. The
#'   default `"1"` reproduces the verified national GDP request. This is an
#'   upstream request parameter, not a PXWeb geography selection.
#' @param dimension Portal grouping field: `"code"`, `"code1"`, ..., `"code6"`.
#' @param graph_type Portal presentation parameter, such as `"line"`. It is
#'   sent to the source endpoint and can affect which records it returns.
#' @param periods Optional character vector of exact source period labels.
#'   Filtering takes place after retrieval. A trailing `*` is preserved.
#' @param labels Official label columns to retain: `"both"`, `"mn"`, `"en"`,
#'   or `"code"`. Codes are always retained; missing labels remain missing.
#' @param include_raw Attach the original response as attribute `portal_raw`.
#' @return A tibble containing `backend`, `source_id`, `period`, `date`,
#'   `frequency`, active `code` dimensions, optional official label columns,
#'   `value`, `value_raw`, `value_status`, and registry `unit` and `source`.
#'   Unknown symbols have status `"symbol"`; no suppression meaning is inferred.
#'   An empty source response returns zero rows; request failures raise errors.
#'   A provenance attribute records the request and optional metadata failures.
#' @details
#' The registry supplies source and unit text verbatim when available. It is
#'   descriptive source metadata, not an independently validated semantic
#'   crosswalk. Narrative summaries are not used to construct observations.
#'   Unpadded `YYYY-1` to `YYYY-4` periods are ambiguous between months and
#'   quarters, so their dates and frequencies remain missing.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' nso_portal_data("DT_NSO_0000_4_4", periods = "2024")
#' @export
nso_portal_data <- function(
  indicator_id, area = "1", dimension = "code", graph_type = "line",
  periods = NULL, labels = c("both", "mn", "en", "code"), include_raw = FALSE
) {
  .portal_check_string(indicator_id, "indicator_id", "^DT_NSO_[A-Za-z0-9_]+$")
  .portal_check_string(area, "area", "^[0-9]+$")
  .portal_check_string(dimension, "dimension", "^code[1-6]?$")
  .portal_check_string(graph_type, "graph_type", "^[A-Za-z][A-Za-z0-9_]*$")
  .portal_check_flag(include_raw, "include_raw")
  .portal_check_periods(periods)
  labels <- match.arg(labels)
  suffix <- paste(indicator_id, dimension, area, graph_type, sep = "-")
  raw <- .portal_request("indicator", "data", suffix)
  out <- .portal_flatten(raw, indicator_id, labels)
  if (!is.null(periods)) out <- out[out$period %in% periods, , drop = FALSE]
  failures <- list()
  registry <- tryCatch(.portal_registry(), error = function(e) {
    failures <<- list(list(service = "portal_registry", message = conditionMessage(e)))
    cli_warn("Portal registry metadata could not be retrieved: {conditionMessage(e)}",
      class = "mongolstats_portal_metadata_warning"
    )
    NULL
  })
  matches <- if (is.null(registry)) integer() else which(registry$source_id == indicator_id)
  # More than one registry entry can name the same series. Use metadata only
  # when all nonmissing entries agree rather than silently choosing a row.
  agreed <- function(field) {
    values <- unique(registry[[field]][matches])
    values <- values[!is.na(values) & nzchar(values)]
    if (length(values) == 1L) values else NA_character_
  }
  out$unit <- rep(agreed("unit"), nrow(out))
  out$source <- rep(agreed("source"), nrow(out))
  out <- .nso_attach_provenance(
    out,
    backend = "portal", source_id = indicator_id,
    url = .nso_service_url("portal", "indicator", "data", suffix),
    selections = list(area = area, dimension = dimension, graph_type = graph_type, periods = periods),
    metadata = list(
      response_state = if (length(raw)) "records" else "empty",
      unit = agreed("unit"), source = agreed("source"),
      registry_url = .nso_service_url("portal", "indicator"),
      registry_matches = length(matches), interface = "experimental"
    ),
    language = labels, failures = failures
  )
  if (include_raw) attr(out, "portal_raw") <- raw
  out
}

.portal_check_string <- function(x, arg, pattern = NULL) {
  ok <- is.character(x) && length(x) == 1L && !is.na(x) && nzchar(x)
  if (ok && !is.null(pattern)) ok <- grepl(pattern, x)
  if (!ok) cli_abort("{.arg {arg}} must be a single valid source identifier or parameter.")
  invisible(x)
}

.portal_check_flag <- function(x, arg) {
  if (!is.logical(x) || length(x) != 1L || is.na(x)) {
    cli_abort("{.arg {arg}} must be TRUE or FALSE.")
  }
  invisible(x)
}

.portal_check_periods <- function(x) {
  if (!is.null(x) && (!is.character(x) || !length(x) || anyNA(x) || any(!nzchar(x)))) {
    cli_abort("{.arg periods} must be NULL or nonmissing source period labels.")
  }
  invisible(x)
}

.portal_request <- function(...) .nso_service_json("portal", ...)

.portal_records <- function(x) {
  valid_rows <- is.list(x) && all(vapply(x, function(row) is.list(row) && !is.null(names(row)), logical(1)))
  if (!valid_rows || !is.null(names(x))) {
    cli_abort("Expected a portal array of records.", class = "mongolstats_portal_schema_error")
  }
  x
}

.portal_scalar <- function(row, field) {
  value <- row[[field]]
  if (is.null(value)) {
    return(NA_character_)
  }
  if (!is.atomic(value) || length(value) != 1L) {
    cli_abort("Portal field {.val {field}} must contain a scalar value.",
      class = "mongolstats_portal_schema_error"
    )
  }
  as.character(value)
}

.portal_column <- function(records, field) {
  vapply(records, .portal_scalar, character(1), field = field)
}

.portal_flatten <- function(raw, indicator_id, labels) {
  rows <- .portal_records(raw)
  for (row in rows) {
    if (!all(c("period", "dtval_co") %in% names(row)) || is.null(row$period)) {
      cli_abort("Portal observations must contain period and dtval_co fields.",
        class = "mongolstats_portal_schema_error"
      )
    }
  }
  observed_id <- .portal_column(rows, "tbl_id")
  if (any(!is.na(observed_id) & observed_id != indicator_id)) {
    cli_abort("Portal response contains a different source identifier.",
      class = "mongolstats_portal_schema_error"
    )
  }
  period <- .portal_column(rows, "period")
  if (anyNA(period) || any(!nzchar(trimws(period)))) {
    cli_abort("Portal observations must have nonmissing period labels.",
      class = "mongolstats_portal_schema_error"
    )
  }
  dates <- .px_parse_period(period, quarterly = FALSE)
  ambiguous <- grepl("^[0-9]{4}-[1-4]\\*?$", period)
  dates$date[ambiguous] <- as.Date(NA)
  dates$frequency[ambiguous] <- NA_character_
  out <- tibble::tibble(
    backend = rep("portal", length(rows)), source_id = rep(indicator_id, length(rows)),
    period = period, date = dates$date, frequency = dates$frequency
  )
  for (suffix in c("", as.character(seq_len(6)))) {
    code <- paste0("code", suffix)
    values <- .portal_column(rows, code)
    if (!any(!is.na(values) & nzchar(values)) && length(rows)) next
    if (!length(rows) && nzchar(suffix)) next
    out[[code]] <- values
    for (lang in intersect(c("mn", "en"), if (labels == "both") c("mn", "en") else labels)) {
      field <- paste0("scr_", lang, suffix)
      lab <- .portal_column(rows, field)
      # The public payload uses this misspelling for the fifth English label.
      if (suffix == "5" && lang == "en") {
        alternate <- .portal_column(rows, "src_en5")
        lab[is.na(lab)] <- alternate[is.na(lab)]
      }
      out[[paste0(code, "_", lang)]] <- lab
    }
  }
  dplyr::bind_cols(out, .nso_parse_values(.portal_column(rows, "dtval_co")))
}

.mongolstats_portal_env <- new.env(parent = emptyenv())

.portal_registry <- function(refresh = FALSE) {
  .portal_check_flag(refresh, "refresh")
  key <- .nso_service_url("portal", "indicator")
  cached <- identical(.mongolstats_portal_env$url, key) && !is.null(.mongolstats_portal_env$registry)
  if (isTRUE(refresh) || !cached) {
    raw <- .portal_request("indicator")
    registry <- .portal_registry_rows(raw)
    registry <- .nso_attach_provenance(
      registry,
      backend = "portal", source_id = "indicator_registry", url = key,
      metadata = list(interface = "experimental")
    )
    .mongolstats_portal_env$url <- key
    .mongolstats_portal_env$registry <- registry
  }
  .mongolstats_portal_env$registry
}

.portal_registry_rows <- function(raw) {
  rows <- .portal_records(raw)
  ids <- .portal_column(rows, "indicator_id")
  missing <- is.na(ids) | !nzchar(ids)
  valid <- !missing & grepl("^DT_NSO_[A-Za-z0-9_]+$", ids)
  duplicate <- valid & (duplicated(ids) | duplicated(ids, fromLast = TRUE))
  quality <- ifelse(missing, "missing_id", ifelse(!valid, "invalid_id", ifelse(duplicate, "duplicate_id", "")))
  tibble::tibble(
    id = ifelse(valid, paste0("portal:", ids), NA_character_), source_id = ids,
    backend = rep("portal", length(rows)), name = .portal_column(rows, "indicator_name"),
    unit = .portal_column(rows, "measure_type"), source = .portal_column(rows, "source"),
    description = .portal_column(rows, "description"), graph_type = .portal_column(rows, "graph_type"),
    queryable = valid, template_available = rep(FALSE, length(rows)), quality_flags = quality,
    px_table_id = rep(NA_character_, length(rows)),
    dimensions = lapply(rows, function(row) row$aimag_col %||% list()),
    registry_record = rows
  )
}

#' Discover public aggregate datamarts
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Lists the portal's public datamart catalog and presentation configuration.
#' A supported developer query contract has not been verified, so this function
#' supplies discovery only. It does not request underlying individual records.
#'
#' @return A tibble with `id`, official `name`, source-reported `years`, `source`,
#'   `is_visible`, a `configuration` list column, and `query_supported = FALSE`.
#'   Year ranges and configuration are source text, not verified data coverage.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' nso_portal_datamarts()
#' @export
nso_portal_datamarts <- function() {
  rows <- .portal_records(.portal_request("datamart"))
  out <- tibble::tibble(
    id = .portal_column(rows, "id"), name = .portal_column(rows, "datamartName"),
    years = .portal_column(rows, "years"), source = .portal_column(rows, "source"),
    is_visible = vapply(rows, function(row) {
      if (is.null(row$isVisible)) NA else isTRUE(row$isVisible)
    }, logical(1)),
    configuration = lapply(rows, function(row) row$fmConfig %||% list()),
    query_supported = rep(FALSE, length(rows))
  )
  .nso_attach_provenance(
    out,
    backend = "portal", source_id = "datamart_catalog",
    url = .nso_service_url("portal", "datamart"),
    metadata = list(interface = "experimental", query_supported = FALSE)
  )
}
