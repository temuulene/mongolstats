# Mongolia administrative boundaries (sf)

Downloads Mongolia boundaries for ADM0/ADM1/ADM2 from the GeoBoundaries
API and returns an `sf` object. Results can be cached by the caller as
needed.

## Usage

``` r
mn_boundaries(level = c("ADM0", "ADM1", "ADM2"))
```

## Arguments

- level:

  One of "ADM0", "ADM1", "ADM2".

## Value

An `sf` object with polygons for the requested level.
