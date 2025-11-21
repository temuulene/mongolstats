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
