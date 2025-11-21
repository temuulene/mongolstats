# Batch fetching workflows

``` r
library(mongolstats)
library(dplyr)
```

## Create batch requests

``` r
reqs <- list(
  list(tbl_id = "DT_NSO_0300_001V2", selections = list(Sex = "Total", Age = "Total", Year = "2024")),
  list(tbl_id = "DT_NSO_0300_004V5", selections = list(Year = "2024"))
)
reqs
```

    ## [[1]]
    ## [[1]]$tbl_id
    ## [1] "DT_NSO_0300_001V2"
    ## 
    ## [[1]]$selections
    ## [[1]]$selections$Sex
    ## [1] "Total"
    ## 
    ## [[1]]$selections$Age
    ## [1] "Total"
    ## 
    ## [[1]]$selections$Year
    ## [1] "2024"
    ## 
    ## 
    ## 
    ## [[2]]
    ## [[2]]$tbl_id
    ## [1] "DT_NSO_0300_004V5"
    ## 
    ## [[2]]$selections
    ## [[2]]$selections$Year
    ## [1] "2024"

## Fetch multiple tables at once

``` r
pkg <- nso_package(reqs, labels = "en")
pkg %>% dplyr::slice_head(n = 10)
```

    ## # A tibble: 10 × 12
    ##    Sex   Age   Year    value tbl_id        Sex_en Age_en Year_en Region Location
    ##    <chr> <chr> <chr>   <dbl> <chr>         <chr>  <chr>  <chr>   <chr>  <chr>   
    ##  1 0     0     0     3441598 DT_NSO_0300_… Total  Total  2024    NA     NA      
    ##  2 NA    NA    0     3441598 DT_NSO_0300_… NA     NA     2024    0      0       
    ##  3 NA    NA    0     2420582 DT_NSO_0300_… NA     NA     2024    0      1       
    ##  4 NA    NA    0     1021016 DT_NSO_0300_… NA     NA     2024    0      2       
    ##  5 NA    NA    0      415576 DT_NSO_0300_… NA     NA     2024    1      0       
    ##  6 NA    NA    0      145420 DT_NSO_0300_… NA     NA     2024    1      1       
    ##  7 NA    NA    0      270156 DT_NSO_0300_… NA     NA     2024    1      2       
    ##  8 NA    NA    0      110799 DT_NSO_0300_… NA     NA     2024    183    0       
    ##  9 NA    NA    0       43749 DT_NSO_0300_… NA     NA     2024    183    1       
    ## 10 NA    NA    0       67050 DT_NSO_0300_… NA     NA     2024    183    2       
    ## # ℹ 2 more variables: Region_en <chr>, Location_en <chr>

## Compare results across tables

When the batch includes different tables,
[`nso_package()`](https://temuulene.github.io/mongolstats/reference/nso_package.md)
adds a `tbl_id` column, enabling grouped summaries:

``` r
pkg %>%
  dplyr::group_by(tbl_id) %>%
  dplyr::summarise(total = sum(value, na.rm = TRUE), n = dplyr::n())
```

    ## # A tibble: 2 × 3
    ##   tbl_id               total     n
    ##   <chr>                <dbl> <int>
    ## 1 DT_NSO_0300_001V2  3441598     1
    ## 2 DT_NSO_0300_004V5 34415980  6660

## Building requests from a tibble

You can also provide a tibble with `tbl_id` and `selections` as a
list-column:

``` r
req_tbl <- tibble::tibble(
  tbl_id = c("DT_NSO_0300_001V2","DT_NSO_0300_004V5"),
  selections = list(
    list(Sex = "Total", Age = "Total", Year = c("2023","2024")),
    list(Year = c("2023","2024"))
  )
)

pkg2 <- nso_package(req_tbl, labels = "en")
pkg2 %>% dplyr::slice_head(n = 10)
```

    ## # A tibble: 10 × 12
    ##    Sex   Age   Year    value tbl_id        Sex_en Age_en Year_en Region Location
    ##    <chr> <chr> <chr>   <dbl> <chr>         <chr>  <chr>  <chr>   <chr>  <chr>   
    ##  1 0     0     0     3441598 DT_NSO_0300_… Total  Total  2024    NA     NA      
    ##  2 0     0     1     3396788 DT_NSO_0300_… Total  Total  2023    NA     NA      
    ##  3 NA    NA    0     3441598 DT_NSO_0300_… NA     NA     2024    0      0       
    ##  4 NA    NA    1     3396788 DT_NSO_0300_… NA     NA     2023    0      0       
    ##  5 NA    NA    0     2420582 DT_NSO_0300_… NA     NA     2024    0      1       
    ##  6 NA    NA    1     2374571 DT_NSO_0300_… NA     NA     2023    0      1       
    ##  7 NA    NA    0     1021016 DT_NSO_0300_… NA     NA     2024    0      2       
    ##  8 NA    NA    1     1022217 DT_NSO_0300_… NA     NA     2023    0      2       
    ##  9 NA    NA    0      415576 DT_NSO_0300_… NA     NA     2024    1      0       
    ## 10 NA    NA    1      413704 DT_NSO_0300_… NA     NA     2023    1      0       
    ## # ℹ 2 more variables: Region_en <chr>, Location_en <chr>

Tips

- For large batches, enable caching before discovery-heavy steps:
  [`nso_cache_enable()`](https://temuulene.github.io/mongolstats/reference/nso_cache_enable.md).
- Handle intermittent network failures by re-running for affected
  tables;
  [`nso_package()`](https://temuulene.github.io/mongolstats/reference/nso_package.md)
  processes each request independently. \## Combine with discovery
  utilities

``` r
itms <- nso_tables()
target <- itms %>% dplyr::filter(stringr::str_detect(stringr::str_to_lower(tbl_eng_nm), "population")) %>% dplyr::slice_head(n = 5)
target %>% dplyr::select(tbl_id, tbl_eng_nm)
```

    ## # A tibble: 5 × 2
    ##   tbl_id             tbl_eng_nm                                                 
    ##   <chr>              <chr>                                                      
    ## 1 DT_NSO_2100_012V1  NEW CASES OF CANCER, per 10000 population, by type of canc…
    ## 2 DT_NSO_2100_013V1  DEATHS OF CANCER, per 10000 population, by year            
    ## 3 DT_NSO_2100_045V1  NEW CASES AND MORTALITY OF CANCER, per 10000 population, a…
    ## 4 DT_NSO_0300_071V02 INPATIENTS PER 10000 POPULATION, 10 leading classification…
    ## 5 DT_NSO_0100_01T39  NUMBER OF WORKING AGED POPULATION, by year
