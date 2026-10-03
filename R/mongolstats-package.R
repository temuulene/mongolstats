#' mongolstats: Tidy Client for the Mongolian NSO PXWeb Statistics API
#'
#' A tidyverse-friendly client for the National Statistics Office of Mongolia
#' PXWeb API (data.1212.mn) with helpers to discover tables, variables, and
#' periods, and to fetch statistical data. For maps, join the results to the
#' boundaries in the companion package mongolmaps by NSO code.
#'
#' @section Main Functions:
#' \describe{
#'   \item{nso_search}{Find tables by keyword}
#'   \item{nso_tables}{List all tables}
#'   \item{nso_dims, nso_dim_values}{Inspect a table's dimensions and values}
#'   \item{nso_table_periods, nso_latest_periods}{Periods available in a table}
#'   \item{nso_data}{Fetch statistical data from a table}
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
