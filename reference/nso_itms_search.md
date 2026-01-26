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
# Search for population tables
nso_itms_search("population")
#> # A tibble: 59 × 8
#>    px_path             px_file tbl_id tbl_eng_nm tbl_nm strt_prd end_prd list_id
#>    <chr>               <chr>   <chr>  <chr>      <chr>  <chr>    <chr>   <chr>  
#>  1 Education, health/… DT_NSO… DT_NS… NEW CASES… ХОРТ … 2024     2000    Educat…
#>  2 Education, health/… DT_NSO… DT_NS… NEW CASES… ХОРТ … 2024     2010    Educat…
#>  3 Education, health/… DT_NSO… DT_NS… INPATIENT… ЭМНЭЛ… 2024     2017    Educat…
#>  4 Historical data/Nu… DT_NSO… DT_NS… NUMBER OF… ХӨДӨЛ… 1992     1965    Histor…
#>  5 Historical data/Po… DT_NSO… DT_NS… POPULATIO… НИЙТ … 1992     1900    Histor…
#>  6 Historical data/Po… DT_NSO… DT_NS… NATURAL I… 1000 … 1992     1935    Histor…
#>  7 Historical data/Po… DT_NSO… DT_NS… SOCIAL ST… ХҮН А… 1992     1925    Histor…
#>  8 Historical data/Po… DT_NSO… DT_NS… MARRIAGES… 1000 … 1992     1970    Histor…
#>  9 Historical data/Po… DT_NSO… DT_NS… DIVORCES … 1000 … 1992     1970    Histor…
#> 10 Historical data/Po… DT_NSO… DT_NS… POPULATIO… ХҮН А… 1992     1950    Histor…
#> # ℹ 49 more rows
```
