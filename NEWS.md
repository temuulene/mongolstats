# mongolstats 0.1.0

First minor release with improved documentation, data quality fixes, and enhanced visualization.

## Data & Maps
- **Updated Infant Mortality Data**: Switched to monthly table `DT_NSO_2100_015V1` for more granular trend analysis and up-to-date regional comparisons (2024).
- **Map Improvements**: 
  - Fixed region name mismatches between NSO data and shapefiles (e.g., "Sukhbaatar" vs "Sükhbaatar").
  - Improved population map visualization with log scales and better color palettes.
  - Added `scale_x_date` to time series plots for correct year formatting.

## Documentation
- **Vignette Overhaul**:
  - Updated `getting-started`, `discovery`, and `mapping` vignettes with cleaner examples and better plots.
  - Added new "Tips for Epidemiological Research" section.
- **Package Cleanup**: Removed unused files and streamlined repository structure.
- **Logo**: Added new hex sticker.

# mongolstats 0.0.0.9000

Initial development snapshot.

- NSO API wrappers: `nso_itms()`, `nso_itms_detail()`, `nso_data()`, `nso_package()`
- Sector helpers: `nso_sectors()`, `nso_subsectors()`, `nso_search()`
- Boundaries: `mn_boundaries()`, join helpers incl. fuzzy joins
- Caching for discovery endpoints
- Vignettes for getting started, mapping, fuzzy joins, and code-based joins
