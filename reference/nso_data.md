# Fetch statistical data for a table (PXWeb)

Fetch statistical data for a table (PXWeb)

## Usage

``` r
nso_data(
  tbl_id,
  selections,
  labels = c("none", "en", "mn", "both"),
  value_name = getOption("mongolstats.value_name", "value"),
  include_raw = getOption("mongolstats.attach_raw", FALSE)
)
```

## Arguments

- tbl_id:

  Table identifier (e.g., "DT_NSO_0300_001V2").

- selections:

  Named list mapping variable labels (e.g., Year, Sex) to desired codes
  or labels.

- labels:

  Label handling: "none" (codes only), "en", "mn", or "both".

- value_name:

  Name of the numeric value column in the result (default: "value").

- include_raw:

  If TRUE, attach the raw PX payload as attribute `px_raw`.

## Value

A tibble with one column per dimension and a numeric value column.

## Examples

``` r
# Fetch population data
pop <- nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(Year = "2023")
)
head(pop)
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
