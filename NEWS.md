# mongolstats 0.3.0

## Breaking changes

*   Time dimensions are now always returned by their labels (`"2024"`, `"2024-03"`), whatever `labels` is. NSO codes periods by position, with `"0"` the latest period, so a code such as `Year == "0"` changed meaning every time NSO published a new period. Other dimensions are still returned as codes. With `labels = "en"` or `"both"` the `Year_en`-style columns are still added.
*   `nso_table_periods()` now returns a tibble with `code`, `label`, `date` and `frequency`, oldest period first, instead of a character vector of labels in catalogue order (newest first). It also finds time dimensions named "Month", "Quarter" or in Mongolian, which it previously missed.
*   `nso_package(parallel = TRUE)` now runs on mirai daemons through `purrr::in_parallel()` instead of future.apply; start workers with `mirai::daemons()`. future and future.apply are no longer suggested packages; mirai and carrier are.
*   sf has moved from Imports to Suggests: only the deprecated `mn_boundaries()` needs it.
*   Discovery functions (`nso_dims()`, `nso_dim_values()`, `nso_itms_detail()`, `nso_sectors()`, `nso_subsectors()`, `nso_table_meta()`, `nso_table_periods()`) now raise `mongolstats_http_error` when a request fails. Previously any failure returned an empty result, so a server outage looked like an empty catalogue. Offline mode still returns empty results.
*   The `pxweb` fallback in `nso_data()`, `nso_fetch()`, and `nso_package()` has been removed, and pxweb is no longer a suggested package. The fallback returned data in a different shape (display-text column names, a value column that ignored `value_name`), and it could make network requests in offline mode. Failed requests now raise `mongolstats_http_error` with the server's response attached.
*   `mn_fuzzy_join_by_name()` now errors when `method = "jw"` is combined with `max_distance >= 1`. Jaro-Winkler distances lie between 0 and 1, so the default `max_distance = 2` matched every name to some boundary. Use a value such as `max_distance = 0.2`.
*   `nso_options()` now validates values (e.g. `mongolstats.lang` must be `"en"` or `"mn"`, `mongolstats.timeout` a positive number) and leaves all options unchanged when one is invalid. It warns about names that are not mongolstats options. An unsupported `mongolstats.lang` set directly with `options()` now errors instead of silently falling back to English.
*   `nso_table_periods()` now errors for an unknown table id or a non-string `tbl_id`, like the other discovery functions. It previously returned `character(0)`, which was indistinguishable from a table without a time dimension.

## Lifecycle changes

*   The geoBoundaries helpers `mn_boundaries()`, `mn_boundary_keys()`, `mn_boundaries_normalize()`, `mn_join_by_name()` and `mn_fuzzy_join_by_name()` are deprecated in favour of the mongolmaps package, whose boundaries carry NSO codes and whose `mn_join()` joins NSO tables by code, drops totals, and takes Ulaanbaatar's figures from region code `"5"` when a table leaves `"511"` empty.
*   `nso_itms()`, `nso_itms_detail()` and `nso_itms_search()` are superseded by `nso_tables()`, `nso_variables()` and `nso_search(fixed = TRUE)`. They keep working without warnings.

## New features

