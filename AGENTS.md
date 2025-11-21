Agent Guide: mongolstats

Purpose
- Tidy R client for the National Statistics Office of Mongolia PXWeb API (data.1212.mn) and Mongolia administrative boundaries. Provides discovery, query building, data fetch, labeling, batching, caching/offline, and boundary join helpers.

At a Glance
- Package name: mongolstats
- Primary domains: PXWeb data access, discovery/search, query builder + fetch, time periods, caching + offline, boundaries (sf) and joins, batch + parallel utilities, docs site generation.
- Key dependencies: httr2, jsonlite, tibble/dplyr/purrr/stringr, sf, memoise/cachem/rappdirs, stringi/stringdist, curl; suggests: pxweb, httptest2, future/future.apply, cli, pkgdown.

Directory Structure
- R/: Core package source
- man/: Generated Rd docs (exported API)
- vignettes/: Articles demonstrating workflows (pkgdown site)
- tests/: testthat tests (+ optional recorded HTTP fixtures)
- inst/extdata/: Embedded assets (prebuilt PX index)
- tools/: Dev scripts (check/build site/style)
- DESCRIPTION, NAMESPACE, README, _pkgdown.yml: Package metadata and docs

Major Features (What and How)
1) Discover PXWeb Tables and Variables
- List all tables: nso_itms() → tibble with px_path, px_file, tbl_id, titles, period range.
  - Backed by a prebuilt PX index (inst/extdata/px_index.json) loaded via .px_index(); if missing, crawls PXWeb.
- Inspect variables/codebooks: nso_itms_detail(tbl_id) alias nso_variables() → codes and labels per dimension.
- Navigate PXWeb catalog: nso_sectors() for top-level; nso_subsectors(path) for children.
- Keyword search: nso_itms_search(query) and higher-level nso_search(query, sector, fields).
- Implementation:
  - PX traversal and metadata: R/pxweb.R
  - Discovery wrappers + aliases: R/itms.R, R/search.R, R/sector.R
  - Prebuilt index loading: R/pxweb.R (.px_index_embedded, .px_index)

2) Build Queries and Fetch Data
- Query object: nso_query(tbl_id, selections) prints compact summary; convert to PX body via as_px_query().
- Execute: nso_fetch(nso_query, labels = 'code'|'en'|'mn'|'both') → tibble with one column per dimension + numeric value.
- Direct fetch: nso_data(tbl_id, selections, labels) builds PX JSON, POSTs to PXWeb, flattens response. Adds label columns when requested.
- Batch: nso_package(list_of_requests or tibble), optional parallel via future.apply; adds tbl_id column for multi‑table results; progress bar in interactive sessions when cli available.
- Implementation:
  - Query builder + fetch helpers: R/query.R, R/data.R
  - Low-level POST, flattening, cookie seeding, fallback to pxweb: R/pxweb.R (nso_px_data)

3) Period Utilities
- Build sequences: nso_period_seq(start, end, by = 'Y'|'M').
- Discover valid periods for a table: nso_table_periods(tbl_id) by inspecting time-like dimension in metadata.
- Implementation: R/periods.R

4) Labeling
- After fetch, map codes → English/Mongolian labels by joining PX metadata; selection accepts codes or labels and maps to codes internally.
- User controls via labels in nso_data()/nso_fetch(): 'none'|'en'|'mn'|'both'.
- Implementation: R/data.R (.px_add_labels), R/query.R (selection label→code mapping)

5) Caching and Offline Mode
- Disk cache for discovery (tables, variables) and PX metadata; optional TTL.
- Enable/disable/clear/status: nso_cache_enable(dir, ttl), nso_cache_disable(), nso_cache_clear(), nso_cache_status().
- Offline mode: nso_offline_enable()/nso_offline_disable() blocks network; discovery returns empty tibbles; data fetch errors with typed condition.
- Implementation: R/cache.R (memoise + cachem + rappdirs env), R/cache_shims.R, R/http.R (offline guard + common req pipeline)

