# Mapping with mongolstats

``` r
library(mongolstats)
library(dplyr)
library(sf)
```

This vignette shows how to join data to ADM1 boundaries by name.

``` r
adm1 <- mn_boundaries("ADM1") %>% mn_boundaries_normalize()
head(adm1$name_std)
```

    ## [1] "uvs"         "khovd"       "zavkhan"     "bulgan"      "dornogovi"  
    ## [6] "ulaanbaatar"

Suppose we fetched a table that reports values by aimag:

``` r
tbl <- "DT_NSO_0300_004V5"  # Resident population by location and region

periods <- nso_table_periods(tbl)
dat <- if (length(periods)) nso_data(tbl, selections = list(Year = tail(periods, 1)), labels = "en") else tibble::tibble()

# Create a name column from the 'Region' dimension if present
if ("Region_en" %in% names(dat)) dat$name <- dat$Region_en else if ("Region" %in% names(dat)) dat$name <- dat$Region

joined <- tryCatch(mn_join_by_name(dat, name_col = "name", level = "ADM1"), error = function(e) adm1)
```

``` r
plot(sf::st_geometry(joined))
```

![Map of joined ADM1
geometries](mapping_files/figure-html/unnamed-chunk-4-1.png)

ADM1 map joined to example data

Note: Name-based joins are heuristic. For rigorous joins, prefer stable
codes once a consistent NSO geographic classification is identified.

## Alternative: join using stable keys

If your dataset includes stable identifiers, prefer key-based joins with
[`mn_boundary_keys()`](https://temuulene.github.io/mongolstats/reference/mn_boundary_keys.md):

``` r
keys <- mn_boundary_keys("ADM1")  # contains shapeID, shapeName, shapeISO, name_std
# Example: if your data has shapeISO, join on that instead of names
```

## Plotting with alt text (accessibility)

For site accessibility, set alt text and captions in plot chunks:

``` r
plot(sf::st_geometry(adm1))
```

![Map of Mongolia ADM1 boundaries joined to example
values](mapping_files/figure-html/unnamed-chunk-6-1.png)

ADM1 map example