*   Tables that NSO has moved to another catalogue folder are now found automatically: when a table's metadata request fails with HTTP 400 or 404, mongolstats looks it up in the live catalogue, updates the in-memory index, and tells you (class `mongolstats_table_moved`). Tables published after the bundled index was built are found with the PXWeb search API (class `mongolstats_table_located`). Previously both failed, e.g. the GDP table `DT_NSO_0500_001V1` after NSO's September 2026 reorganisation.
*   Requests larger than the server's limit of 1,000,000 cells are split into several requests and the results combined. The limit is set by the new option `mongolstats.max_cells`.
*   All requests are rate-limited to data.1212.mn's published limit of 1,000 calls per 100 seconds.
*   New `nso_latest_periods()` returns the labels of a table's most recent periods, ready for `selections`.
*   New `nso_period_date()` converts NSO period labels in any of the office's formats (`"2024"`, `"2024-03"`, `"2016M3"`, `"2024.03"`, `"2024-II"`, `"2026-07-06"`) to dates.
*   Selections on the time dimension match periods written in any of these formats, so `nso_period_seq("202401", "202412", by = "M")` now selects months labelled `"2024-01"` or `"2024M1"`. Previously its output matched no NSO monthly table.
*   Labels in `selections` match ignoring the leading spaces NSO uses to indent nested categories, e.g. `"GDP, at 2015 constant prices"` for `" GDP, at 2015 constant prices"`.
*   `nso_search()` gains `fixed = TRUE` for literal matching.
*   `nso_tables()` gains an `updated` column with the date NSO last updated each table, and the bundled table index has been rebuilt from the current catalogue.
*   Table ids are now matched case-insensitively, with or without the `.px` suffix (e.g. `"dt_nso_0300_001v2"`).
*   `mn_join_by_name()` and `mn_fuzzy_join_by_name()` now warn (class `mongolstats_unmatched_names`) naming data rows that matched no boundary. Previously these rows were dropped silently, so a spelling mismatch showed up only as a grey polygon on a map.
*   `nso_rebuild_px_index()` warns (class `mongolstats_incomplete_index`) naming catalogue paths whose requests failed, instead of silently writing an incomplete index, and stops immediately in offline mode.

## Bug fixes

*   The start and end periods in the table index (`strt_prd`, `end_prd`) were reversed for most tables, because NSO lists periods newest first, and missing for tables whose time dimension is not named "Year" or "Time". They are now the earliest and latest periods by date.
*   `nso_itms_by_sector()` and `nso_search(sector = )` now include tables in sub-folders. NSO keeps every table in a sub-folder, so a sector id from `nso_sectors()` previously matched no tables.
*   `nso_dims()` and `nso_table_meta()` now mark the time dimension in `is_time`. NSO never sets PXWeb's time flag, so `is_time` was always `FALSE`.
*   HTTP errors no longer fail with "Could not evaluate cli `{}` expression" when a server or curl message contains a brace. The original error is now attached as the parent condition.
*   Argument validation errors now describe the offending value ("not `NULL`", "not a number"). They used a nonexistent cli style and printed the raw value instead, e.g. "not ." for `NULL`.
*   `mn_boundaries()` raises `mongolstats_http_error` when the boundary download fails, and a clear error when the GeoBoundaries API returns no download URL.
*   `mn_fuzzy_join_by_name()` no longer crashes with "invalid subscript type 'list'" when the name column contains `NA`.
*   `nso_cache_enable()`: cached catalogue listings and metadata are now keyed by the PXWeb base URL and database, so switching `mongolstats.px_base_url` or `mongolstats.px_db` no longer returns another server's metadata. The table index is no longer stored in the disk cache, where a stale copy outlived package upgrades that refresh the embedded index.
*   `nso_data()` and `nso_fetch()` in offline mode now raise `mongolstats_offline_error`. When table metadata was cached they raised `mongolstats_http_error`, so handlers could not tell offline mode from a network failure.
*   `nso_data()`, `nso_fetch()`, and `nso_package()` with `labels` other than `"none"` now error when the label metadata request fails. They previously returned the data without labels and without a warning. In `nso_package()` the table is reported as failed.
*   `nso_itms_detail()` and `nso_variables()` now return Mongolian labels in `scr_mn`. Labels were joined on the language-specific dimension name, which never matches across languages, so `scr_mn` was always `NA`.
*   `nso_itms_by_sector()` validates `list_id` instead of failing inside a subsetting call.
*   `nso_package(parallel = TRUE)` now applies the caller's mongolstats options (language, offline mode, timeouts, base URL) inside each worker. Workers previously ran with the package defaults.
*   `nso_package()` validates `requests` before fetching and explains the problem, e.g. a single record passed without wrapping it in `list()`, a record without `tbl_id`, or non-list `selections`. These previously failed with errors such as "$ operator is invalid for atomic vectors".
*   `nso_search()` no longer changes the meaning of regex escapes: the pattern was lowercased for case-insensitive matching, turning `\S` into `\s`. `nso_search()` and `nso_itms_search()` now match with `ignore_case = TRUE` instead.

