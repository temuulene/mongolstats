# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

**mongolstats** is an R package that provides a tidyverse-friendly client for the National Statistics Office of Mongolia (NSO) Open Data API (opendata.1212.mn) and utilities for working with Mongolia administrative boundaries. The package is inspired by tidycensus ergonomics.

## Common Development Commands

### Testing
```r
# Quick smoke test
Rscript tools/smoke.R

# Run all unit tests
Rscript -e "invisible(lapply(list.files('R', full.names=TRUE), source)); library(testthat); test_dir('tests/testthat', reporter='summary')"

# R CMD check (full package validation)
Rscript -e "install.packages('roxygen2'); roxygen2::roxygenise()"
Rscript -e "options(crayon.enabled = TRUE); rcmdcheck::rcmdcheck(args = c('--no-manual', '--as-cran'), error_on = 'warning', check_dir = 'check')"
```

### Documentation
```r
# Regenerate Rd documentation
Rscript -e "roxygen2::roxygenise()"

# Build pkgdown site locally (requires Pandoc or RStudio)
Rscript tools/build_site.R
```

## Architecture

### Core Components

1. **HTTP Layer** (`R/http.R`)
   - Base URL: https://opendata.1212.mn (overridable via options)
   - Uses httr2 with automatic retry (3 attempts, exponential backoff)
   - `.nso_req()`, `.nso_get()`, `.nso_post()` handle all API communication
   - Custom User-Agent: `mongolstats/{version}`

2. **Data Retrieval** (`R/data.R`)
   - `nso_data()`: Fetch single table with optional filters (period, code, code1, code2)
   - `nso_package()`: Batch fetch multiple tables from a request tibble
   - Automatically standardizes column names (TBL_ID → tbl_id, DTVAL_CO → value, etc.)
   - Supports optional label columns: "none", "en", "mn", "both"

3. **Discovery** (`R/itms.R`, `R/sector.R`, `R/search.R`)
   - `nso_itms()`: List all available tables (memoized)
   - `nso_itms_detail(tbl_id)`: Get codebook for table's variables (CODE, CODE1, CODE2)
   - `nso_sectors()`, `nso_subsectors()`: Browse sector hierarchy
   - `nso_search()`: Keyword search across table names

4. **Geography** (`R/geography.R`, `R/names.R`)
   - `mn_boundaries(level)`: Fetch ADM0/ADM1/ADM2 sf geometries from GeoBoundaries API
   - `mn_join_by_name()`: Exact join by normalized names
   - `mn_fuzzy_join_by_name()`: Fuzzy string matching join (stringdist)
   - Name normalization uses stringi for case/diacritic handling

5. **Caching** (`R/cache.R`)
   - Optional on-disk caching via memoise + cachem
   - Caches `nso_itms()` and `nso_itms_detail()` results
   - Enable with `nso_cache_enable()`, cache stored in `rappdirs::user_cache_dir("mongolstats")/v1`

6. **Utilities** (`R/periods.R`, `R/utils.R`)
   - `nso_period_seq()`: Generate period sequences (YYYY or YYYYMM)
   - `nso_table_periods()`: Derive valid periods from table metadata
   - Helper functions for tibble coercion and type handling

### Key Design Patterns

- **Memoization**: `nso_itms()` and `nso_itms_detail()` are wrapped with memoise when caching is enabled
- **Column standardization**: API returns uppercase column names; package normalizes to lowercase snake_case
- **Label flexibility**: Users can request English/Mongolian labels or both via `labels` parameter
- **Defensive type coercion**: Handles API returning scalar strings vs. lists inconsistently

## Code Style

- Tidyverse conventions (use dplyr, purrr, tibble)
- Internal functions prefixed with `.`
- Use `%||%` operator for NULL coalescing (defined in utils)
- Functions marked `@noRd` in roxygen don't generate .Rd files (internal helpers)

## CI/CD

- **R-CMD-check**: Runs on push/PR to main/master (ubuntu-latest)
  - Generates Rd via roxygen2 before check
  - Runs `rcmdcheck::rcmdcheck()` with `--as-cran` and `error_on = 'warning'`
- **pkgdown**: Builds documentation site on push to main

## Dependencies

**Core**: httr2, jsonlite, tibble, dplyr, purrr, stringr, sf, memoise, cachem, rappdirs, stringi, stringdist

**Suggested**: testthat (>= 3.0.0), knitr, rmarkdown, pkgdown, roxygen2

## Testing Notes

- Tests in `tests/testthat/test-*.R`
- Use testthat edition 3 (`Config/testthat/edition: 3`)
- Smoke tests in `tools/smoke.R` for quick validation

## Vignettes

Vignettes are in `vignettes/` and disabled by default to stabilize CI:
- `getting-started.Rmd`
- `mapping.Rmd`
- `fuzzy-joins.Rmd`
- `code-joins.Rmd`
- `discovery.Rmd`
- `fetching-periods.Rmd`
- `batch-workflows.Rmd`
