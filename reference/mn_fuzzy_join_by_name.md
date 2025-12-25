# Fuzzy join data to boundaries by name

Fuzzy join data to boundaries by name

## Usage

``` r
mn_fuzzy_join_by_name(
  data,
  name_col,
  level = "ADM1",
  boundaries = NULL,
  max_distance = 2,
  method = c("osa", "lv", "jw", "dl")
)
```

## Arguments

- data:

  Data frame with a name column.

- name_col:

  Column in `data` containing names.

- level:

  Boundary level.

- boundaries:

  Optional pre-fetched boundaries.

- max_distance:

  Maximum string distance for a match (default 2).

- method:

  Distance method passed to
  [`stringdist::stringdist`](https://rdrr.io/pkg/stringdist/man/stringdist.html).

## Value

sf with best fuzzy matches joined.

## Examples

``` r
# Join even with minor spelling differences
pop_data <- data.frame(aimag = c("Ulanbatar", "Darhan"), pop = c(1500000, 100000))
sf_joined <- mn_fuzzy_join_by_name(pop_data, "aimag", level = "ADM1")
```
