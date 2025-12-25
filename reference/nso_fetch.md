# Fetch a query and return a tibble

Executes an `nso_query` and returns a tidy tibble with one column per
dimension and a numeric `value` column. Use `labels` to add `_en`/`_mn`
columns for each dimension.

## Usage

``` r
nso_fetch(
  x,
  labels = c("code", "en", "mn", "both"),
  value_name = getOption("mongolstats.value_name", "value"),
  include_raw = getOption("mongolstats.attach_raw", FALSE)
)
```

## Arguments

- x:

  An `nso_query` object.

- labels:

  One of "code", "en", "mn", or "both" (mapped to internal API).

- value_name:

  Name of the numeric value column in the result (default: "value").

- include_raw:

  If TRUE, attach the raw PX payload as attribute `px_raw`.

## Value

A tibble.

## Examples

``` r
q <- nso_query("DT_NSO_0300_001V2", list(Year = "2023"))
data <- nso_fetch(q)
head(data)
#> # A tibble: 6 × 4
#>   Sex   Age   Year    value
#>   <chr> <chr> <chr>   <dbl>
#> 1 0     0     1     3396788
#> 2 0     1     1       65418
#> 3 0     2     1       65653
#> 4 0     3     1       71885
#> 5 0     4     1       76194
#> 6 0     5     1       78627
```
