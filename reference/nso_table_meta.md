# Table metadata as per-dimension codebooks

Returns a tibble with one row per dimension and a `codes` list-column,
where each element is a tibble of codes and labels (`code`, `label_en`,
`label_mn`). Useful for manual query assembly and for inspecting
available categories per dimension.

## Usage

``` r
nso_table_meta(tbl_id)
```

## Arguments

- tbl_id:

  Table identifier (e.g., "DT_NSO_0300_001V2").

## Value

A tibble with columns: `dim` (display name), `code` (dimension code),
`is_time` (logical), `n_values` (integer), and `codes` (list of
tibbles).

## Examples

``` r
meta <- nso_table_meta("DT_NSO_0300_001V2")
meta
#> # A tibble: 3 × 5
#>   dim   code  is_time n_values codes            
#>   <chr> <chr> <lgl>      <int> <list>           
#> 1 Sex   Хүйс  FALSE          3 <tibble [3 × 3]> 
#> 2 Age   Нас   FALSE         88 <tibble [88 × 3]>
#> 3 Year  Он    FALSE         25 <tibble [25 × 3]>
```