6) Administrative Boundaries and Joins (sf)
- Download boundaries via GeoBoundaries API: mn_boundaries(level = 'ADM0'|'ADM1'|'ADM2').
- Normalize names for robust matching: mn_boundaries_normalize(); simple name join: mn_join_by_name(); fuzzy join: mn_fuzzy_join_by_name(max_distance, method).
- Keys helper: mn_boundary_keys(level) → tibble with shapeID, shapeName, shapeISO, name_std for code-based joins.
- Implementation: R/geography.R, R/names.R

7) Search and Catalog Navigation
- Search across table titles (English/Mongolian): nso_search(query, sector, fields) and nso_itms_search().
- Sector listing and children for UI-like navigation: nso_sectors(), nso_subsectors().
- Implementation: R/search.R, R/sector.R

8) Developer Tooling and Site
- Pkgdown site configuration: _pkgdown.yml.
- Build site (installs local package and vignettes): tools/build_site.R, tools/full_site.R.
- Full checks with vignettes/Pandoc handling: tools/full_check.R; release checks: tools/release_check.R.
- Code style: tools/style.R (styler tidyverse_style).

Key Files and Responsibilities
- R/pxweb.R: PXWeb URL builders, traversal (.px_list/.px_meta), index (.px_index), variable/dimension helpers (nso_dims, nso_dim_values), data fetch (nso_px_data) with cookie seeding and pxweb fallback.
- R/query.R: nso_query, as_px_query, nso_fetch, body construction (.px_build_body), selection validation and label→code mapping.
- R/data.R: nso_data, label enrichment (.px_add_labels), batching (nso_package) with optional parallel and progress.
- R/periods.R: nso_period_seq, nso_table_periods.
- R/itms.R: nso_itms, nso_itms_detail, nso_itms_search, nso_itms_by_sector (+ aliases nso_tables, nso_variables).
- R/search.R: nso_search.
- R/sector.R: nso_sectors, nso_subsectors.
- R/geography.R: mn_boundaries (GeoBoundaries).
- R/names.R: normalization, exact/fuzzy boundary joins, boundary keys.
- R/cache.R + R/cache_shims.R: memoised discovery + PX metadata cache, API (.mongolstats_cache_env).
- R/http.R: common request setup (httr2), retries/backoff, verbose logging, offline mode; user-facing nso_offline_enable/disable.
- R/options.R: nso_options() wrapper to set/get package options.
- R/aaa_px_helpers.R: small helpers (.px_strip_bom, .px_first_nonempty, .px_chr).
- R/utils.R: tiny misc helpers (.ms_to_chr, .nso_progress).
- R/zzz.R: .onLoad default options (base URLs, language, timeout, retry, verbosity, offline, progress, default label behavior).
- inst/extdata/px_index.json: embedded PX index used to avoid cold-start crawl.

Exported API (grouped)
- Discover: nso_itms, nso_tables, nso_itms_detail, nso_variables, nso_dims, nso_dim_values
- Catalog: nso_sectors, nso_subsectors
- Search: nso_itms_search, nso_search
- Query/Fetch: nso_query, as_px_query, nso_fetch, nso_data, nso_package
- Periods: nso_period_seq, nso_table_periods
- Boundaries/Joins: mn_boundaries, mn_boundary_keys, mn_boundaries_normalize, mn_join_by_name, mn_fuzzy_join_by_name
- Cache/Offline/Options: nso_cache_enable, nso_cache_disable, nso_cache_clear, nso_cache_status, nso_offline_enable, nso_offline_disable, nso_options, nso_rebuild_px_index

