# List dimensions for a PXWeb table

Returns one row per dimension with basic metadata.

## Usage

``` r
nso_dims(tbl_id)
```

## Arguments

- tbl_id:

  Table identifier (e.g., "DT_NSO_0300_001V2").

## Value

A tibble with columns: `dim` (display name), `code` (dimension code),
`is_time` (logical), and `n_values` (number of values for the
dimension).
