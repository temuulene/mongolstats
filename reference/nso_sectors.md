# List top-level categories (PXWeb NSO root)

List top-level categories (PXWeb NSO root)

## Usage

``` r
nso_sectors()
```

## Value

tibble with `id`, `type`, `text`

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
