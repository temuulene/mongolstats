# Fetch multiple tables and bind (PXWeb)

Fetch multiple tables and bind (PXWeb)

## Usage

``` r
nso_package(
  requests,
  labels = c("none", "en", "mn", "both"),
  parallel = getOption("mongolstats.parallel", FALSE),
  value_name = getOption("mongolstats.value_name", "value"),
  strict = FALSE
)
```

## Arguments

- requests:

  A list of records, each with `tbl_id` and `selections` (named list)

- labels:

  Label handling as in
  [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md)

- parallel:

  If TRUE, use future.apply to fetch tables in parallel. Defaults to the
  `mongolstats.parallel` option (`FALSE`).

- value_name:

  Name of the numeric value column in the result (default: "value").

- strict:

  If TRUE, error when any table fails to fetch. If FALSE (default),
  failed tables are dropped from the result with a warning naming them.

## Value

A tibble combining data from all requested tables, with a `tbl_id`
column identifying the source table. Tables that failed to fetch are
omitted (with a warning) unless `strict = TRUE`.

## Examples

``` r
reqs <- list(
  list(tbl_id = "DT_NSO_0300_001V2", selections = list(Year = "2023"))
)
combined <- nso_package(reqs)
```
