Agents Guide

This document provides guidance for AI coding agents working in this repository. It summarizes major features, how they work, and the files involved so agents can navigate and extend the codebase efficiently.

Overview

mongolstats is an R package that offers a tidyverse-friendly client for the National Statistics Office of Mongolia (NSO) open data via the PXWeb API (data.1212.mn) and utilities for working with Mongolia administrative boundaries as sf. The package focuses on ergonomic discovery, data access, and mapping workflows.

Key entry points:
- Package metadata: DESCRIPTION, NAMESPACE, README.md
- R sources: R/
- Vignettes: vignettes/
- Tests: tests/testthat/
- Prebuilt PX index: inst/extdata/px_index.json
- Helper scripts: tools/

Major Features

1) PXWeb Table Discovery and Variables
- nso_itms() lists available PXWeb tables with IDs, English/Mongolian titles, and inferred period ranges.
- nso_variables(tbl_id) returns a tidy codebook (field, item code, English and Mongolian labels) for a given table.
- Sector navigation: nso_sectors() (top level), nso_subsectors(id) (children).
- Search helpers: nso_itms_search(query) and nso_search(query, sector).

2) Data Fetching (PXWeb)
- nso_data(tbl_id, selections, labels) fetches data by selecting values for each dimension using codes or labels; returns a tibble with dimension columns and a numeric value column.
- nso_package(requests, labels) batches multiple table requests and row-binds results, adding tbl_id per row.
- Optional label enrichment: labels = "none" | "en" | "mn" | "both" adds *_en and/or *_mn columns for each dimension.

3) Period Utilities
- nso_period_seq(start, end, by = "Y" | "M") builds yearly or monthly codes (YYYY / YYYYMM).
- nso_table_periods(tbl_id) inspects table metadata to derive valid period labels for that table.

4) Geography and Joins
- mn_boundaries(level = "ADM0" | "ADM1" | "ADM2") downloads Mongolia administrative boundaries as sf via the GeoBoundaries API.
- mn_boundaries_normalize(g, name_col) adds normalized name_std for robust matching.
- mn_join_by_name(data, name_col, level, boundaries) exact-joins tabular data to boundaries by normalized names.
- mn_fuzzy_join_by_name(..., max_distance, method) fuzzy-joins using string distance; powered by stringdist when available.
- mn_boundary_keys(level) returns a tidy crosswalk of boundary keys (shapeID, shapeName, shapeISO, name_std).

5) Caching
- nso_cache_enable(dir) enables on-disk memoization for table lists, codebooks, and PXWeb metadata using memoise/cachem under rappdirs::user_cache_dir("mongolstats")/v1 by default.
- nso_cache_disable() and nso_cache_clear() control cache state.

6) Configuration
- nso_options(...) wraps base options for mongolstats.* keys: base URLs, PX language (mongolstats.lang), timeouts/retries, verbosity, and default label preference.
- Package defaults are set in R/zzz.R on load.

How It Works

PXWeb integration (R/pxweb.R)
- URL construction: .px_url() uses mongolstats.px_base_url, language (en/mn), and database (NSO).
- Listing/metadata: .px_list() and .px_meta() call PXWeb endpoints via httr2; BOM is stripped and JSON parsed.
- Indexing: nso_px_tables() traverses the PXWeb tree; .px_index() prefers the embedded JSON index (inst/extdata/px_index.json) and falls back to live traversal if missing. nso_rebuild_px_index() refreshes and optionally writes the index.
- Variables: nso_px_variables(tbl_id) returns bilingual codebooks by merging English and Mongolian metadata.
- Data: nso_px_data() builds a PXWeb query from user selections, maps labels to codes when needed, and flattens the response into a tidy tibble. nso_data() and nso_package() wrap this and add optional label columns via .px_add_labels().

HTTP utilities (R/http.R)
- Centralized request setup with retry/backoff and a custom User-Agent. .nso_perform() standardizes error handling.

Geography (R/geography.R, R/names.R)
- GeoBoundaries API for GeoJSON; name normalization with stringi/stringr enables exact/fuzzy joins.

Caching (R/cache.R)
- Memoized wrappers for PXWeb listing/metadata when caching is enabled.

Key Files

- PXWeb core: R/pxweb.R, helpers R/aaa_px_helpers.R
- Data API wrappers: R/data.R
- Discovery/search: R/itms.R, R/sector.R, R/search.R
- Geography and joins: R/geography.R, R/names.R
- Periods/utilities: R/periods.R, R/utils.R
- HTTP utilities: R/http.R
- Options and defaults: R/options.R, R/zzz.R, R/globals.R
- Caching: R/cache.R
- Embedded PX index: inst/extdata/px_index.json
- Vignettes: vignettes/*.Rmd (getting started, discovery, periods, batch workflows, mapping, fuzzy/code joins)
- Tests: tests/testthat/*.R
- Tooling: tools/smoke.R, tools/build_site.R, tools/release_check.R

Development

Testing
```r
# Quick smoke test
Rscript tools/smoke.R

# Run unit tests
Rscript -e "invisible(lapply(list.files('R', full.names=TRUE), source)); library(testthat); test_dir('tests/testthat', reporter='summary')"
```

Docs/site
```r
# Regenerate Rd docs
Rscript -e "roxygen2::roxygenise()"

# Build pkgdown site
Rscript tools/build_site.R
```

Optional full check (requires rcmdcheck, roxygen2)
```r
Rscript -e "install.packages('roxygen2'); roxygen2::roxygenise()"
Rscript -e "options(crayon.enabled = TRUE); rcmdcheck::rcmdcheck(args = c('--no-manual', '--as-cran'), error_on = 'warning', check_dir = 'check')"
```

CI/CD and Docs

- GitHub Actions for R CMD check and pkgdown site (see badges in README.md).
- pkgdown configuration: _pkgdown.yml.

Dependencies

Core: httr2, jsonlite, tibble, dplyr, purrr, stringr, sf, memoise, cachem, rappdirs, stringi, stringdist, curl

Suggested: testthat (>= 3.0.0), knitr, rmarkdown, pkgdown, roxygen2, lifecycle

Notes for Agents

- Prefer PXWeb functions (nso_*) for new data access; the low-level HTTP helpers support PXWeb and future endpoints.
- Keep functions small, composable, and use a leading dot for non-exported helpers.
- If expanding discovery or adding stable geographic code support, update the embedded PX index and consider adding a vignette example.

