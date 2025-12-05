# List available NSO tables (PXWeb)

Returns a tibble of all available tables in the NSO PXWeb catalog.

## Usage

``` r
nso_itms()

nso_tables()
```

## Value

A tibble with columns: `px_path`, `px_file`, `tbl_id`, `tbl_eng_nm`,
`tbl_nm`, `strt_prd`, `end_prd`, `list_id`.

## Examples

``` r
if (FALSE) { # \dontrun{
# List all available tables
tables <- nso_itms()
head(tables)

# Filter to find specific tables
tables |> dplyr::filter(grepl("population", tbl_eng_nm, ignore.case = TRUE))
} # }
```
