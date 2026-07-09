# Changelog

## mongolstats 0.2.0

### Breaking changes

- **Stricter selection validation**:
  [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md),
  [`nso_package()`](https://temuulene.github.io/mongolstats/reference/nso_package.md),
  [`nso_query()`](https://temuulene.github.io/mongolstats/reference/nso_query.md),
  and
  [`as_px_query()`](https://temuulene.github.io/mongolstats/reference/as_px_query.md)
  now error when a selection name does not match any dimension in the
  table (previously the selection was silently ignored and the full
  dimension was fetched), when selections are unnamed, or when two
  selections target the same dimension. This prevents silently fetching
  wrong-scope data. Errors carry class `mongolstats_selection_error`.

### New features

- **[`nso_package()`](https://temuulene.github.io/mongolstats/reference/nso_package.md)
  no longer fails silently**: tables that fail to fetch are reported in
  a warning naming each table, and a new `strict = TRUE` argument raises
  an error instead. Previously failed tables were dropped without any
  signal.
- **Unified `labels` vocabulary**:
  [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md)
  and
  [`nso_package()`](https://temuulene.github.io/mongolstats/reference/nso_package.md)
  accept `"code"` as an alias for `"none"`, and
  [`nso_fetch()`](https://temuulene.github.io/mongolstats/reference/nso_fetch.md)
  and
  [`nso_dim_values()`](https://temuulene.github.io/mongolstats/reference/nso_dim_values.md)
  accept `"none"` as an alias for `"code"`, so either spelling works
  everywhere.
- **[`mn_boundaries()`](https://temuulene.github.io/mongolstats/reference/mn_boundaries.md)
  session cache**: boundary downloads are cached in memory for the
  session (repeated calls, including via
  [`mn_join_by_name()`](https://temuulene.github.io/mongolstats/reference/mn_join_by_name.md),
  no longer re-download multi-megabyte GeoJSON). A `refresh = TRUE`
  argument bypasses the cache.
- **[`nso_period_seq()`](https://temuulene.github.io/mongolstats/reference/nso_period_seq.md)
  input validation**: malformed periods (wrong width, month 13, `NA`,
  vectors) and reversed ranges now error with a clear message instead of
  silently returning a descending sequence or failing inside
  [`seq.Date()`](https://rdrr.io/r/base/seq.Date.html).

### Bug fixes

- Ambiguous table ids now warn: the NSO catalogue can reuse one table id
  for different tables in different folders (e.g. `DT_NSO_2400_015V1`
  currently names both the monthly SO2 station table and an annual
  air-quality-standards table). mongolstats now warns (class
  `mongolstats_ambiguous_table`) and names the folder it picked instead
  of silently resolving to an arbitrary table. Tables that are merely
  cross-listed in several folders under the same name resolve silently.

- The embedded PXWeb table index has been refreshed to match the current
  NSO catalogue. Several tables (e.g. cancer incidence
  `DT_NSO_2100_012V1` and communicable diseases `DT_NSO_2100_035V1`)
  moved to different catalogue folders, which made lookups through the
  stale index return empty results.

- **`labels = "mn"` and `labels = "both"` now actually attach Mongolian
  labels**: label metadata was matched to data columns by display text,
  but the two languages only share the dimension *code* (the English
  column is “Sex” while both languages use the code “Хүйс”), so
  cross-language labels were silently never added. Labels are now routed
  through a code-to-column map, which also fixes English labels when
  `mongolstats.lang = "mn"`.

- **Offline mode no longer fires the session-cookie GET**:
  `.px_session_cookie()` bypassed the offline gate, so
  [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md)
  with cached metadata still performed one live request in offline mode.

- **Retries no longer crash on the first backoff**: the default retry
  backoff formula referenced `..attempt`, which does not exist in rlang
  lambdas (the argument is `.x`), so any transient response (429/503)
  failed with “object ‘..attempt’ not found” instead of retrying.

- **HTTP error and verbose messages now include the request URL**: an
  internal misuse of
  [`httr2::req_url()`](https://httr2.r-lib.org/reference/req_url.html)
  as a getter meant the URL always rendered as `NA` and was dropped from
  messages.

- **Time columns typed `"t"` are handled**: the PXWeb response flattener
  kept only `"d"`-typed columns; a server typing its time column `"t"`
  (the PXWeb convention; NSO currently uses `"d"`) would have misaligned
  row keys with column names.

- **[`nso_fetch()`](https://temuulene.github.io/mongolstats/reference/nso_fetch.md)
  now honors the `mongolstats.default_labels` option**, matching
  [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md).

- **[`nso_itms_search()`](https://temuulene.github.io/mongolstats/reference/nso_itms_search.md)
  matches its query literally** as documented (“keyword”); regex
  metacharacters (e.g. `"c++"`) no longer error.
  [`nso_search()`](https://temuulene.github.io/mongolstats/reference/nso_search.md)
  remains a regex search.

- **[`nso_period_seq()`](https://temuulene.github.io/mongolstats/reference/nso_period_seq.md)
  rejects trailing garbage** after a valid year (e.g. `"2024abc"`,
  `"2024-06"`); previously the year prefix was silently used.

- **[`mn_join_by_name()`](https://temuulene.github.io/mongolstats/reference/mn_join_by_name.md)
  and
  [`mn_fuzzy_join_by_name()`](https://temuulene.github.io/mongolstats/reference/mn_fuzzy_join_by_name.md)
  error clearly** when `name_col` is not a column of `data`, instead of
  failing with an obscure replacement-length error.

- **[`nso_table_periods()`](https://temuulene.github.io/mongolstats/reference/nso_table_periods.md)
  finds the time dimension for `lang = "mn"`** by also matching the
  Mongolian display name.

- **Mixed codes and labels**: Selection values are now mapped
  element-wise, so codes and labels can be mixed in one vector
  (e.g. `Sex = c("Total", "1")`). Previously this produced an “Unknown
  value: NA” error. Duplicated labels in table metadata now produce a
  warning naming the ambiguous label.

- **Consistent errors**:
  [`as_px_query()`](https://temuulene.github.io/mongolstats/reference/as_px_query.md)
  now raises the same classed errors as
  [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md)
  for invalid selections (previously a plain
  [`stop()`](https://rdrr.io/r/base/stop.html)).

- **Correct error classes**: network failures (DNS, timeout) now signal
  `mongolstats_http_error`; previously they were misclassified as
  `mongolstats_offline_error`, so handlers could not tell offline mode
  from a genuine connection problem.

### Performance

- The PXWeb session cookie is now seeded once per base URL per session
  instead of once per data fetch, removing one GET round trip from every
  [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md)
  call after the first.
- [`mn_fuzzy_join_by_name()`](https://temuulene.github.io/mongolstats/reference/mn_fuzzy_join_by_name.md)
  no longer computes a base-R distance matrix that was immediately
  discarded when stringdist is installed.

### CRAN compliance

- The cache test no longer writes to (or clears) the user’s real cache
  directory: it now skips when the cache packages are missing and uses a
  throwaway directory under
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html). Previously it ran
  on CRAN and touched `rappdirs::user_cache_dir("mongolstats")`.
- The
  [`nso_cache_enable()`](https://temuulene.github.io/mongolstats/reference/nso_cache_enable.md)
  example is now conditional on memoise/cachem/rappdirs being installed.
- Network-dependent examples are now guarded with `NOT_CRAN` in addition
  to
  [`curl::has_internet()`](https://jeroen.r-universe.dev/curl/reference/nslookup.html),
  so they no longer contact the live PXWeb API during CRAN checks. The
  [`nso_rebuild_px_index()`](https://temuulene.github.io/mongolstats/reference/nso_rebuild_px_index.md)
  example, which crawls the full catalogue, is wrapped in `\dontrun{}`.
- `inst/extdata/air_monthly_cached.csv` is now gzip-compressed (6.4 Mb
  to 0.3 Mb), bringing the installed package size well under CRAN’s
  threshold. [`read.csv()`](https://rdrr.io/r/utils/read.table.html)
  decompresses it transparently; only the vignette referenced it.

### Internal

- Removed the unused legacy HTTP layer (`.nso_req()`, `.nso_get()`,
  `.nso_post()` and friends) together with the now-inert
  `mongolstats.base_url` option; all requests go to the PXWeb API base
  (`mongolstats.px_base_url`).
- [`nso_search()`](https://temuulene.github.io/mongolstats/reference/nso_search.md)
  and
  [`nso_itms_search()`](https://temuulene.github.io/mongolstats/reference/nso_itms_search.md)
  share one search helper; the PXWeb response flattener was factored
  into `.px_flatten_response()` and unit-tested; the
  `mongolstats.parallel` option is now registered and reported by
  [`nso_options()`](https://temuulene.github.io/mongolstats/reference/nso_options.md).
- The GeoBoundaries metadata request now uses the same timeout/retry
  policy as other requests.
- Selection mapping and validation consolidated into a single helper
  (`.px_map_selections()`), removing three divergent copies of the
  logic.
- Table resolution now goes through `.px_resolve_table()` everywhere
  (`.px_add_labels()`,
  [`nso_table_periods()`](https://temuulene.github.io/mongolstats/reference/nso_table_periods.md),
  `.px_build_body()`), removing the remaining inlined index lookups.
- Integration tests resolve dimension codes from live metadata instead
  of assuming positional codes, so tests no longer break when NSO adds a
  new period. Integration and endpoint tests now assert concrete shapes
  and no longer swallow errors.
- Added `tools/record_fixtures.R` to record the httptest2 fixtures used
  by `test-recorded-*.R`; those tests previously always skipped because
  the fixture directories were empty.
- Removed unused
  [`globalVariables()`](https://rdrr.io/r/utils/globalVariables.html)
  declarations, the unused lifecycle Suggests entry, and a stray
  rendered vignette HTML from the repository.

## mongolstats 0.1.1

CRAN release: 2026-01-26

Patch release to fix CRAN check failures on vignette rebuilding.

### Bug Fixes

- **Vignette CRAN Compliance**: Added `NOT_CRAN` guards to all vignettes
  to prevent code evaluation during CRAN checks. This fixes HTTP 400
  errors and data-dependent failures when vignettes are rebuilt on CRAN
  infrastructure where external API calls may fail.

## mongolstats 0.1.0

CRAN release: 2026-01-18

First minor release containing significant data updates, visualization
improvements, and refined documentation.

### Data & Features

- **Monthly Mortality Data**: Switched infant mortality analysis to use
  monthly data (`DT_NSO_2100_015V1`) for 2019-2024, enabling more
  granular trend analysis and up-to-date regional comparisons.
- **UB Air Quality**: Added accurate coordinates for Ulaanbaatar air
  quality monitoring stations and mapped them to districts.
- **Boundaries**: Fixed spatial mismatches in administrative boundary
  names to ensure seamless joins with NSO data.

### Visualization & UI

- **Plot Polish**: Applied publication-quality styling to all package
  plots, including:
  - Interactive tooltips with formatted units and rounded numbers.
  - Trend lines with confidence intervals for mortality rates.
  - Log-scaled population maps for better contrast.
  - Clean integer breaks on axes.
- **Standardized Aesthetics**: Consistent plot styling across all
  vignettes.

### Documentation

- **New Vignettes**:
  - `mortality-analysis`: In-depth analysis of infant mortality trends
    and seasonality.
  - `environmental-surveillance`: Detailed examination of air and water
    quality monitoring coverage.
- **Vignette Updates**:
  - `getting-started`: Renamed and streamlined for new users.
  - `discovery` & `mapping`: Updated with new datasets and visualization
    techniques.
- **Examples**: Added executable examples to key functions
  ([`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md),
  [`nso_itms()`](https://temuulene.github.io/mongolstats/reference/nso_itms.md),
  [`mn_boundaries()`](https://temuulene.github.io/mongolstats/reference/mn_boundaries.md)).

### Internal

- **Cleanup**: Removed legacy `labels.R` and unused artifacts.
- **Infrastructure**: Fully migrated `NAMESPACE` management to
  `roxygen2` and fixed GitHub Actions workflows.

## mongolstats 0.0.0.9000

Initial development snapshot.

- NSO API wrappers:
  [`nso_itms()`](https://temuulene.github.io/mongolstats/reference/nso_itms.md),
  [`nso_itms_detail()`](https://temuulene.github.io/mongolstats/reference/nso_itms_detail.md),
  [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md),
  [`nso_package()`](https://temuulene.github.io/mongolstats/reference/nso_package.md)
- Sector helpers:
  [`nso_sectors()`](https://temuulene.github.io/mongolstats/reference/nso_sectors.md),
  [`nso_subsectors()`](https://temuulene.github.io/mongolstats/reference/nso_subsectors.md),
  [`nso_search()`](https://temuulene.github.io/mongolstats/reference/nso_search.md)
- Boundaries:
  [`mn_boundaries()`](https://temuulene.github.io/mongolstats/reference/mn_boundaries.md),
  join helpers incl. fuzzy joins
- Caching for discovery endpoints
- Vignettes for getting started, mapping, fuzzy joins, and code-based
  joins
