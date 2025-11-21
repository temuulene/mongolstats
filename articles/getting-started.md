# Getting started with mongolstats

``` r
library(mongolstats)
library(dplyr)

# Point to new PXWeb API (default set on load)
nso_options(mongolstats.lang = "en")
```

## Overview

This vignette introduces the core workflow for using mongolstats:

- Discover tables and explore their variables (codebooks)
- Fetch data by selecting values for each table dimension
- Optionally enrich with English/Mongolian labels for readability
- Work with period utilities for time series

We’ll keep examples small for clarity; see the other vignettes for
discovery, periods, mapping, and batch workflows.

## List tables

``` r
itms <- nso_itms()
itms %>% dplyr::select(dplyr::any_of(c("tbl_id", "tbl_eng_nm", "strt_prd", "end_prd"))) %>% dplyr::slice_head(n = 5)
```

    ## # A tibble: 5 × 4
    ##   tbl_id             tbl_eng_nm                                 strt_prd end_prd
    ##   <chr>              <chr>                                      <chr>    <chr>  
    ## 1 DT_NSO_0100_001V10 BALANCE OF PAYMENTS, by month              NA       NA     
    ## 2 DT_NSO_0300_010V5  WEEKLY PRICES OF MAIN PRODUCTS AND GASOLI… 2025-11… 2024-0…
    ## 3 DT_NSO_0303_07V7   CONSUMER PRICE INDEX IN AIMAGS, compared … 2015=100 2023=1…
    ## 4 DT_NSO_0303_07V8   CONSUMER PRICE INDEX IN AIMAGS, compared … 2015=100 2023=1…
    ## 5 DT_NSO_0303_07V9   CONSUMER PRICE INDEX IN AIMAGS, compared … 2015=100 2023=1…

## Explore variables (codebook)

``` r
vars <- nso_variables("DT_NSO_0300_001V2")
vars %>% dplyr::count(field)
```

    ## # A tibble: 3 × 2
    ##   field     n
    ##   <chr> <int>
    ## 1 Age      88
    ## 2 Sex       3
    ## 3 Year     25

``` r
vars %>% dplyr::filter(field %in% c("Sex","Age","Year")) %>% dplyr::slice_head(n = 10)
```

    ## # A tibble: 10 × 6
    ##    field itm_id scr_eng scr_mn px_path                                   px_file
    ##    <chr> <chr>  <chr>   <chr>  <chr>                                     <chr>  
    ##  1 Sex   0      Total   NA     Population, household/1_Population, hous… DT_NSO…
    ##  2 Sex   1      Male    NA     Population, household/1_Population, hous… DT_NSO…
    ##  3 Sex   2      Female  NA     Population, household/1_Population, hous… DT_NSO…
    ##  4 Age   0      Total   NA     Population, household/1_Population, hous… DT_NSO…
    ##  5 Age   1      0       NA     Population, household/1_Population, hous… DT_NSO…
    ##  6 Age   2      1       NA     Population, household/1_Population, hous… DT_NSO…
    ##  7 Age   3      2       NA     Population, household/1_Population, hous… DT_NSO…
    ##  8 Age   4      3       NA     Population, household/1_Population, hous… DT_NSO…
    ##  9 Age   5      4       NA     Population, household/1_Population, hous… DT_NSO…
    ## 10 Age   6      5       NA     Population, household/1_Population, hous… DT_NSO…

Notes

- Each PXWeb table has one or more dimensions (e.g., Year, Sex, Age).
  Use their labels to select values.
- You can pass values as codes or labels; mongolstats maps labels to
  codes under the hood for you.

## Fetch data

``` r
per <- tryCatch(tail(nso_table_periods("DT_NSO_0300_001V2"), 1), error = function(e) "")
yr <- if (length(per) && nzchar(per[1])) per else "2022"
dat <- nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(Sex = "Total", Age = "Total", Year = yr)
)

dat %>% dplyr::slice_head(n = 6)
```

    ## # A tibble: 1 × 4
    ##   Sex   Age   Year    value
    ##   <chr> <chr> <chr>   <dbl>
    ## 1 0     0     24    2374617

## Selecting by label vs code

You can also select using dimension codes. For this table, `Sex` has
codes `0` (Total), `1` (Male), `2` (Female). Both of the following are
equivalent:

``` r
yr <- tryCatch(tail(nso_table_periods("DT_NSO_0300_001V2"), 1), error = function(e) "2022")
dat_lbl <- nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(Sex = "Total", Age = "Total", Year = yr)
)

dat_code <- nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(Sex = "0", Age = "0", Year = yr)
)

list(rows_label = nrow(dat_lbl), rows_code = nrow(dat_code))
```

    ## $rows_label
    ## [1] 1
    ## 
    ## $rows_code
    ## [1] 1

## Adding labels to the result

Use the `labels` argument to add readable columns for each dimension:

``` r
per <- tryCatch(nso_table_periods("DT_NSO_0300_001V2"), error = function(e) character())
yrs <- if (length(per) >= 2) tail(per, 2) else per
if (!length(yrs)) yrs <- c("2021","2022")
dat_labeled <- nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(Sex = c("Male","Female"), Age = "Total", Year = yrs),
  labels = "en"
)

dat_labeled %>% dplyr::select(dplyr::any_of(c("Year","Sex","value","Year_en","Sex_en"))) %>% dplyr::slice_head(n = 8)
```

    ## # A tibble: 4 × 5
    ##   Year  Sex     value Year_en Sex_en
    ##   <chr> <chr>   <dbl> <chr>   <chr> 
    ## 1 23    1     1176858 2001    Male  
    ## 2 24    1     1166478 2000    Male  
    ## 3 23    2     1221849 2001    Female
    ## 4 24    2     1208139 2000    Female

## Working with periods

Use helpers to discover valid periods for a table and build sequences:

``` r
periods <- nso_table_periods("DT_NSO_0300_001V2")
head(periods); tail(periods)
```

    ## [1] "2024" "2023" "2022" "2021" "2020" "2019"

    ## [1] "2005" "2004" "2003" "2002" "2001" "2000"

``` r
# Yearly sequence helper
nso_period_seq("2018","2022", by = "Y")
```

    ## [1] "2018" "2019" "2020" "2021" "2022"

## Summaries

With dplyr, it’s straightforward to summarise values by year or
category:

``` r
per <- tryCatch(nso_table_periods("DT_NSO_0300_001V2"), error = function(e) character())
yrs <- if (length(per) >= 5) tail(per, 5) else per
if (!length(yrs)) yrs <- c("2018","2019","2020","2021","2022")
dat_year <- nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(Sex = "Total", Age = "Total", Year = yrs)
)

dat_year %>%
  dplyr::group_by(Year) %>%
  dplyr::summarise(value = sum(value, na.rm = TRUE)) %>%
  dplyr::arrange(Year) %>%
  dplyr::slice_head(n = 10)
```

    ## # A tibble: 5 × 2
    ##   Year    value
    ##   <chr>   <dbl>
    ## 1 20    2474438
    ## 2 21    2450790
    ## 3 22    2425999
    ## 4 23    2398707
    ## 5 24    2374617
