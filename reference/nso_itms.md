# List available NSO tables (PXWeb)

Retrieves the full catalogue of available statistical tables from the
National Statistics Office PXWeb API. Uses the embedded index by default
for fast startup; call
[`nso_rebuild_px_index()`](https://temuulene.github.io/mongolstats/reference/nso_rebuild_px_index.md)
to refresh from the API.

## Usage

``` r
nso_itms()

nso_tables()
```

## Value

A tibble with columns: `px_path`, `px_file`, `tbl_id`, `tbl_eng_nm`,
`tbl_nm`, `strt_prd`, `end_prd`, `list_id`.

## Examples

``` r
# List all available tables
tables <- nso_itms()
head(tables)
#> # A tibble: 6 × 8
#>   px_path              px_file tbl_id tbl_eng_nm tbl_nm strt_prd end_prd list_id
#>   <chr>                <chr>   <chr>  <chr>      <chr>  <chr>    <chr>   <chr>  
#> 1 Economy, environmen… DT_NSO… DT_NS… BALANCE O… ТӨЛБӨ… NA       NA      Econom…
#> 2 Economy, environmen… DT_NSO… DT_NS… BALANCE O… ТӨЛБӨ… NA       NA      Econom…
#> 3 Economy, environmen… DT_NSO… DT_NS… BALANCE O… ТӨЛБӨ… 2025     2009    Econom…
#> 4 Economy, environmen… DT_NSO… DT_NS… WEEKLY PR… ХҮНСН… 2026-07… 2024-0… Econom…
#> 5 Economy, environmen… DT_NSO… DT_NS… CONSUMER … АЙМГИ… 2015=100 2023=1… Econom…
#> 6 Economy, environmen… DT_NSO… DT_NS… CONSUMER … АЙМГИ… 2015=100 2023=1… Econom…
```
