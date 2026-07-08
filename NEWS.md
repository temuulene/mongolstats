# mongolstats (development version)

## Breaking changes

*   **Stricter selection validation**: `nso_data()`, `nso_package()`, `nso_query()`, and `as_px_query()` now error when a selection name does not match any dimension in the table (previously the selection was silently ignored and the full dimension was fetched), when selections are unnamed, or when two selections target the same dimension. This prevents silently fetching wrong-scope data. Errors carry class `mongolstats_selection_error`.

## New features

*   **`nso_package()` no longer fails silently**: tables that fail to fetch are reported in a warning naming each table, and a new `strict = TRUE` argument raises an error instead. Previously failed tables were dropped without any signal.
*   **Unified `labels` vocabulary**: `nso_data()` and `nso_package()` accept `"code"` as an alias for `"none"`, and `nso_fetch()` and `nso_dim_values()` accept `"none"` as an alias for `"code"`, so either spelling works everywhere.
*   **`mn_boundaries()` session cache**: boundary downloads are cached in memory for the session (repeated calls, including via `mn_join_by_name()`, no longer re-download multi-megabyte GeoJSON). A `refresh = TRUE` argument bypasses the cache.
*   **`nso_period_seq()` input validation**: malformed periods (wrong width, month 13, `NA`, vectors) and reversed ranges now error with a clear message instead of silently returning a descending sequence or failing inside `seq.Date()`.

## Bug fixes

*   **Mixed codes and labels**: Selection values are now mapped element-wise, so codes and labels can be mixed in one vector (e.g. `Sex = c("Total", "1")`). Previously this produced an "Unknown value: NA" error. Duplicated labels in table metadata now produce a warning naming the ambiguous label.
*   **Consistent errors**: `as_px_query()` now raises the same classed errors as `nso_data()` for invalid selections (previously a plain `stop()`).
*   **Correct error classes**: network failures (DNS, timeout) now signal `mongolstats_http_error`; previously they were misclassified as `mongolstats_offline_error`, so handlers could not tell offline mode from a genuine connection problem.

## Performance

*   The PXWeb session cookie is now seeded once per base URL per session instead of once per data fetch, removing one GET round trip from every `nso_data()` call after the first.
*   `mn_fuzzy_join_by_name()` no longer computes a base-R distance matrix that was immediately discarded when stringdist is installed.

## CRAN compliance

*   Network-dependent examples are now guarded with `NOT_CRAN` in addition to `curl::has_internet()`, so they no longer contact the live PXWeb API during CRAN checks. The `nso_rebuild_px_index()` example, which crawls the full catalogue, is wrapped in `\dontrun{}`.
*   `inst/extdata/air_monthly_cached.csv` is now gzip-compressed (6.4 Mb to 0.3 Mb), bringing the installed package size well under CRAN's threshold. `read.csv()` decompresses it transparently; only the vignette referenced it.

## Internal

*   Selection mapping and validation consolidated into a single helper (`.px_map_selections()`), removing three divergent copies of the logic.
*   Table resolution now goes through `.px_resolve_table()` everywhere (`.px_add_labels()`, `nso_table_periods()`, `.px_build_body()`), removing the remaining inlined index lookups.
*   Integration tests resolve dimension codes from live metadata instead of assuming positional codes, so tests no longer break when NSO adds a new period. Integration and endpoint tests now assert concrete shapes and no longer swallow errors.
*   Added `tools/record_fixtures.R` to record the httptest2 fixtures used by `test-recorded-*.R`; those tests previously always skipped because the fixture directories were empty.
*   Removed unused `globalVariables()` declarations, the unused lifecycle Suggests entry, and a stray rendered vignette HTML from the repository.

# mongolstats 0.1.1

Patch release to fix CRAN check failures on vignette rebuilding.

## Bug Fixes

*   **Vignette CRAN Compliance**: Added `NOT_CRAN` guards to all vignettes to prevent code evaluation during CRAN checks. This fixes HTTP 400 errors and data-dependent failures when vignettes are rebuilt on CRAN infrastructure where external API calls may fail.

# mongolstats 0.1.0

First minor release containing significant data updates, visualization improvements, and refined documentation.

## Data & Features
*   **Monthly Mortality Data**: Switched infant mortality analysis to use monthly data (`DT_NSO_2100_015V1`) for 2019-2024, enabling more granular trend analysis and up-to-date regional comparisons.
*   **UB Air Quality**: Added accurate coordinates for Ulaanbaatar air quality monitoring stations and mapped them to districts.
*   **Boundaries**: Fixed spatial mismatches in administrative boundary names to ensure seamless joins with NSO data.

## Visualization & UI
*   **Plot Polish**: Applied publication-quality styling to all package plots, including:
    *   Interactive tooltips with formatted units and rounded numbers.
    *   Trend lines with confidence intervals for mortality rates.
    *   Log-scaled population maps for better contrast.
    *   Clean integer breaks on axes.
*   **Standardized Aesthetics**: Consistent plot styling across all vignettes.

## Documentation
*   **New Vignettes**:
    *   `mortality-analysis`: In-depth analysis of infant mortality trends and seasonality.
    *   `environmental-surveillance`: Detailed examination of air and water quality monitoring coverage.
*   **Vignette Updates**:
    *   `getting-started`: Renamed and streamlined for new users.
    *   `discovery` & `mapping`: Updated with new datasets and visualization techniques.
*   **Examples**: Added executable examples to key functions (`nso_data()`, `nso_itms()`, `mn_boundaries()`).

## Internal
*   **Cleanup**: Removed legacy `labels.R` and unused artifacts.
*   **Infrastructure**: Fully migrated `NAMESPACE` management to `roxygen2` and fixed GitHub Actions workflows.

# mongolstats 0.0.0.9000

Initial development snapshot.

- NSO API wrappers: `nso_itms()`, `nso_itms_detail()`, `nso_data()`, `nso_package()`
- Sector helpers: `nso_sectors()`, `nso_subsectors()`, `nso_search()`
- Boundaries: `mn_boundaries()`, join helpers incl. fuzzy joins
- Caching for discovery endpoints
- Vignettes for getting started, mapping, fuzzy joins, and code-based joins
