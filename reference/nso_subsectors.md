# List children for a given path (PXWeb)

List children for a given path (PXWeb)

## Usage

``` r
nso_subsectors(subid)
```

## Arguments

- subid:

  Path id from
  [`nso_sectors()`](https://temuulene.github.io/mongolstats/reference/nso_sectors.md)/`nso_subsectors()`
  (e.g., 'Population, household' or 'Population, household/1_Population,
  household')

## Value

A tibble with columns: `id`, `type`, `text`.

## Examples

``` r
sectors <- nso_sectors()
nso_subsectors(sectors$id[1])
#> # A tibble: 12 × 3
#>    id                             type  text                          
#>    <chr>                          <chr> <chr>                         
#>  1 Balance of Payments            l     Balance of Payments           
#>  2 Consumer Price Index           l     Consumer Price Index          
#>  3 Environment                    l     Environment                   
#>  4 Environmental-Economic Account l     Environmental-Economic Account
#>  5 Foreign Trade                  l     Foreign Trade                 
#>  6 Government budget              l     Government budget             
#>  7 Housing price index            l     Housing price index           
#>  8 Investment                     l     Investment                    
#>  9 Money and Finance              l     Money and Finance             
#> 10 National Accounts              l     National Accounts             
#> 11 Producer price index           l     Producer price index          
#> 12 Productivity                   l     Productivity                  
```