## Performance

*   `nso_data()` flattens large PXWeb responses much faster: row keys are collected into one matrix instead of binding a data frame per row (about 8x faster on a 50,000-row response). Malformed responses whose row keys do not match the dimension columns now raise an error.

## Internal

*   Recorded HTTP fixtures now use short paths. The old paths exceeded the 100 bytes `R CMD build` stores portably, so the fixtures were dropped from the built package and the recorded tests always skipped. Those tests replay without network access and no longer skip on CRAN.
*   All top-level hidden files and folders (such as a local `.venv/`) are excluded from package builds.
*   The pkgdown site no longer publishes a Markdown copy of every page.
*   Requests share one builder (user agent, timeout, retries, rate limit), and HTTP errors carry the response `status`.
*   The vignettes and README use `mongolmaps::mn_join()` without recoding Ulaanbaatar by hand, select periods by label, and follow NSO's renamed tables and dimensions. The monthly mortality article moved to `vignettes/articles/`.
*   Continuous integration now fails on lints, on test coverage below 80% (tests that need the live API skip in CI), and on out-of-date Rd files, instead of regenerating them before the check. The package, tests, and vignettes are lint-clean.
*   Error-message tests use snapshots, and new offline tests cover the discovery functions against a fake table.

# mongolstats 0.2.0

## Breaking changes

*   **Stricter selection validation**: `nso_data()`, `nso_package()`, `nso_query()`, and `as_px_query()` now error when a selection name does not match any dimension in the table (previously the selection was silently ignored and the full dimension was fetched), when selections are unnamed, or when two selections target the same dimension. This prevents silently fetching wrong-scope data. Errors carry class `mongolstats_selection_error`.

## New features

*   **`nso_package()` no longer fails silently**: tables that fail to fetch are reported in a warning naming each table, and a new `strict = TRUE` argument raises an error instead. Previously failed tables were dropped without any signal.
*   **Unified `labels` vocabulary**: `nso_data()` and `nso_package()` accept `"code"` as an alias for `"none"`, and `nso_fetch()` and `nso_dim_values()` accept `"none"` as an alias for `"code"`, so either spelling works everywhere.
*   **`mn_boundaries()` session cache**: boundary downloads are cached in memory for the session (repeated calls, including via `mn_join_by_name()`, no longer re-download multi-megabyte GeoJSON). A `refresh = TRUE` argument bypasses the cache.
*   **`nso_period_seq()` input validation**: malformed periods (wrong width, month 13, `NA`, vectors) and reversed ranges now error with a clear message instead of silently returning a descending sequence or failing inside `seq.Date()`.

## Bug fixes

*   Ambiguous table ids now warn: the NSO catalogue can reuse one table id for different tables in different folders (e.g. `DT_NSO_2400_015V1` currently names both the monthly SO2 station table and an annual air-quality-standards table). mongolstats now warns (class `mongolstats_ambiguous_table`) and names the folder it picked instead of silently resolving to an arbitrary table. Tables that are merely cross-listed in several folders under the same name resolve silently.
*   The embedded PXWeb table index has been refreshed to match the current NSO catalogue. Several tables (e.g. cancer incidence `DT_NSO_2100_012V1` and communicable diseases `DT_NSO_2100_035V1`) moved to different catalogue folders, which made lookups through the stale index return empty results.

