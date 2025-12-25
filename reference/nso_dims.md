# List dimensions for a PXWeb table

Returns one row per dimension with basic metadata.

## Usage

``` r
nso_dims(tbl_id)
```

## Arguments

- tbl_id:

  Table identifier (e.g., "DT_NSO_0300_001V2").

## Value

A tibble with columns: `dim` (display name), `code` (dimension code),
`is_time` (logical), and `n_values` (number of values for the
dimension).

## Examples

``` r
dims <- nso_dims("DT_NSO_0300_001V2")
dims
#> # A tibble: 3 × 4
#>   dim   code  is_time n_values
#>   <chr> <chr> <lgl>      <int>
#> 1 Sex   Хүйс  FALSE          3
#> 2 Age   Нас   FALSE         88
#> 3 Year  Он    FALSE         25
```
