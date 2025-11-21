# Troubleshooting PXWeb requests

``` r
library(mongolstats)
library(dplyr)
nso_options(mongolstats.lang = "en")
```

## Common errors and fixes

### 400 Bad Request (dimension not selected)

PXWeb requires a selection for every dimension. `mongolstats` includes
all unspecified dimensions automatically, but invalid labels/codes still
fail.

Fix: Inspect dimensions and values; select by code or label.

``` r
dims <- tryCatch(nso_dims("DT_NSO_0300_001V2"), error = function(e) tibble::tibble())
vals_year <- tryCatch(nso_dim_values("DT_NSO_0300_001V2", "Year", labels = "en"), error = function(e) tibble::tibble())
head(vals_year)
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

### Label/code mismatch

If labels are used where codes are required, `mongolstats` maps labels
to codes when possible. When ambiguous, it errors with candidates.

Fix: Prefer exact labels from
[`nso_dim_values()`](https://temuulene.github.io/mongolstats/reference/nso_dim_values.md)
or select codes directly.

``` r
q <- nso_query("DT_NSO_0300_001V2", list(Year = "2024", Sex = c("Male","Female"), Age = "Total"))
dat <- tryCatch(nso_fetch(q, labels = "en"), error = function(e) tibble::tibble())
head(dat)
```

    ## # A tibble: 2 × 7
    ##   Sex   Age   Year    value Sex_en Age_en Year_en
    ##   <chr> <chr> <chr>   <dbl> <chr>  <chr>  <chr>  
    ## 1 1     0     0     1696862 Male   Total  2024   
    ## 2 2     0     0     1744736 Female Total  2024

### Timeouts / 413 Payload Too Large

Large selections can be slow or rejected. Reduce the number of values
per dimension, or fetch in batches.

Tips: - Narrow your Year range or category lists. - Fetch multiple
slices and
[`bind_rows()`](https://dplyr.tidyverse.org/reference/bind_rows.html)
them. - Use caching to avoid repeated metadata calls:
`nso_cache_enable(ttl = 7 * 24 * 3600)`.

### Offline errors

When offline mode is enabled, network calls error fast with a typed
condition.

``` r
nso_offline_enable()
try(nso_sectors(), silent = TRUE)
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

``` r
nso_offline_disable()
```

### Debugging requests

Enable verbose logging to inspect URLs and payloads.

``` r
options(mongolstats.verbose = TRUE)
invisible(try(nso_data("DT_NSO_0300_001V2", list(Year = "2024", Sex = "Total", Age = "Total")), silent = TRUE))
options(mongolstats.verbose = FALSE)
```

## Best practices

- Discover with
  [`nso_itms()`](https://temuulene.github.io/mongolstats/reference/nso_itms.md) +
  [`nso_search()`](https://temuulene.github.io/mongolstats/reference/nso_search.md);
  inspect with
  [`nso_dims()`](https://temuulene.github.io/mongolstats/reference/nso_dims.md)
  and
  [`nso_dim_values()`](https://temuulene.github.io/mongolstats/reference/nso_dim_values.md).
- Keep examples fast; cache metadata during development.
- Prefer code selections for stable scripts; add labels via
  `labels = 'en'` when needed.
- Guard long-running chunks in vignettes with internet checks.
