# Changelog

## mongolstats 0.1.0

First minor release with improved documentation, data quality fixes, and
enhanced visualization.

### Data & Maps

- **Updated Infant Mortality Data**: Switched to monthly table
  `DT_NSO_2100_015V1` for more granular trend analysis and up-to-date
  regional comparisons (2024).
- **Map Improvements**:
  - Fixed region name mismatches between NSO data and shapefiles (e.g.,
    “Sukhbaatar” vs “Sükhbaatar”).
  - Improved population map visualization with log scales and better
    color palettes.
  - Added `scale_x_date` to time series plots for correct year
    formatting.

### Documentation

- **Vignette Overhaul**:
  - Updated `getting-started`, `discovery`, and `mapping` vignettes with
    cleaner examples and better plots.
  - Added new “Tips for Epidemiological Research” section.
- **Package Cleanup**: Removed unused files and streamlined repository
  structure.
- **Logo**: Added new hex sticker.

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
