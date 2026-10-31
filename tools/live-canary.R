# Explicit public-service contract check, independent of offline unit tests.
# Run against the installed development package with Rscript tools/live-canary.R.
library(mongolstats)

canary <- function() {
  previous <- nso_options(
    mongolstats.progress = FALSE,
    mongolstats.retry_tries = 1L,
    mongolstats.timeout = 20,
    mongolstats.lang = "en"
  )
  on.exit(options(previous), add = TRUE)

  config <- nso_api_config(refresh = TRUE)
  stopifnot(config$status %in% c("available", "partial"), config$maxCells > 0)
  cat("PXWeb configuration: available\n")

  gdp <- nso_fetch(nso_indicator_query("gdp_current", periods = "2024"))
  manifest <- nso_provenance(gdp)
  stopifnot(
    nrow(gdp) > 0,
    length(manifest$records) > 0,
    manifest$records[[1]]$backend == "pxweb",
    length(nso_citation(gdp)) > 0
  )
  cat("PXWeb reviewed query: data and provenance available\n")
  sidecar <- tempfile(fileext = ".json")
  on.exit(unlink(sidecar), add = TRUE)
  nso_write_manifest(gdp, sidecar)
  stopifnot(identical(
    nso_citation(nso_read_manifest(sidecar)),
    nso_citation(gdp)
  ))

  record <- nso_metadata("indicator", 12925)
  stopifnot(
    record$key == "metadata:indicator:12925",
    is.list(record$context),
    is.data.frame(nso_related(record))
  )
  cat("Metadata detail and relationships: available\n")

  registry <- nso_indicators(source = "portal", refresh = TRUE)
  stopifnot(nrow(registry) > 0, any(registry$queryable))
  portal <- nso_portal_data("DT_NSO_0000_4_4", periods = "2024")
  stopifnot(
    nrow(portal) > 0,
    all(portal$value_status %in% c("observed", "missing", "symbol")),
    nso_provenance(portal)$records[[1]]$backend == "portal"
  )
  cat("Portal catalogue and aggregate series: available\n")
  nso_write_manifest(portal, sidecar, overwrite = TRUE)
  stopifnot(identical(
    nso_citation(nso_read_manifest(sidecar)),
    nso_citation(portal)
  ))

  marts <- nso_portal_datamarts()
  stopifnot(nrow(marts) > 0, all(!marts$query_supported))
  cat("Datamart capability discovery: available\n")
}

canary()
