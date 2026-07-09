# Boundary keys/crosswalk helper

Returns a lightweight tibble of key columns from the GeoBoundaries data,
including normalized names, without the full geometry. Useful for
building custom crosswalks between NSO data and boundary identifiers.

## Usage

``` r
mn_boundary_keys(level = "ADM1")
```

## Arguments

- level:

  Boundary level.

## Value

A tibble with key columns from GeoBoundaries and normalized names.

## Examples

``` r
keys <- mn_boundary_keys("ADM1")
head(keys)
#> # A tibble: 6 × 4
#>   shapeID                 shapeName   shapeISO name_std   
#>   <chr>                   <chr>       <chr>    <chr>      
#> 1 14279143B81467460095364 Uvs         MN-046   uvs        
#> 2 14279143B22317554045022 Khovd       MN-043   khovd      
#> 3 14279143B63368554420497 Zavkhan     MN-057   zavkhan    
#> 4 14279143B49613281560709 Bulgan      MN-067   bulgan     
#> 5 14279143B47638406449643 Dornogovi   MN-063   dornogovi  
#> 6 14279143B69842940795179 Ulaanbaatar MN-1     ulaanbaatar
```
