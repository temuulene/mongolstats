# Get variable codes for a table (PXWeb)

Get variable codes for a table (PXWeb)

## Usage

``` r
nso_itms_detail(tbl_id)

nso_variables(tbl_id)
```

## Arguments

- tbl_id:

  Table identifier (e.g., "DT_NSO_0300_001V2").

## Value

A tibble with variable metadata.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get variables for population table
vars <- nso_itms_detail("DT_NSO_0300_001V2")
vars
} # }
```
