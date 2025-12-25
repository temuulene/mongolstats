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
# Get aimag (province) boundaries
aimags <- mn_boundaries("ADM1")
head(aimags)
#> Simple feature collection with 6 features and 5 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 90.0023 ymin: 42.39561 xmax: 111.9678 ymax: 50.8851
#> Geodetic CRS:  WGS 84
#>     shapeName shapeISO                 shapeID shapeGroup shapeType
#> 1         Uvs   MN-046 14279143B81467460095364        MNG      ADM1
#> 2       Khovd   MN-043 14279143B22317554045022        MNG      ADM1
#> 3     Zavkhan   MN-057 14279143B63368554420497        MNG      ADM1
#> 4      Bulgan   MN-067 14279143B49613281560709        MNG      ADM1
#> 5   Dornogovi   MN-063 14279143B47638406449643        MNG      ADM1
#> 6 Ulaanbaatar     MN-1 14279143B69842940795179        MNG      ADM1
#>                         geometry
#> 1 MULTIPOLYGON (((95.50543 49...
#> 2 MULTIPOLYGON (((91.33829 48...
#> 3 MULTIPOLYGON (((93.4295 48....
#> 4 MULTIPOLYGON (((102.6428 50...
#> 5 MULTIPOLYGON (((107.6873 44...
#> 6 MULTIPOLYGON (((106.3564 48...
```
