# Add normalized name columns to boundaries

Add normalized name columns to boundaries

## Usage

``` r
mn_boundaries_normalize(g, name_col = "shapeName")
```

## Arguments

- g:

  sf object from
  [`mn_boundaries()`](https://temuulene.github.io/mongolstats/reference/mn_boundaries.md)

- name_col:

  Column with English names (default 'shapeName').

## Value

sf with `name_std` column added.
