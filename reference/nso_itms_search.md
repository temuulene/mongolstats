# Search tables by keyword (PXWeb)

Search tables by keyword (PXWeb)

## Usage

``` r
nso_itms_search(query, fields = c("tbl_eng_nm", "tbl_nm"))
```

## Arguments

- query:

  A single keyword string to search for (case-insensitive).

- fields:

  Character vector of column names to search within (defaults to English
  and Mongolian titles).

## Value

A tibble of matching tables.

## Examples

``` r
if (FALSE) { # \dontrun{
# Search for infant mortality tables
nso_itms_search("infant mortality")

# Search for GDP tables
nso_itms_search("GDP")
} # }
```
