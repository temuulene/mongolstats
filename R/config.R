.mongolstats_config_env <- new.env(parent = emptyenv())

.nso_config_key <- function() {
  paste0(sub("/+$", "", .px_base_url()), "|", .px_lang())
}

.nso_config_defaults <- function(status = "unavailable") {
  list(
    maxCells = 1e6,
    maxValues = 3000,
    maxCalls = 1,
    timeWindow = 1,
    origin = "defaults",
    status = status,
    base_url = sub("/+$", "", .px_base_url()),
    lang = .px_lang()
  )
}

#' Inspect PXWeb server configuration
#'
#' Retrieves the configuration advertised by the current PXWeb base URL and
#' language. Successful results are cached for this R session. A failed refresh
#' returns the previous configuration with `status = "stale"`; without a cache,
#' conservative defaults are returned. Offline mode never makes a request.
#'
#' `maxCells` limits cells in a data-query result. `maxValues` limits values
#' returned per variable in table metadata; it is not a selection limit for
#' data queries. `maxCalls` and `timeWindow` describe the server's advertised
#' request allowance. The package separately applies at least one second
#' between NSO request attempts, including retries. Calls on one computer
#' coordinate through `mongolstats.rate_limit_dir`; computers sharing a public
#' IP address require additional coordination by the caller.
#'
#' @param refresh Logical. Bypass the session cache and request the configuration
#'   again. Has no network effect in offline mode.
#' @return A list with numeric `maxCells`, `maxValues`, `maxCalls`, and
#'   `timeWindow` (seconds), plus `origin` (`"server"`, `"cache"`, or
#'   `"defaults"`), `status` (`"available"`, `"partial"`, `"stale"`,
#'   `"offline"`, or `"unavailable"`), `base_url`, and `lang`. Invalid or missing
#'   individual limits are replaced by conservative defaults and marked partial.
#' @references
#' [PxWeb configuration manual, API feature](https://www.scb.se/globalassets/vara-tjanster/px-programmen/pxweb-configuration_2023v1_v.1.1.pdf),
#' pages 74--75.
#' @examples
#' old <- nso_options(mongolstats.offline = TRUE)
#' nso_api_config()
#' options(old)
#' @export
nso_api_config <- function(refresh = FALSE) {
  if (!is.logical(refresh) || length(refresh) != 1L || is.na(refresh)) {
    cli_abort("{.arg refresh} must be {.code TRUE} or {.code FALSE}.")
  }
  key <- .nso_config_key()
  cached <- .mongolstats_config_env[[key]]
  if (.nso_offline()) {
    out <- cached %||% .nso_config_defaults("offline")
    if (!is.null(cached)) {
      out$origin <- "cache"
    }
    out$status <- "offline"
    return(out)
  }
  if (!refresh && !is.null(cached)) {
    cached$origin <- "cache"
    return(cached)
  }
  url <- paste0(sub("/+$", "", .px_base_url()), "/", .px_lang(), "/?config")
  payload <- tryCatch(
    {
      resp <- .nso_perform(.nso_request(url))
      jsonlite::parse_json(
        .px_strip_bom(httr2::resp_body_string(resp)),
        simplifyVector = FALSE
      )
    },
    error = function(e) NULL
  )
  if (!is.list(payload) || !length(payload)) {
    if (is.null(cached)) {
      return(.nso_config_defaults())
    }
    cached$origin <- "cache"
    cached$status <- "stale"
    return(cached)
  }
  out <- .nso_config_defaults()
  fields <- c("maxCells", "maxValues", "maxCalls", "timeWindow")
  valid <- vapply(
    fields,
    function(field) {
      value <- payload[[field]]
      is.numeric(value) && length(value) == 1L && is.finite(value) && value > 0
    },
    logical(1)
  )
  for (field in fields[valid]) {
    out[[field]] <- as.numeric(payload[[field]])
  }
  out$origin <- "server"
  out$status <- if (all(valid)) "available" else "partial"
  .mongolstats_config_env[[key]] <- out
  out
}

# Data retrieval uses cached limits only, so existing fetching workflows do not
# gain an extra request. Inspecting nso_api_config() opts into server discovery.
# max_values is exposed for metadata diagnostics, not POST query splitting.
.nso_query_limits <- function() {
  config <- .mongolstats_config_env[[.nso_config_key()]] %||%
    .nso_config_defaults()
  values <- getOption("mongolstats.max_values", default = 3000)
  .nso_check_option("mongolstats.max_values", values)
  list(
    max_cells = min(.nso_max_cells(), config$maxCells),
    max_values = min(as.numeric(values), config$maxValues)
  )
}
