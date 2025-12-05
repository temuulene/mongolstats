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

## Examples

``` r
if (FALSE) { # \dontrun{
# Get aimag (province) boundaries
aimags <- mn_boundaries("ADM1")
plot(aimags["shapeName"])

# Get soum (district) boundaries
soums <- mn_boundaries("ADM2")
} # }
```
