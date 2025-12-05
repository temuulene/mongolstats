#' mongolstats: Mongolian NSO PXWeb Data and Boundaries
#'
#' A tidyverse-friendly client for the National Statistics Office of Mongolia
#' PXWeb API (data.1212.mn) with helpers to discover tables, variables, and fetch
#' statistical data. Also includes utilities to retrieve Mongolia administrative
#' boundaries (ADM0-ADM2) as 'sf' objects from open sources for mapping and
#' spatial analysis.
#'
#' @section Main Functions:
#' \describe{
#'   \item{nso_data}{Fetch statistical data from a table}
#'   \item{nso_itms, nso_tables}{List available tables}
#'   \item{nso_itms_search}{Search tables by keyword}
#'   \item{mn_boundaries}{Get administrative boundaries}
#' }
#'
#' @importFrom utils head tail
#' @importFrom curl curl_escape
#' @importFrom stats setNames
#' @keywords internal
"_PACKAGE"
