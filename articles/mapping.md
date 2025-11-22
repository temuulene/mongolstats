# Spatial Epidemiology with mongolstats

``` r
library(mongolstats)
library(sf)
library(dplyr)
library(ggplot2)
nso_options(mongolstats.lang = "en")
```

## Overview

Geographic analysis is essential for understanding health disparities
and targeting interventions. This guide demonstrates spatial
epidemiology using Mongolia’s aimag-level (provincial) health data.

## Getting Boundary Data

Mongolia’s administrative boundaries are available at three levels:

``` r
# ADM0: National boundary
country <- mn_boundaries(level = "ADM0")

# ADM1: Aimags (21 provinces + Ulaanbaatar)
aimags <- mn_boundaries(level = "ADM1")

# ADM2: Soums (districts)
soums <- mn_boundaries(level = "ADM2")

# Quick preview
aimags |>
  ggplot() +
  geom_sf(fill = "white", color = "grey30", size = 0.3) +
  theme_void() +
  labs(title = "Mongolia's 21 Aimags + Ulaanbaatar")
```

![](mapping_files/figure-html/boundaries-1.png)

## Case Study: Maternal Mortality Geography

### Understanding Regional Disparities

Maternal mortality is a critical indicator of health system performance
and equity.

``` r
# Fetch maternal mortality by aimag
mmr_data <- nso_data(
  tbl_id = "DT_NSO_2100_050V1", # MMR per 100,000 live births
  selections = list(
    "Region" = nso_dim_values("DT_NSO_2100_050V1", "Region")$code,
    "Year" = "2024"
  ),
  labels = "en"
) |>
  filter(!Region %in% c("0", "1", "2", "3", "4", "511")) |> # Exclude Total, Regions, and duplicate UB
  mutate(
    Region_en = trimws(Region_en),
    Region_en = dplyr::case_match(
      Region_en,
      "Bayan-Ulgii" ~ "Bayan-Ölgii",
      "Uvurkhangai" ~ "Övörkhangai",
      "Khuvsgul" ~ "Hovsgel",
      "Umnugovi" ~ "Ömnögovi",
      "Tuv" ~ "Töv",
      "Sukhbaatar" ~ "Sükhbaatar",
      .default = Region_en
    )
  )

# Preview data
mmr_data |>
  arrange(desc(value)) |>
  select(Region_en, value) |>
  head(10)
#> # A tibble: 10 × 2
#>    Region_en  value
#>    <chr>      <dbl>
#>  1 Selenge     1639
#>  2 Govi-Altai  1538
#>  3 Selenge     1515
#>  4 Ömnögovi    1460
#>  5 Dornogovi   1389
#>  6 Töv         1266
#>  7 Töv         1235
#>  8 Selenge     1220
#>  9 Töv         1220
#> 10 Khentii     1220
```

### Creating a Choropleth Map

``` r
# Join health data to geographic boundaries
mmr_map <- aimags |>
  left_join(mmr_data, by = c("shapeName" = "Region_en"))

# Create choropleth
mmr_map |>
  ggplot() +
  geom_sf(aes(fill = value), color = "white", size = 0.2) +
  scale_fill_viridis_c(
    option = "rocket",
    direction = -1,
    name = "MMR per\n100,000",
    labels = scales::label_number()
  ) +
  labs(
    title = "Maternal Mortality Ratio by Aimag (2024)",
    subtitle = "Deaths per 100,000 live births",
    caption = "Source: NSO Mongolia"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "grey40"),
    legend.position = "right", # Moved to right to avoid overlap
    legend.title = element_text(size = 10, face = "bold")
  )
```

![](mapping_files/figure-html/maternal-map-1.png)

## Case Study: Infant Mortality Hot Spots

### Identifying High-Risk Regions

``` r
# Get infant mortality rates
imr_tbl <- "DT_NSO_2100_015V1" # IMR per 1,000 live births (Monthly)

# Get metadata
months <- nso_dim_values(imr_tbl, "Month", labels = "en")
months_2024 <- months |>
  filter(grepl("2024", label_en)) |>
  pull(code)

imr_data <- nso_data(
  tbl_id = imr_tbl,
  selections = list(
    "Region" = nso_dim_values(imr_tbl, "Region")$code,
    "Month" = months_2024
  ),
  labels = "en"
) |>
  filter(nchar(Region) == 3) |> # Keep only Aimags and Ulaanbaatar
  mutate(
    Region_en = trimws(Region_en),
    Region_en = dplyr::case_match(
      Region_en,
      "Bayan-Ulgii" ~ "Bayan-Ölgii",
      "Uvurkhangai" ~ "Övörkhangai",
      "Khuvsgul" ~ "Hovsgel",
      "Umnugovi" ~ "Ömnögovi",
      "Tuv" ~ "Töv",
      "Sukhbaatar" ~ "Sükhbaatar",
      .default = Region_en
    )
  ) |>
  # Calculate annual average
  group_by(Region_en) |>
  summarise(value = mean(value, na.rm = TRUE), .groups = "drop") |>
  mutate(
    # Classify risk levels
    risk_category = case_when(
      value < 10 ~ "Low (<10)",
      value < 20 ~ "Medium (10-20)",
      value < 30 ~ "High (20-30)",
      TRUE ~ "Very High (≥30)"
    ),
    risk_category = factor(
      risk_category,
      levels = c("Low (<10)", "Medium (10-20)", "High (20-30)", "Very High (≥30)")
    )
  )

# Create risk map
aimags |>
  left_join(imr_data, by = c("shapeName" = "Region_en")) |>
  ggplot() +
  geom_sf(aes(fill = risk_category), color = "white", size = 0.2) +
  scale_fill_manual(
    values = c(
      "Low (<10)" = "#27ae60",
      "Medium (10-20)" = "#f1c40f",
      "High (20-30)" = "#e67e22",
      "Very High (≥30)" = "#c0392b"
    ),
    na.value = "grey90",
    name = "Risk Level",
    drop = FALSE
  ) +
  labs(
    title = "Infant Mortality Risk Categories (2024 Average)",
    subtitle = "Deaths per 1,000 live births",
    caption = "Source: NSO Mongolia"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "grey40"),
    legend.position = "right",
    legend.title = element_text(size = 10, face = "bold")
  )
```

![](mapping_files/figure-html/imr-hotspots-1.png)

## Tips for Spatial Epidemiology

1.  **Check data completeness**: Not all aimags may have data for all
    indicators
2.  **Use appropriate scales**: Choose color scales that highlight
    health disparities
3.  **Add context**: Include reference lines (e.g., national average)
    when relevant
4.  **Consider population size**: Normalize rates by population when
    comparing regions
5.  **Temporal analysis**: Create animated maps to show geographic
    trends over time

## Next Steps

- **Discover Health Data**: Return to the [Discovery
  Guide](https://temuulene.github.io/mongolstats/articles/discovery.md)
- **Learn More**: Explore all functions in the
  [Reference](https://temuulene.github.io/mongolstats/reference/index.md)