*   **`labels = "mn"` and `labels = "both"` now actually attach Mongolian labels**: label metadata was matched to data columns by display text, but the two languages only share the dimension *code* (the English column is "Sex" while both languages use the code "Хүйс"), so cross-language labels were silently never added. Labels are now routed through a code-to-column map, which also fixes English labels when `mongolstats.lang = "mn"`.
*   **Offline mode no longer fires the session-cookie GET**: `.px_session_cookie()` bypassed the offline gate, so `nso_data()` with cached metadata still performed one live request in offline mode.
*   **Retries no longer crash on the first backoff**: the default retry backoff formula referenced `..attempt`, which does not exist in rlang lambdas (the argument is `.x`), so any transient response (429/503) failed with "object '..attempt' not found" instead of retrying.
*   **HTTP error and verbose messages now include the request URL**: an internal misuse of `httr2::req_url()` as a getter meant the URL always rendered as `NA` and was dropped from messages.
*   **Time columns typed `"t"` are handled**: the PXWeb response flattener kept only `"d"`-typed columns; a server typing its time column `"t"` (the PXWeb convention; NSO currently uses `"d"`) would have misaligned row keys with column names.
*   **`nso_fetch()` now honors the `mongolstats.default_labels` option**, matching `nso_data()`.
*   **`nso_itms_search()` matches its query literally** as documented ("keyword"); regex metacharacters (e.g. `"c++"`) no longer error. `nso_search()` remains a regex search.
*   **`nso_period_seq()` rejects trailing garbage** after a valid year (e.g. `"2024abc"`, `"2024-06"`); previously the year prefix was silently used.
*   **`mn_join_by_name()` and `mn_fuzzy_join_by_name()` error clearly** when `name_col` is not a column of `data`, instead of failing with an obscure replacement-length error.
*   **`nso_table_periods()` finds the time dimension for `lang = "mn"`** by also matching the Mongolian display name.
*   **Mixed codes and labels**: Selection values are now mapped element-wise, so codes and labels can be mixed in one vector (e.g. `Sex = c("Total", "1")`). Previously this produced an "Unknown value: NA" error. Duplicated labels in table metadata now produce a warning naming the ambiguous label.
*   **Consistent errors**: `as_px_query()` now raises the same classed errors as `nso_data()` for invalid selections (previously a plain `stop()`).
*   **Correct error classes**: network failures (DNS, timeout) now signal `mongolstats_http_error`; previously they were misclassified as `mongolstats_offline_error`, so handlers could not tell offline mode from a genuine connection problem.

## Performance

*   The PXWeb session cookie is now seeded once per base URL per session instead of once per data fetch, removing one GET round trip from every `nso_data()` call after the first.
*   `mn_fuzzy_join_by_name()` no longer computes a base-R distance matrix that was immediately discarded when stringdist is installed.

## CRAN compliance

*   The cache test no longer writes to (or clears) the user's real cache directory: it now skips when the cache packages are missing and uses a throwaway directory under `tempdir()`. Previously it ran on CRAN and touched `rappdirs::user_cache_dir("mongolstats")`.
*   The `nso_cache_enable()` example is now conditional on memoise/cachem/rappdirs being installed.
*   Network-dependent examples are now guarded with `NOT_CRAN` in addition to `curl::has_internet()`, so they no longer contact the live PXWeb API during CRAN checks. The `nso_rebuild_px_index()` example, which crawls the full catalogue, is wrapped in `\dontrun{}`.
*   `inst/extdata/air_monthly_cached.csv` is now gzip-compressed (6.4 Mb to 0.3 Mb), bringing the installed package size well under CRAN's threshold. `read.csv()` decompresses it transparently; only the vignette referenced it.

## Internal

*   Removed the unused legacy HTTP layer (`.nso_req()`, `.nso_get()`, `.nso_post()` and friends) together with the now-inert `mongolstats.base_url` option; all requests go to the PXWeb API base (`mongolstats.px_base_url`).
*   `nso_search()` and `nso_itms_search()` share one search helper; the PXWeb response flattener was factored into `.px_flatten_response()` and unit-tested; the `mongolstats.parallel` option is now registered and reported by `nso_options()`.
*   The GeoBoundaries metadata request now uses the same timeout/retry policy as other requests.
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
