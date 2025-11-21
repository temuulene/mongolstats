# Discovering tables and variables

``` r
library(mongolstats)
library(dplyr)
nso_options(mongolstats.lang = "en")
```

## Discovery overview

PXWeb exposes a tree of folders (sectors/subsectors) containing tables.
Discovery functions help you:

- Navigate the catalog with
  [`nso_sectors()`](https://temuulene.github.io/mongolstats/reference/nso_sectors.md)
  and
  [`nso_subsectors()`](https://temuulene.github.io/mongolstats/reference/nso_subsectors.md)
- List available tables with
  [`nso_itms()`](https://temuulene.github.io/mongolstats/reference/nso_itms.md)
- Search by keyword with
  [`nso_itms_search()`](https://temuulene.github.io/mongolstats/reference/nso_itms_search.md)
  /
  [`nso_search()`](https://temuulene.github.io/mongolstats/reference/nso_search.md)
- Explore a table’s variables using
  [`nso_variables()`](https://temuulene.github.io/mongolstats/reference/nso_itms_detail.md)

## List available tables

``` r
itms <- nso_itms()
itms %>% dplyr::select(tbl_id, tbl_eng_nm, strt_prd, end_prd) %>% dplyr::slice_head(n = 10)
```

    ## # A tibble: 10 × 4
    ##    tbl_id             tbl_eng_nm                                strt_prd end_prd
    ##    <chr>              <chr>                                     <chr>    <chr>  
    ##  1 DT_NSO_0100_001V10 BALANCE OF PAYMENTS, by month             NA       NA     
    ##  2 DT_NSO_0300_010V5  WEEKLY PRICES OF MAIN PRODUCTS AND GASOL… 2025-11… 2024-0…
    ##  3 DT_NSO_0303_07V7   CONSUMER PRICE INDEX IN AIMAGS, compared… 2015=100 2023=1…
    ##  4 DT_NSO_0303_07V8   CONSUMER PRICE INDEX IN AIMAGS, compared… 2015=100 2023=1…
    ##  5 DT_NSO_0303_07V9   CONSUMER PRICE INDEX IN AIMAGS, compared… 2015=100 2023=1…
    ##  6 DT_NSO_0600_001V3  NATIONAL BASE CONSUMER PRICE INDEX, by g… 2015=100 2023=1…
    ##  7 DT_NSO_0600_001V4  WEEKLY PRICES OF MAIN PRODUCTS AND GASOL… 2025-11… 2021-0…
    ##  8 DT_NSO_0600_002V1  NATIONAL CONSUMER PRICE INDEX, 1991-1-16… 2024     1991   
    ##  9 DT_NSO_0600_002V21 CONSUMER PRICE INDEX, by group, compared… 2015=100 2023=1…
    ## 10 DT_NSO_0600_002V22 CONSUMER PRICE INDEX, by group, compared… 2015=100 2023=1…

## Navigate sectors

Top-level categories (folder-like nodes):

``` r
root <- nso_sectors()
root %>% dplyr::slice_head(n = 10)
```

    ## # A tibble: 8 × 3
    ##   id                    type  text                 
    ##   <chr>                 <chr> <chr>                
    ## 1 Economy, environment  l     Economy, environment 
    ## 2 Education, health     l     Education, health    
    ## 3 Historical data       l     Historical data      
    ## 4 Industry, service     l     Industry, service    
    ## 5 Labour, business      l     Labour, business     
    ## 6 Population, household l     Population, household
    ## 7 Regional development  l     Regional development 
    ## 8 Society, development  l     Society, development

Children under a category (pass `id` from above):

``` r
first_id <- if (nrow(root)) root$id[1] else ""
kids <- nso_subsectors(first_id)
kids %>% dplyr::slice_head(n = 10)
```

    ## # A tibble: 10 × 3
    ##    id                             type  text                          
    ##    <chr>                          <chr> <chr>                         
    ##  1 Balance of Payments            l     Balance of Payments           
    ##  2 Consumer Price Index           l     Consumer Price Index          
    ##  3 Environment                    l     Environment                   
    ##  4 Environmental-Economic Account l     Environmental-Economic Account
    ##  5 Foreign Trade                  l     Foreign Trade                 
    ##  6 Government budget              l     Government budget             
    ##  7 Housing price index            l     Housing price index           
    ##  8 Investment                     l     Investment                    
    ##  9 Money and Finance              l     Money and Finance             
    ## 10 National Accounts              l     National Accounts

## Search by keyword

``` r
pop <- nso_itms_search("population")
pop %>% dplyr::select(tbl_id, tbl_eng_nm) %>% dplyr::slice_head(n = 10)
```

    ## # A tibble: 0 × 2
    ## # ℹ 2 variables: tbl_id <chr>, tbl_eng_nm <chr>

## Explore variables (codebook) for a table

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
vars %>% dplyr::slice_head(n = 10)
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

Tips

- Use `field` to identify the dimension names you’ll pass in
  `selections` when fetching data.
- Each `field` has codes (`itm_id`) and English/Mongolian labels
  (`scr_eng`/`scr_mn`).
