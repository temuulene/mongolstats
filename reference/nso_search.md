# Search NSO tables

Performs a case-insensitive regex search across the table catalogue,
optionally filtered to a specific sector. Searches table names in
English and/or Mongolian by default. For a literal keyword search use
[`nso_itms_search()`](https://temuulene.github.io/mongolstats/reference/nso_itms_search.md).

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

## Examples

``` r
nso_search("population")
#> # A tibble: 64 × 8
#>    px_path             px_file tbl_id tbl_eng_nm tbl_nm strt_prd end_prd list_id
#>    <chr>               <chr>   <chr>  <chr>      <chr>  <chr>    <chr>   <chr>  
#>  1 Education, health/… DT_NSO… DT_NS… NEW CASES… ХОРТ … 2025     2000    Educat…
#>  2 Education, health/… DT_NSO… DT_NS… DEATHS OF… ХОРТ … 2025     1990    Educat…
#>  3 Education, health/… DT_NSO… DT_NS… NEW CASES… ХОРТ … 2025     2010    Educat…
#>  4 Education, health/… DT_NSO… DT_NS… INPATIENT… ЭМНЭЛ… 2025     2017    Educat…
#>  5 Historical data/Nu… DT_NSO… DT_NS… NUMBER OF… ХӨДӨЛ… 1992     1965    Histor…
#>  6 Historical data/Po… DT_NSO… DT_NS… POPULATIO… НИЙТ … 1992     1900    Histor…
#>  7 Historical data/Po… DT_NSO… DT_NS… NATURAL I… 1000 … 1992     1935    Histor…
#>  8 Historical data/Po… DT_NSO… DT_NS… SOCIAL ST… ХҮН А… 1992     1925    Histor…
#>  9 Historical data/Po… DT_NSO… DT_NS… MARRIAGES… 1000 … 1992     1970    Histor…
#> 10 Historical data/Po… DT_NSO… DT_NS… DIVORCES … 1000 … 1992     1970    Histor…
#> # ℹ 54 more rows
```
