# Join data to boundaries by (normalized) names

Performs an exact join between a data frame and boundary polygons using
normalized place names. Both sides are normalized via transliteration
and lowercasing before joining.

## Usage

``` r
mn_join_by_name(data, name_col, level = "ADM1", boundaries = NULL)
```

## Arguments

- data:

  Data frame with a name column.

- name_col:

  Column in `data` that contains names to join on.

- level:

  Boundary level, passed to
  [`mn_boundaries()`](https://temuulene.github.io/mongolstats/reference/mn_boundaries.md)
  if `boundaries` not provided.

- boundaries:

  Optional pre-fetched boundaries.

## Value

An `sf` object with joined data.

## Examples

``` r
pop_data <- data.frame(aimag = c("Ulaanbaatar", "Darkhan-Uul"), pop = c(1500000, 100000))
sf_joined <- mn_join_by_name(pop_data, "aimag", level = "ADM1")
```
