# List top-level categories (PXWeb NSO root)

Queries the PXWeb API root to return the top-level statistical sectors
(e.g., Population, Economy, Environment). Use the returned `id` column
with
[`nso_subsectors()`](https://temuulene.github.io/mongolstats/reference/nso_subsectors.md)
to drill into sub-categories.

## Usage

``` r
nso_sectors()
```

## Value

A tibble with columns `id`, `type`, and `text`.

## Examples

``` r
sectors <- nso_sectors()
head(sectors)
#> # A tibble: 6 × 3
#>   id                    type  text                 
#>   <chr>                 <chr> <chr>                
#> 1 Economy, environment  l     Economy, environment 
#> 2 Education, health     l     Education, health    
#> 3 Historical data       l     Historical data      
#> 4 Industry, service     l     Industry, service    
#> 5 Labour, business      l     Labour, business     
#> 6 Population, household l     Population, household
```
