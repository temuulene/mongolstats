# Table metadata as per-dimension codebooks

Returns a tibble with one row per dimension and a `codes` list-column,
where each element is a tibble of codes and labels (`code`, `label_en`,
`label_mn`). Useful for manual query assembly and for inspecting
available categories per dimension.

## Usage

``` r
nso_table_meta(tbl_id)
```

## Arguments

- tbl_id:

  Table identifier (e.g., "DT_NSO_0300_001V2").

## Value

A tibble with columns: `dim` (display name), `code` (dimension code),
`is_time` (logical), `n_values` (integer), and `codes` (list of
tibbles).
