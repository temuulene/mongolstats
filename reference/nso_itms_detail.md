# Get variable codes for a table (PXWeb)

Get variable codes for a table (PXWeb)

## Usage

``` r
nso_itms_detail(tbl_id)

nso_variables(tbl_id)
```

## Arguments

- tbl_id:

  Table identifier (e.g., "DT_NSO_0300_001V2").

## Value

A tibble with variable metadata.

## Examples

``` r
vars <- nso_itms_detail("DT_NSO_0300_001V2")
vars
#> # A tibble: 116 × 6
#>    field itm_id scr_eng scr_mn px_path                                   px_file
#>    <chr> <chr>  <chr>   <chr>  <chr>                                     <chr>  
#>  1 Sex   0      Total   NA     Population, household/1_Population, hous… DT_NSO…
#>  2 Sex   1      Male    NA     Population, household/1_Population, hous… DT_NSO…
#>  3 Sex   2      Female  NA     Population, household/1_Population, hous… DT_NSO…
#>  4 Age   0      Total   NA     Population, household/1_Population, hous… DT_NSO…
#>  5 Age   1      0       NA     Population, household/1_Population, hous… DT_NSO…
#>  6 Age   2      1       NA     Population, household/1_Population, hous… DT_NSO…
#>  7 Age   3      2       NA     Population, household/1_Population, hous… DT_NSO…
#>  8 Age   4      3       NA     Population, household/1_Population, hous… DT_NSO…
#>  9 Age   5      4       NA     Population, household/1_Population, hous… DT_NSO…
#> 10 Age   6      5       NA     Population, household/1_Population, hous… DT_NSO…
#> # ℹ 106 more rows
```
