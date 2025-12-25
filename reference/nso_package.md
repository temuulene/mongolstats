# Fetch multiple tables and bind (PXWeb)

Fetch multiple tables and bind (PXWeb)

## Usage

``` r
nso_package(
  requests,
  labels = c("none", "en", "mn", "both"),
  parallel = getOption("mongolstats.parallel", FALSE),
  value_name = getOption("mongolstats.value_name", "value")
)
```

## Arguments

- requests:

  A list of records, each with `tbl_id` and `selections` (named list)

- labels:

  Label handling as in
  [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md)

- parallel:

  If TRUE, use future.apply to fetch tables in parallel.

- value_name:

  Name of the numeric value column in the result (default: "value").

## Value

A tibble combining data from all requested tables, with a `tbl_id`
column identifying the source table.
