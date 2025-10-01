# mongolstats

<!-- badges: start -->
[![pkgdown](https://github.com/temuulene/mongolstats/actions/workflows/pkgdown.yml/badge.svg)](https://github.com/temuulene/mongolstats/actions/workflows/pkgdown.yml)
[![R-CMD-check](https://github.com/temuulene/mongolstats/actions/workflows/R-CMD-check.yml/badge.svg)](https://github.com/temuulene/mongolstats/actions/workflows/R-CMD-check.yml)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

Tidy access to the National Statistics Office of Mongolia (NSO) Open Data API (opendata.1212.mn) and Mongolia administrative boundaries, inspired by the ergonomics of tidycensus. Provides a tidyverse-friendly interface for discovering tables, exploring codebooks, fetching data, and working with `sf` geometries for mapping.

## Installation

```r
# install.packages("devtools")
devtools::install_github("temuulene/mongolstats")
```

## Quick start

```r
library(mongolstats)
library(dplyr)

# Enable caching to speed up discovery calls
nso_cache_enable()

# List available tables
itms <- nso_itms()
itms %>% select(tbl_id, tbl_eng_nm, strt_prd, end_prd) %>% slice_head(n = 5)

# Inspect variables (codebook) for a table
vars <- nso_itms_detail("DT_NSO_2600_004V1")
vars %>% count(field)

# Fetch data with labels
dat <- nso_data(
  tbl_id = "DT_NSO_2600_004V1",
  period = c("201701","201702","201703"),
  code   = c("1","2"),
  code1  = "101",
  labels = "en"
)
dat %>% select(tbl_id, period, code, code_en, code1_en, value) %>% slice_head(n = 6)

# Batch fetch multiple tables
reqs <- tibble::tibble(
  tbl_id = c("DT_NSO_0300_062V1", "DT_NSO_0300_004V5"),
  period = "2016",
  code   = c("12", "181"),
  code1  = c("101", "11")
)
pkg <- nso_package(reqs, labels = "en")
pkg %>% select(tbl_id, period, value) %>% slice_head(n = 6)
```

## Features

- Tidy HTTP client for NSO Open Data API (v2)
- Discover tables and variables with `nso_itms()` / `nso_itms_detail()`
- Fetch data via `nso_data()`; batch requests with `nso_package()`
- Optional label columns in English or Mongolian (`labels = "en" | "mn" | "both"`)
- Sector discovery and table search helpers
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

MIT © Temuulen Enebish

