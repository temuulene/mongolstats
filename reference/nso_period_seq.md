# Create period codes

Utilities to construct NSO period codes and sequences. For monthly data,
use YYYYMM; for yearly, use YYYY.

## Usage

``` r
nso_period_seq(start, end, by = c("Y", "M"))
```

## Arguments

- start, end:

  Start and end periods as character (YYYY or YYYYMM).

- by:

  'Y' for yearly or 'M' for monthly.

## Value

Character vector of period codes.

## Examples

``` r
# Generate yearly sequence
nso_period_seq("2020", "2024", by = "Y")
#> [1] "2020" "2021" "2022" "2023" "2024"

# Generate monthly sequence
nso_period_seq("202401", "202406", by = "M")
#> [1] "202401" "202402" "202403" "202404" "202405" "202406"
```
