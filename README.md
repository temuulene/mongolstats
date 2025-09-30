# mongolstats

![pkgdown](https://github.com/temuulene/mongolstats/actions/workflows/pkgdown.yml/badge.svg) ![R-CMD-check](https://github.com/temuulene/mongolstats/actions/workflows/R-CMD-check.yml/badge.svg)

Tidy access to the National Statistics Office of Mongolia Open Data API (opendata.1212.mn) and Mongolia administrative boundaries.

## Quick start

```r
library(mongolstats)
library(dplyr)

# List available tables
itms <- nso_itms()

glimpse(itms)

# Inspect variables for a table
vars <- nso_itms_detail("DT_NSO_2600_004V1")
vars %>% count(field)

# Fetch data for specific periods and codes
dat <- nso_data(
  tbl_id = "DT_NSO_2600_004V1",
  period = c("201701","201702","201703"),
  code = c("1","2"),
  code1 = "101",
  labels = "en"
)

## Install
# devtools::install_github("temuulene/mongolstats")

# Batch fetch multiple tables
reqs <- tibble::tibble(
  tbl_id = c("DT_NSO_0300_062V1","DT_NSO_0300_004V5"),
  period = "2016",
  code = c("12","181"),
  code1 = c("101","11")
)

pkg <- nso_package(reqs)

# Get administrative boundaries (ADM1 = aimag)
adm1 <- mn_boundaries("ADM1")

# Enable caching to speed up table/codebook lookups
nso_cache_enable()
```
# mongolstats

Tidy access to the National Statistics Office of Mongolia (NSO) Open Data API (opendata.1212.mn) and Mongolia administrative boundaries, inspired by the ergonomics of tidycensus. mongolstats provides a tidyverse-friendly interface for discovering tables, exploring codebooks, fetching data, and working with simple features (sf) geometries for mapping.

## Features

- Tidy HTTP client for NSO Open Data API (v2)
- Discover tables and variables with `nso_itms()` and `nso_itms_detail()`
- Fetch data via `nso_data()` and batch requests with `nso_package()`
- Optional label columns in English or Mongolian (`labels = "en" | "mn" | "both"`)
- Sector discovery and table search helpers
- Mongolia administrative boundaries (ADM0â€“ADM2) as `sf`
- Name-normalized and fuzzy boundary joins for quick mapping
- Lightweight on-disk caching for faster table/codebook lookups

## Installation

```r
# install.packages("devtools")
devtools::install_github("temuulene/mongolstats")
```

## Quick Start

```r
library(mongolstats)
library(dplyr)

# Enable caching to speed up repeated discovery calls
nso_cache_enable()

# 1) List available tables
itms <- nso_itms()
itms %>% select(tbl_id, tbl_eng_nm, strt_prd, end_prd) %>% slice_head(n = 5)

# 2) Inspect variables (codebook) for a table
vars <- nso_itms_detail("DT_NSO_2600_004V1")
vars %>% count(field)

# 3) Fetch data with labels
dat <- nso_data(
  tbl_id = "DT_NSO_2600_004V1",
  period = c("201701","201702","201703"),
  code   = c("1","2"),
  code1  = "101",
  labels = "en"
)

dat %>% select(tbl_id, period, code, code_en, code1_en, value) %>% slice_head(n = 6)

# 4) Batch fetch multiple tables
reqs <- tibble::tibble(
  tbl_id = c("DT_NSO_0300_062V1", "DT_NSO_0300_004V5"),
  period = "2016",
  code   = c("12", "181"),
  code1  = c("101", "11")
)

pkg <- nso_package(reqs, labels = "en")
pkg %>% select(tbl_id, period, value) %>% slice_head(n = 6)

# 5) Get boundaries and join by name
adm1 <- mn_boundaries("ADM1")
joined <- mn_join_by_name(dat, name_col = "code1_en", level = "ADM1", boundaries = adm1)

# 6) Fuzzy join by name (e.g., if names differ slightly)
joined_fuzzy <- mn_fuzzy_join_by_name(dat, name_col = "code1_en", level = "ADM1", max_distance = 2)
```

## Core Functions

- Discovery
  - `nso_itms()` â€” list all tables
  - `nso_itms_detail(tbl_id)` â€” codebook for variables (CODE, CODE1, CODE2)
  - `nso_sectors()`, `nso_subsectors(subid)` â€” sector hierarchy
  - `nso_search(query, sector)` â€” keyword search across table names

- Data
  - `nso_data(tbl_id, period, code, code1, code2, labels)` â€” fetch one table
  - `nso_package(requests, labels)` â€” batch fetch many tables
  - `labels` can be "none" (default), "en", "mn", or "both"

- Boundaries and Joins
  - `mn_boundaries(level)` â€” ADM0/ADM1/ADM2 `sf` from GeoBoundaries
  - `mn_boundaries_normalize(g)` â€” adds `name_std` for joining
  - `mn_join_by_name(data, name_col, level, boundaries)` â€” exact join
  - `mn_fuzzy_join_by_name(data, name_col, level, max_distance)` â€” fuzzy join
  - `mn_boundary_keys(level)` â€” quick crosswalk of boundary IDs/names

- Utilities
  - `nso_cache_enable()`, `nso_cache_disable()`, `nso_cache_clear()`
  - `nso_period_seq(start, end, by)` â€” build period codes (YYYY or YYYYMM)
  - `nso_table_periods(tbl_id)` â€” derive valid periods from table metadata

## Working with Periods

```r
# Monthly sequence
nso_period_seq("201801", "201812", by = "M")

# Yearly sequence
nso_period_seq("2018", "2022", by = "Y")

# Valid periods for a table
nso_table_periods("DT_NSO_0500_007V1")
```

## Mapping Essentials

```r
library(sf)
adm1 <- mn_boundaries("ADM1")
plot(sf::st_geometry(adm1))

# Join indicators to geometries by name
ind <- nso_data("DT_NSO_0500_007V1", period = tail(nso_table_periods("DT_NSO_0500_007V1"), 1), labels = "en")
j  <- mn_join_by_name(ind, name_col = "scr_eng1", level = "ADM1")
plot(j["value"])
```

## Vignettes

- Getting started: `vignettes/getting-started.Rmd`
- Mapping with sf: `vignettes/mapping.Rmd`
- Fuzzy joins: `vignettes/fuzzy-joins.Rmd`
- Code-based joins (new): `vignettes/code-joins.Rmd`

## Contributing

Issues and pull requests are welcome at:
- https://github.com/temuulene/mongolstats/issues

## License`n`nMIT © Temuulen Enebish`n
