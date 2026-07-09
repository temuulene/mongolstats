# Add normalized name columns to boundaries

Adds a `name_std` column to an `sf` boundary object by transliterating,
lowercasing, and stripping special characters from place names. This
enables reliable joins between NSO data and administrative boundary
polygons.

## Usage

``` r
mn_boundaries_normalize(g, name_col = "shapeName")
```

## Arguments

- g:

  sf object from
  [`mn_boundaries()`](https://temuulene.github.io/mongolstats/reference/mn_boundaries.md).

- name_col:

  Column with English names (default 'shapeName').

## Value

An `sf` object with an additional `name_std` column.

## Examples

``` r
aimags <- mn_boundaries("ADM1")
aimags <- mn_boundaries_normalize(aimags)
head(aimags$name_std)
#> [1] "uvs"         "khovd"       "zavkhan"     "bulgan"      "dornogovi"  
#> [6] "ulaanbaatar"
```
