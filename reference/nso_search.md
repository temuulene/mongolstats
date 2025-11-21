# Search NSO tables

Search NSO tables

## Usage

``` r
nso_search(query, sector = NULL, fields = c("tbl_eng_nm", "tbl_nm"))
```

## Arguments

- query:

  Search string (regex, case-insensitive).

- sector:

  Optional sector/subsector `list_id` to filter results.

- fields:

  Character vector of fields to search within.

## Value

Tibble of matching tables.
