# Fetching data and working with periods

``` r
library(mongolstats)
library(dplyr)
```

## Build period sequences

``` r
# Monthly sequence
nso_period_seq("201801", "201812", by = "M")
```

    ##  [1] "201801" "201802" "201803" "201804" "201805" "201806" "201807" "201808"
    ##  [9] "201809" "201810" "201811" "201812"

``` r
# Yearly sequence
nso_period_seq("2018", "2022", by = "Y")
```

    ## [1] "2018" "2019" "2020" "2021" "2022"

## Valid periods for a table

``` r
tbl <- "DT_NSO_0300_001V2"
periods <- nso_table_periods(tbl)
head(periods)
```

    ## [1] "2024" "2023" "2022" "2021" "2020" "2019"

``` r
tail(periods)
```

    ## [1] "2005" "2004" "2003" "2002" "2001" "2000"

## Fetch data by period and variables

``` r
dat <- nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(Sex = "Total", Age = "Total", Year = head(periods, 1)),
  labels = "en"
)
dat %>% dplyr::slice_head(n = 6)
```

    ## # A tibble: 1 × 7
    ##   Sex   Age   Year    value Sex_en Age_en Year_en
    ##   <chr> <chr> <chr>   <dbl> <chr>  <chr>  <chr>  
    ## 1 0     0     0     3441598 Total  Total  2024

## Multi-year pulls and quick trend summaries

``` r
yrs <- head(periods, 5)
series <- nso_data(
  tbl_id = tbl,
  selections = list(Sex = "Total", Age = "Total", Year = yrs)
)

series %>%
  dplyr::group_by(Year) %>%
  dplyr::summarise(value = sum(value, na.rm = TRUE)) %>%
  dplyr::arrange(Year)
```

    ## # A tibble: 5 × 2
    ##   Year    value
    ##   <chr>   <dbl>
    ## 1 0     3441598
    ## 2 1     3396788
    ## 3 2     3368632
    ## 4 3     3312275
    ## 5 4     3253283

If you prefer a quick base plot during interactive work:

``` r
trend <- series %>% dplyr::group_by(Year) %>% dplyr::summarise(value = sum(value, na.rm = TRUE))
if (nrow(trend) > 1) plot(as.numeric(trend$Year), trend$value, type = "b", main = "Total by Year", xlab = "Year", ylab = "Value")
```

![](fetching-periods_files/figure-html/unnamed-chunk-6-1.png)
