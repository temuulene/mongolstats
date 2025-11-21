# Join data to boundaries by (normalized) names

Join data to boundaries by (normalized) names

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

sf with joined data.
