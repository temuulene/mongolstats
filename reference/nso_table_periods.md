# Get valid periods for a table (PXWeb)

Get valid periods for a table (PXWeb)

## Usage

``` r
nso_table_periods(tbl_id)
```

## Arguments

- tbl_id:

  Table identifier.

## Value

Character vector of period labels (e.g., years)

## Examples

``` r
periods <- nso_table_periods("DT_NSO_0300_001V2")
head(periods)
#> [1] "2024" "2023" "2022" "2021" "2020" "2019"
```
