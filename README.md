# mongolstats

<!-- badges: start -->
[![R-CMD-check](https://github.com/temuulene/mongolstats/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/temuulene/mongolstats/actions/workflows/R-CMD-check.yaml)
[![pkgdown](https://github.com/temuulene/mongolstats/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/temuulene/mongolstats/actions/workflows/pkgdown.yaml)
[![Website](https://img.shields.io/badge/docs-pkgdown-blue.svg)](https://temuulene.github.io/mongolstats/)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

Tidy access to the National Statistics Office of Mongolia (NSO) statistics via the PXWeb API (data.1212.mn) and Mongolia administrative boundaries, inspired by the ergonomics of tidycensus. Provides a tidyverse-friendly interface for discovering tables, exploring codebooks, fetching data, and working with `sf` geometries for mapping.

## Installation

```r
# install.packages("devtools")
devtools::install_github("temuulene/mongolstats")
```

## Quick start

```r
library(mongolstats)
library(dplyr)

# Use new PXWeb API (data.1212.mn)
nso_options(mongolstats.lang = "en")

# List available tables
itms <- nso_itms()
itms %>% select(tbl_id, tbl_eng_nm, strt_prd, end_prd) %>% slice_head(n = 5)

# Inspect variables (codebook) for a table
vars <- nso_variables("DT_NSO_0300_001V2")
vars %>% count(field)

# Fetch data
dat <- nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(Sex = "Total", Age = "Total", Year = "2024")
)
dat %>% slice_head(n = 6)
```

### Live traversal (simple path)

```r
# Navigate catalog → pick table → fetch
secs <- nso_sectors()
subsecs <- nso_subsectors(secs$id[1])
tbls <- nso_itms_by_sector(subsecs$id[1])
meta <- nso_table_meta(tbls$tbl_id[1])  # per-dimension codebooks

dat2 <- nso_data(
  tbl_id = tbls$tbl_id[1],
  selections = list(Year = c("2023", "2024")),
  value_name = "Variable",           # rename value column
  include_raw = TRUE                  # attach raw PX payload as attr(px_raw)
)
attr(dat2, "px_raw") %>% names()
```

## Features

- PXWeb client for NSO data (data.1212.mn)
- Discover tables and variables with `nso_itms()` / `nso_itms_detail()`
- Fetch data via `nso_data(tbl_id, selections=...)`; batch with `nso_package()`
- Optional label columns in English or Mongolian (`labels = "en" | "mn" | "both"`)
- Category navigation and table search helpers
- Mongolia administrative boundaries (ADM0–ADM2) as `sf`
- Exact and fuzzy name-based boundary joins
- Lightweight on-disk caching for faster table/codebook lookups

## Vignettes

- Getting started
- Discovering tables and variables
- Fetching data and periods
- Batch fetching workflows
- Mapping, fuzzy joins, and code-based joins

## Contributing

Issues and pull requests are welcome: https://github.com/temuulene/mongolstats/issues

## License

MIT Ac Temuulen Enebish