Configuration & Options
- Defaults are set on load (see R/zzz.R):
  - mongolstats.base_url: https://data.1212.mn/pxweb
  - mongolstats.px_base_url: https://data.1212.mn/api/v1
  - mongolstats.lang: 'en' (also supports 'mn')
  - mongolstats.px_db: 'NSO'
  - mongolstats.timeout: 30 (seconds)
  - mongolstats.retry_tries: 3
  - mongolstats.retry_backoff: exponential jitter formula (see R/http.R)
  - mongolstats.verbose: FALSE (prints URLs/payload on TRUE)
  - mongolstats.offline: FALSE (block network when TRUE)
  - mongolstats.progress: TRUE (batch progress in interactive sessions)
  - mongolstats.default_labels: 'none'
- Get/set via nso_options(name = value). Example: nso_options(mongolstats.lang = 'mn').

HTTP Behavior
- Requests built with httr2; retries with configurable backoff; JSON parsing via jsonlite.
- PXWeb POST: Tries with/without .px suffix; seeds rxid cookie if server sets it; on failure, optional fallback via pxweb package when installed.
- Errors raise typed 'mongolstats_http_error' conditions with informative messages.
- Offline mode raises 'mongolstats_offline_error' when a networked function is called.

Caching
- Enable disk cache: nso_cache_enable(dir = rappdirs::user_cache_dir('mongolstats')/v1, ttl = NULL|seconds).
- Caches: table list, variable details, PXWeb list/meta calls; memoised via memoise/cachem inside .mongolstats_cache_env.
- Manage via nso_cache_disable(), nso_cache_clear(), nso_cache_status().

Boundary Workflows
- Exact joins: normalize both boundary names and data using mn_boundaries_normalize(); join on name_std via mn_join_by_name().
- Fuzzy joins: mn_fuzzy_join_by_name(data, name_col, max_distance, method) with optional stringdist; review matches.
- Code-based joins: prefer keys via mn_boundary_keys(level) and stable identifiers (e.g., shapeISO) over names when available.

Testing
- Run tests: devtools::test() or Rscript -e "testthat::test_local()".
- Networked tests are skipped on CRAN/offline. Recorded HTTP tests require httptest2 and mock dirs (tests/testthat/px_...).
- Notable tests: utils/helpers, periods, offline behavior, joins, endpoints, integration, recorded HTTP.

Docs & Site
- Build site locally: Rscript tools/build_site.R (installs deps to ./.Rlib, roxygenise, install_local, pkgdown::build_site). Pandoc required.
- Full site with Pandoc discovery on Windows: Rscript tools/full_site.R.
- Regenerate Rd: roxygen2::roxygenise().

Development Tips
- Prefer using the embedded PX index; rebuild via nso_rebuild_px_index(path) when needed.
- For large table pulls, chunk high-cardinality dimensions and bind rows (see vignettes/parallel-batching.Rmd).
- Use labels = 'code' for stable scripts; add labels later for presentation.
- Enable caching during iterative discovery to reduce metadata latency.
- Guard vignettes/examples with curl::has_internet() for reproducibility.

Conventions
- Function prefixes: nso_* for PXWeb/client utilities; mn_* for Mongolia boundary/joins.
- Style: tidyverse_style (use tools/style.R). Keep functions small, composable, and pipe-friendly.
- Error messages should be actionable (list available codes/labels on selection mismatch).

Common Entry Points
- Quick discovery: nso_itms(), nso_search('population'), nso_dims(tbl), nso_dim_values(tbl, 'Year', labels = 'en')
- Quick fetch: nso_data(tbl, selections = list(Year = '2024', Sex = 'Total', ...), labels = 'en')
- Batch fetch: nso_package(list(list(tbl_id=..., selections=...), ...))
- Boundaries: mn_boundaries('ADM1') |> mn_boundaries_normalize() |> ...

Troubleshooting Notes
- 400/HTTP failures: inspect dimensions and values; reduce selection size; try pxweb fallback; increase timeout/retries via options.
- Offline errors: disable offline or rely on cached metadata only.
- Pandoc not found for site: tools/full_site.R tries common Windows paths and RSTUDIO_PANDOC.

