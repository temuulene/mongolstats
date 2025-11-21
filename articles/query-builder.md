# Query builder: dims → query → fetch

``` r
library(mongolstats)
library(dplyr)
nso_options(mongolstats.lang = "en")
```

## Inspect dimensions

Use
[`nso_dims()`](https://temuulene.github.io/mongolstats/reference/nso_dims.md)
to list table dimensions and
[`nso_dim_values()`](https://temuulene.github.io/mongolstats/reference/nso_dim_values.md)
to inspect codes/labels for a dimension.

``` r
dims <- tryCatch(nso_dims("DT_NSO_0300_001V2"), error = function(e) tibble::tibble())
dims
```

    ## # A tibble: 3 × 4
    ##   dim   code  is_time n_values
    ##   <chr> <chr> <lgl>      <int>
    ## 1 Sex   Хүйс  FALSE          3
    ## 2 Age   Нас   FALSE         88
    ## 3 Year  Он    FALSE         25

``` r
tryCatch(nso_dim_values("DT_NSO_0300_001V2", "Year", labels = "en") %>% slice_head(n = 6), error = function(e) tibble::tibble())
```

    ## # A tibble: 6 × 2
    ##   code  label_en
    ##   <chr> <chr>   
    ## 1 0     2024    
    ## 2 1     2023    
    ## 3 2     2022    
    ## 4 3     2021    
    ## 5 4     2020    
    ## 6 5     2019

## Build a query

Construct a query with readable selections (codes or labels). Print
shows a compact summary.

``` r
yr <- tryCatch(tail(nso_table_periods("DT_NSO_0300_001V2"), 1), error = function(e) "2022")
q <- nso_query(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(Year = yr, Sex = c("Male","Female"), Age = "Total")
)
q
```

    ## $tbl_id
    ## [1] "DT_NSO_0300_001V2"
    ## 
    ## $selections
    ## $selections$Year
    ## [1] "2000"
    ## 
    ## $selections$Sex
    ## [1] "Male"   "Female"
    ## 
    ## $selections$Age
    ## [1] "Total"
    ## 
    ## 
    ## attr(,"class")
    ## [1] "nso_query"

## Execute the query

Use
[`nso_fetch()`](https://temuulene.github.io/mongolstats/reference/nso_fetch.md)
to run the query. Add labels for readability when needed.

``` r
dat <- tryCatch(nso_fetch(q, labels = "en"), error = function(e) tibble::tibble())
dat %>% select(dplyr::any_of(c("Year","Sex","Age","value","Year_en","Sex_en"))) %>% slice_head(n = 8)
```

    ## # A tibble: 2 × 6
    ##   Year  Sex   Age     value Year_en Sex_en
    ##   <chr> <chr> <chr>   <dbl> <chr>   <chr> 
    ## 1 24    1     0     1166478 2000    Male  
    ## 2 24    2     0     1208139 2000    Female

## Tips

- Use `nso_dim_values(tbl, dim, labels = 'en')` to discover valid
  values.
- Selections accept codes or labels; mongolstats maps labels to codes.
- Enable caching for faster iteration:
  [`nso_cache_enable()`](https://temuulene.github.io/mongolstats/reference/nso_cache_enable.md).
