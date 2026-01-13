# Rebuild PXWeb index and optionally write to a file

Crawls the PXWeb API to rebuild the table index. If `path` is provided,
the index is written to that file; otherwise only the in-memory index is
refreshed.

## Usage

``` r
nso_rebuild_px_index(path = NULL, write = !is.null(path))
```

## Arguments

- path:

  Output path for JSON. If `NULL` (default), no file is written. For
  package development, use `"inst/extdata/px_index.json"`.

- write:

  Whether to write JSON to `path`. Defaults to `TRUE` if `path` is
  provided, `FALSE` otherwise.

## Value

A tibble containing the rebuilt table index.

## Examples

``` r
# Rebuild in-memory index only (takes time to crawl API)
# \donttest{
idx <- nso_rebuild_px_index()
head(idx)
#> # A tibble: 6 × 7
#>   px_path                      px_file tbl_id tbl_eng_nm tbl_nm strt_prd end_prd
#>   <chr>                        <chr>   <chr>  <chr>      <chr>  <chr>    <chr>  
#> 1 Economy, environment/Balanc… DT_NSO… DT_NS… BALANCE O… ТӨЛБӨ… NA       NA     
#> 2 Economy, environment/Consum… DT_NSO… DT_NS… WEEKLY PR… ХҮНСН… 2026-01… 2024-0…
#> 3 Economy, environment/Consum… DT_NSO… DT_NS… CONSUMER … АЙМГИ… 2015=100 2023=1…
#> 4 Economy, environment/Consum… DT_NSO… DT_NS… CONSUMER … АЙМГИ… 2015=100 2023=1…
#> 5 Economy, environment/Consum… DT_NSO… DT_NS… CONSUMER … АЙМГИ… 2015=100 2023=1…
#> 6 Economy, environment/Consum… DT_NSO… DT_NS… NATIONAL … ХЭРЭГ… 2015=100 2023=1…
# }
```
