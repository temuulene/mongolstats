#' Discover reviewed statistical concepts or portal indicators
#'
#' The curated registry supplies a small set of reviewed PXWeb query templates.
#' Portal discovery is a separate, experimental catalog: an identifier or title
#' shared with PXWeb does not establish statistical equivalence.
#'
#' @param query Optional literal, case-insensitive text to match across names,
#'   identifiers, aliases, and descriptions.
#' @param source `"curated"` for bundled reviewed concepts, or `"portal"` for
#'   the public government portal catalog.
#' @param refresh Refresh the portal catalog from the service. The curated
#'   registry is bundled and reviewed with package releases, so `TRUE` is not
#'   applicable to `source = "curated"`.
#' @return A tibble with source-qualified `id`, `source_id`, `backend`, name,
#'   unit, query availability, and source metadata. Curated rows also contain
#'   definitions, aliases, reviewed selections, caveats and validation dates.
#'   Portal rows retain invalid identifiers with `queryable = FALSE`, report
#'   quality flags, and preserve the original registry record in a list column.
#' @examples
#' nso_indicators("GDP")
#' nso_indicators("population")
#' @export
nso_indicators <- function(query = NULL, source = c("curated", "portal"), refresh = FALSE) {
  source <- match.arg(source)
  .portal_check_flag(refresh, "refresh")
  if (!is.null(query)) .portal_check_string(query, "query")
  if (source == "curated" && refresh) {
    cli_abort("The curated registry is reviewed with package releases and cannot be refreshed live.")
  }
  out <- if (source == "curated") .nso_curated_indicators() else .portal_registry(refresh)
  if (is.null(query) || !nrow(out)) {
    return(out)
  }
  search_fields <- intersect(c("id", "source_id", "name", "definition", "description", "aliases"), names(out))
  text <- vapply(seq_len(nrow(out)), function(i) {
    paste(unlist(lapply(out[search_fields], function(column) column[[i]]), use.names = FALSE), collapse = " ")
  }, character(1))
  out[stringr::str_detect(text, stringr::fixed(query, ignore_case = TRUE)), , drop = FALSE]
}

#' Look up a reviewed concept or a source-qualified portal indicator
#'
#' @param id Curated concept, alias, or qualified identifier such as
#'   `"curated:gdp_current"`. Portal lookups require the explicit `"portal:"`
#'   prefix and access the live or session-cached catalog.
#' @return A one-row tibble from [nso_indicators()]. Unknown or ambiguous IDs
#'   raise an error. A portal match does not supply a reviewed PXWeb template.
#' @examples
#' nso_indicator("gdp_current")
#' @export
nso_indicator <- function(id) {
  .portal_check_string(id, "id")
  if (startsWith(id, "portal:")) {
    out <- nso_indicators(source = "portal")
    hit <- which(!is.na(out$id) & out$id == id)
  } else {
    out <- nso_indicators()
    key <- sub("^curated:", "", tolower(id))
    hit <- which(vapply(seq_len(nrow(out)), function(i) {
      key %in% tolower(c(sub("^curated:", "", out$id[[i]]), unlist(out$aliases[[i]])))
    }, logical(1)))
  }
  if (!length(hit)) cli_abort("Unknown indicator {.val {id}}; see {.fn nso_indicators}.")
  if (length(hit) > 1L) cli_abort("Indicator {.val {id}} is ambiguous in its source registry.")
  out[hit, , drop = FALSE]
}

#' Build a PXWeb query from a reviewed statistical concept
#'
#' @param id Reviewed curated concept or alias; see [nso_indicator()].
#' @param periods Optional character vector of period labels, not positional
#'   PXWeb time codes. `NULL` selects all source periods.
#' @param geography Optional character vector of source geography codes for
#'   concepts with a geography dimension. `NULL` retains the reviewed national
#'   total. Codes use the PXWeb scheme and are validated when the query is fetched.
#' @return An [nso_query()] object ready for [nso_fetch()]. Construction is
#'   offline; fetching validates selections against current table metadata.
#'   Metadata and caveats can be inspected with [nso_indicator()].
#' @examples
#' nso_indicator_query("gdp_current", periods = c("2023", "2024"))
#' nso_indicator_query("resident_population", periods = "2024")
#' @export
nso_indicator_query <- function(id, periods = NULL, geography = NULL) {
  .portal_check_string(id, "id")
  if (startsWith(id, "portal:")) cli_abort("Only curated PXWeb concepts have reviewed query templates.")
  .portal_check_periods(periods)
  if (!is.null(periods) && anyNA(.px_parse_period(periods)$date)) {
    cli_abort("{.arg periods} must contain period labels, not positional time codes.")
  }
  row <- nso_indicator(id)
  if (!is.null(geography)) {
    if (!is.character(geography) || !length(geography) || anyNA(geography) || any(!nzchar(geography))) {
      cli_abort("{.arg geography} must contain nonmissing source geography codes.")
    }
    if (is.na(row$geography_dimension[[1]])) {
      cli_abort("This concept has no selectable geography dimension.")
    }
  }
  selections <- row$selections[[1]]
  selections[[row$time_dimension[[1]]]] <- periods %||% "all"
  if (!is.null(geography)) selections[[row$geography_dimension[[1]]]] <- geography
  nso_query(row$source_id[[1]], selections)
}

.nso_curated_indicators <- function() {
  path <- system.file("extdata", "indicators.json", package = "mongolstats")
  if (!nzchar(path)) path <- file.path("inst", "extdata", "indicators.json")
  if (!file.exists(path)) cli_abort("The bundled curated indicator registry is unavailable.")
  raw <- jsonlite::fromJSON(path, simplifyVector = FALSE)
  rows <- raw$indicators
  scalar <- function(field) .portal_column(rows, field)
  tibble::tibble(
    id = paste0("curated:", scalar("id")), source_id = scalar("source_id"),
    backend = rep("pxweb", length(rows)), name = scalar("name"),
    definition = scalar("definition"), unit = scalar("unit"),
    unit_status = scalar("unit_status"), frequency = scalar("frequency"),
    geography = scalar("geography"), geography_dimension = scalar("geography_dimension"),
    time_dimension = scalar("time_dimension"), verified_at = scalar("verified_at"),
    source_url = scalar("source_url"), caveats = scalar("caveats"),
    aliases = lapply(rows, function(row) .px_chr(row$aliases)),
    selections = lapply(rows, function(row) lapply(row$selections, .px_chr)),
    queryable = rep(TRUE, length(rows)), template_available = rep(TRUE, length(rows)),
    quality_flags = rep("", length(rows))
  )
}
