#' mongolstats: Tidy Access to Mongolian Official Statistics and Metadata
#'
#' A tidyverse-friendly client for the National Statistics Office of Mongolia
#' public statistical services, with helpers to discover tables, variables, and
#' periods, fetch statistics, and retain source provenance. Experimental clients
#' expose the public data and metadata portals, including official definitions,
#' collection forms, and classifications. For maps, join the results to the
#' boundaries in the companion package mongolmaps by NSO code.
#'
#' @section Main functions:
#' * [nso_search()], [nso_tables()]: find tables by keyword or list them all.
#' * [nso_dims()], [nso_dim_values()]: inspect a table's dimensions and values.
#' * [nso_table_periods()], [nso_latest_periods()]: periods available in a table.
#' * [nso_data()]: fetch statistical data from a table.
#' * [nso_indicators()], [nso_indicator_query()]: find reviewed statistical
#'   concepts and build queries.
#' * [nso_provenance()], [nso_citation()]: inspect source provenance and
#'   generate citations.
#' * [nso_metadata()], [nso_metadata_search()]: discover official metadata and
#'   collection context.
#' * [nso_portal_data()]: retrieve explicit public portal aggregate series.
#'
#' @importFrom lifecycle deprecated
#' @importFrom utils head
#' @importFrom curl curl_escape
#' @importFrom stats setNames
#' @importFrom rlang %||%
#' @importFrom cli cli_abort cli_warn cli_inform
#' @keywords internal
"_PACKAGE"
