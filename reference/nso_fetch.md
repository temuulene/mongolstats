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
