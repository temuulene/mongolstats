# Fuzzy name joins with mongolstats

``` r
library(mongolstats)
library(dplyr)
library(sf)
```

This vignette shows how to join tabular data to ADM1 boundaries using
fuzzy matching.

``` r
adm1 <- mn_boundaries("ADM1") %>% mn_boundaries_normalize()

# Create a small example with slightly altered names
sample_names <- head(adm1$shapeName, 6)
altered <- sub("a", "", sample_names) # remove one 'a' to simulate typos
dat <- tibble::tibble(name = altered, value = seq_along(altered))

# Fuzzy join (max distance 2)
joined <- mn_fuzzy_join_by_name(dat, name_col = "name", level = "ADM1", boundaries = adm1, max_distance = 2)
joined %>% select(shapeName, name, value) %>% head()
```

    ## Simple feature collection with 6 features and 3 fields
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: 90.0023 ymin: 42.39561 xmax: 111.9678 ymax: 50.8851
    ## Geodetic CRS:  WGS 84
    ##     shapeName       name value                       geometry
    ## 1         Uvs        Uvs     1 MULTIPOLYGON (((95.50543 49...
    ## 2       Khovd      Khovd     2 MULTIPOLYGON (((91.33829 48...
    ## 3     Zavkhan     Zvkhan     3 MULTIPOLYGON (((93.4295 48....
    ## 4      Bulgan      Bulgn     4 MULTIPOLYGON (((102.6428 50...
    ## 5   Dornogovi  Dornogovi     5 MULTIPOLYGON (((107.6873 44...
    ## 6 Ulaanbaatar Ulanbaatar     6 MULTIPOLYGON (((106.3564 48...

If you have official region names in your dataset, prefer
[`mn_join_by_name()`](https://temuulene.github.io/mongolstats/reference/mn_join_by_name.md)
for exact matching.

## Guidance for fuzzy matching

- Use `max_distance` conservatively (e.g., 1–2) to avoid incorrect
  matches.
- You can supply a different string distance `method` if `stringdist` is
  installed; Jaro-Winkler and Levenshtein are common choices.
- Always review near ties and ambiguous matches manually; consider
  exporting candidate pairs for QA if the dataset is critical.
