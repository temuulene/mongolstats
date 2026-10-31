#' mongolstats: Tidy Access to Mongolian Official Statistics and Metadata
#'
#' A tidyverse-friendly client for the National Statistics Office of Mongolia
#' public statistical services, with helpers to discover tables, variables, and
#' periods, fetch statistics, and retain source provenance. Experimental clients
#' expose the public data and metadata portals, including official definitions,
#' collection forms, and classifications. For maps, join the results to the
#' boundaries in the companion package mongolmaps by NSO code.
#'
#' @section Main Functions:
#' \describe{
#'   \item{nso_search}{Find tables by keyword}
#'   \item{nso_tables}{List all tables}
#'   \item{nso_dims, nso_dim_values}{Inspect a table's dimensions and values}
#'   \item{nso_table_periods, nso_latest_periods}{Periods available in a table}
#'   \item{nso_data}{Fetch statistical data from a table}
#'   \item{nso_indicators, nso_indicator_query}{Find reviewed statistical concepts and build queries}
#'   \item{nso_provenance, nso_citation}{Inspect source provenance and generate citations}
#'   \item{nso_metadata, nso_metadata_search}{Discover official metadata and collection context}
#'   \item{nso_portal_data}{Retrieve explicit public portal aggregate series}
#' }
#'
#' @importFrom lifecycle deprecated
#' @importFrom utils head
#' @importFrom curl curl_escape
#' @importFrom stats setNames
#' @importFrom rlang %||%
#' @importFrom cli cli_abort cli_warn cli_inform
#' @keywords internal
"_PACKAGE"
