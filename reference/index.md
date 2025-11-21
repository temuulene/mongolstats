# Package index

## Discover Tables

- [`nso_itms()`](https://temuulene.github.io/mongolstats/reference/nso_itms.md)
  [`nso_tables()`](https://temuulene.github.io/mongolstats/reference/nso_itms.md)
  : List available NSO tables (PXWeb)
- [`nso_itms_detail()`](https://temuulene.github.io/mongolstats/reference/nso_itms_detail.md)
  [`nso_variables()`](https://temuulene.github.io/mongolstats/reference/nso_itms_detail.md)
  : Get variable codes for a table (PXWeb)
- [`nso_table_meta()`](https://temuulene.github.io/mongolstats/reference/nso_table_meta.md)
  : Table metadata as per-dimension codebooks
- [`nso_dims()`](https://temuulene.github.io/mongolstats/reference/nso_dims.md)
  : List dimensions for a PXWeb table
- [`nso_dim_values()`](https://temuulene.github.io/mongolstats/reference/nso_dim_values.md)
  : List values for a table dimension
- [`nso_itms_search()`](https://temuulene.github.io/mongolstats/reference/nso_itms_search.md)
  : Search tables by keyword (PXWeb)
- [`nso_itms_by_sector()`](https://temuulene.github.io/mongolstats/reference/nso_itms_by_sector.md)
  : List tables under a sector or sub-sector (PXWeb path)
- [`nso_sectors()`](https://temuulene.github.io/mongolstats/reference/nso_sectors.md)
  : List top-level categories (PXWeb NSO root)
- [`nso_subsectors()`](https://temuulene.github.io/mongolstats/reference/nso_subsectors.md)
  : List children for a given path (PXWeb)

## Fetch Data

- [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md)
  : Fetch statistical data for a table (PXWeb)
- [`nso_package()`](https://temuulene.github.io/mongolstats/reference/nso_package.md)
  : Fetch multiple tables and bind (PXWeb)
- [`nso_search()`](https://temuulene.github.io/mongolstats/reference/nso_search.md)
  : Search NSO tables
- [`nso_query()`](https://temuulene.github.io/mongolstats/reference/nso_query.md)
  : Create a PXWeb query object
- [`as_px_query()`](https://temuulene.github.io/mongolstats/reference/as_px_query.md)
  : Convert a query to a PXWeb body
- [`nso_fetch()`](https://temuulene.github.io/mongolstats/reference/nso_fetch.md)
  : Fetch a query and return a tibble

## Boundaries and Joins

- [`mn_boundaries()`](https://temuulene.github.io/mongolstats/reference/mn_boundaries.md)
  : Mongolia administrative boundaries (sf)
- [`mn_boundary_keys()`](https://temuulene.github.io/mongolstats/reference/mn_boundary_keys.md)
  : Boundary keys/crosswalk helper
- [`mn_boundaries_normalize()`](https://temuulene.github.io/mongolstats/reference/mn_boundaries_normalize.md)
  : Add normalized name columns to boundaries
- [`mn_join_by_name()`](https://temuulene.github.io/mongolstats/reference/mn_join_by_name.md)
  : Join data to boundaries by (normalized) names
- [`mn_fuzzy_join_by_name()`](https://temuulene.github.io/mongolstats/reference/mn_fuzzy_join_by_name.md)
  : Fuzzy join data to boundaries by name

## Utilities

- [`nso_cache_enable()`](https://temuulene.github.io/mongolstats/reference/nso_cache_enable.md)
  : Enable or configure caching
- [`nso_cache_disable()`](https://temuulene.github.io/mongolstats/reference/nso_cache_disable.md)
  : Disable caching
- [`nso_cache_clear()`](https://temuulene.github.io/mongolstats/reference/nso_cache_clear.md)
  : Clear cached entries
- [`nso_cache_status()`](https://temuulene.github.io/mongolstats/reference/nso_cache_status.md)
  : Cache status
- [`nso_period_seq()`](https://temuulene.github.io/mongolstats/reference/nso_period_seq.md)
  : Create period codes
- [`nso_table_periods()`](https://temuulene.github.io/mongolstats/reference/nso_table_periods.md)
  : Get valid periods for a table (PXWeb)
- [`nso_options()`](https://temuulene.github.io/mongolstats/reference/nso_options.md)
  : Set or get mongolstats options
- [`nso_rebuild_px_index()`](https://temuulene.github.io/mongolstats/reference/nso_rebuild_px_index.md)
  : Rebuild PXWeb index and optionally write to a file
- [`nso_offline_enable()`](https://temuulene.github.io/mongolstats/reference/nso_offline_enable.md)
  : Enable offline mode
- [`nso_offline_disable()`](https://temuulene.github.io/mongolstats/reference/nso_offline_disable.md)
  : Disable offline mode
