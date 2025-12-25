# List values for a table dimension

Returns codes and optional labels for a specific dimension.

## Usage

``` r
nso_dim_values(tbl_id, dim, labels = c("code", "en", "mn", "both"))
```

## Arguments

- tbl_id:

  Table identifier (e.g., "DT_NSO_0300_001V2").

- dim:

  Dimension name or code (case-insensitive; exact match preferred).

- labels:

  One of "code", "en", "mn", or "both" to control returned label
  columns.

## Value

A tibble with at least `code`; may include `label_en` and/or `label_mn`.

## Examples

``` r
values <- nso_dim_values("DT_NSO_0300_001V2", "Year")
head(values)
#> # A tibble: 6 × 1
#>   code 
#>   <chr>
#> 1 0    
#> 2 1    
#> 3 2    
#> 4 3    
#> 5 4    
#> 6 5    
```
