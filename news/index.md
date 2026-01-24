# Changelog

## mongolstats 0.1.1

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
