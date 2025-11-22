# Getting Started with mongolstats

## Installation

Install from GitHub:

``` r
# install.packages("devtools")
# devtools::install_github("temuulene/mongolstats")
```

## Your First Analysis: Infant Mortality Trends

Let’s walk through a complete workflow using infant mortality data—a key
indicator of population health and health system performance.

### Step 1: Load Packages

``` r
library(mongolstats)
library(dplyr)
library(ggplot2)

# Set language to English for readable output
nso_options(mongolstats.lang = "en")
```

### Step 2: Find the Right Table

Search for infant mortality data:

``` r
# Search by keyword
mortality_tables <- nso_itms_search("infant mortality")
mortality_tables |>
    select(tbl_id, tbl_eng_nm) |>
    head(5)
#> # A tibble: 5 × 2
#>   tbl_id            tbl_eng_nm                                                  
#>   <chr>             <chr>                                                       
#> 1 DT_NSO_2100_014V1 NUMBER OF INFANT MORTALITY, aimags and the Capital and by m…
#> 2 DT_NSO_2100_014V2 INFANT MORTALITY RATE, per 1000 live births, aimags and the…
#> 3 DT_NSO_2100_014V4 INFANT MORTALITY, by sex, by soum, and by year              
#> 4 DT_NSO_2100_014V5 INFANT MORTALITY RATE,  per 1000 live births, by sex, by so…
#> 5 DT_NSO_2100_015V1 INFANT MORTALITY RATE, per 1000 live births, aimags and the…
```

We’ll use `DT_NSO_2800_019V1` - Infant Mortality Rate per 1,000 live
births.

### Step 3: Explore Table Metadata

Before fetching data, check what dimensions are available:

``` r
# View table structure
meta <- nso_table_meta("DT_NSO_2800_019V1")
meta
#> # A tibble: 2 × 5
#>   dim           code  is_time n_values codes            
#>   <chr>         <chr> <lgl>      <int> <list>           
#> 1 Aimag         Аймаг FALSE         28 <tibble [28 × 3]>
#> 2 Time (Annual) ОН    FALSE         26 <tibble [26 × 3]>

# Check available years (data available from 1990-2015)
time_vals <- nso_dim_values("DT_NSO_2800_019V1", "Time (Annual)", labels = "en")
head(time_vals, 10)
#> # A tibble: 10 × 2
#>    code  label_en
#>    <chr> <chr>   
#>  1 0     2015    
#>  2 1     2014    
#>  3 2     2013    
#>  4 3     2012    
#>  5 4     2011    
#>  6 5     2010    
#>  7 6     2009    
#>  8 7     2008    
#>  9 8     2007    
#> 10 9     2006
```

### Step 4: Fetch Data

Get national infant mortality rates for the past two decades:

``` r
imr_national <- nso_data(
    tbl_id = "DT_NSO_2800_019V1",
    selections = list(
        "Aimag" = "Total", # National level
        "Time (Annual)" = c("2010", "2011", "2012", "2013", "2014", "2015")
    ),
    labels = "en" # Get English labels
)

# Preview
imr_national |>
    head(10)
#> # A tibble: 6 × 5
#>   Aimag `Time (Annual)` value Aimag_en `Time (Annual)_en`
#>   <chr> <chr>           <dbl> <chr>    <chr>             
#> 1 0     0                15   Total    2015              
#> 2 0     1                15.1 Total    2014              
#> 3 0     2                14.6 Total    2013              
#> 4 0     3                15.5 Total    2012              
#> 5 0     4                16.5 Total    2011              
#> 6 0     5                20.2 Total    2010
```

### Step 5: Visualize the Trend

Create a publication-ready plot:

``` r
imr_national |>
    mutate(year = as.integer(`Time (Annual)_en`)) |>
    ggplot(aes(x = year, y = value)) +
    geom_line(color = "#2c3e50", linewidth = 1.2) +
    geom_point(color = "#e74c3c", size = 4, shape = 21, fill = "white", stroke = 2) +
    geom_smooth(method = "loess", se = TRUE, color = "#3498db", fill = "#3498db", alpha = 0.1) +
    scale_x_continuous(breaks = scales::pretty_breaks()) +
    labs(
        title = "Infant Mortality Rate in Mongolia",
        subtitle = "Deaths per 1,000 live births (National Trend)",
        x = NULL,
        y = "IMR",
        caption = "Source: NSO Mongolia via mongolstats"
    ) +
    theme_minimal(base_size = 14) +
    theme(
        plot.title = element_text(face = "bold", size = 16),
        plot.subtitle = element_text(color = "grey40"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank()
    )
```

![Line plot showing decline in infant mortality rate from 2010 to
2015](getting-started_files/figure-html/plot-trend-1.png)

## Regional Comparison

Compare infant mortality across different regions:

``` r
# Get all aimags for most recent year
imr_regional <- nso_data(
    tbl_id = "DT_NSO_2800_019V1",
    selections = list(
        "Aimag" = nso_dim_values("DT_NSO_2800_019V1", "Aimag")$code,
        "Time (Annual)" = "2015" # Most recent year in dataset
    ),
    labels = "en"
) |>
    filter(Aimag != "0") |> # Exclude national total
    filter(Aimag != "511") |> # Exclude duplicate Ulaanbaatar code
    mutate(
        Aimag_en = trimws(Aimag_en),
        Type = ifelse(Aimag %in% c("1", "2", "3", "4"), "Region", "Aimag")
    )

# Top 10 highest IMR regions
imr_regional |>
    arrange(desc(value)) |>
    select(Aimag_en, value) |>
    head(10)
#> # A tibble: 10 × 2
#>    Aimag_en       value
#>    <chr>          <dbl>
#>  1 Zavkhan         25.7
#>  2 Bayan-Ulgii     24.7
#>  3 Khuvsgul        22.3
#>  4 Western region  21.6
#>  5 Khovd           20.7
#>  6 Uvs             20.4
#>  7 Sukhbaatar      18.6
#>  8 Bulgan          17.1
#>  9 Khentii         17.1
#> 10 Umnugovi        16.6
```

### Visualize Regional Disparities

``` r
imr_regional |>
    arrange(desc(value)) |>
    mutate(Aimag_en = forcats::fct_reorder(Aimag_en, value)) |>
    ggplot(aes(x = value, y = Aimag_en)) +
    # Aimags with gradient
    geom_col(data = ~ subset(., Type == "Aimag"), aes(fill = value), width = 0.7) +
    # Regions with distinct color
    geom_col(data = ~ subset(., Type == "Region"), fill = "#2c3e50", width = 0.7) +
    geom_text(aes(label = round(value, 1)), hjust = -0.2, color = "grey30", size = 3.5) +
    scale_fill_gradient2(
        low = "#27ae60",
        mid = "#f39c12",
        high = "#e74c3c",
        midpoint = median(imr_regional$value[imr_regional$Type == "Aimag"])
    ) +
    geom_vline(
        xintercept = median(imr_regional$value[imr_regional$Type == "Aimag"]),
        linetype = "dashed",
        color = "grey50",
        linewidth = 0.5
    ) +
    scale_x_continuous(expand = expansion(mult = c(0, 0.1))) +
    labs(
        title = "Infant Mortality by Aimag (2015)",
        subtitle = "Dark bars represent Regional Averages",
        x = "Deaths per 1,000 live births",
        y = NULL
    ) +
    theme_minimal(base_size = 12) +
    theme(
        plot.title = element_text(face = "bold", size = 14),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.y = element_text(color = "black")
    )
```

![Bar chart comparing infant mortality rates across Mongolia's
aimags](getting-started_files/figure-html/regional-plot-1.png)

## Adding Geographic Context

Combine with mapping for spatial analysis:

``` r
library(sf)

# Get aimag boundaries
aimags <- mn_boundaries(level = "ADM1")

# Join IMR data to map
imr_map <- aimags |>
    left_join(imr_regional, by = c("shapeName" = "Aimag_en"))

# Create choropleth
imr_map |>
    ggplot() +
    geom_sf(aes(fill = value), color = "white", size = 0.2) +
    scale_fill_viridis_c(
        option = "magma",
        direction = -1,
        name = "IMR per\n1,000",
        labels = scales::label_number()
    ) +
    labs(
        title = "Infant Mortality Geography (2015)",
        subtitle = "Spatial distribution of mortality rates",
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

![Choropleth map of infant mortality rates across
Mongolia](getting-started_files/figure-html/map-example-1.png)

## Key Functions Summary

| Function                                                                                        | Purpose                   | Example                             |
|-------------------------------------------------------------------------------------------------|---------------------------|-------------------------------------|
| [`nso_itms_search()`](https://temuulene.github.io/mongolstats/reference/nso_itms_search.md)     | Find tables by keyword    | `nso_itms_search("mortality")`      |
| [`nso_table_meta()`](https://temuulene.github.io/mongolstats/reference/nso_table_meta.md)       | Get table dimensions      | `nso_table_meta("DT_NSO_...")`      |
| [`nso_dim_values()`](https://temuulene.github.io/mongolstats/reference/nso_dim_values.md)       | List dimension values     | `nso_dim_values(tbl, "Region")`     |
| [`nso_table_periods()`](https://temuulene.github.io/mongolstats/reference/nso_table_periods.md) | Check time coverage       | `nso_table_periods(tbl)`            |
| [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md)                   | Fetch data                | `nso_data(tbl, selections, labels)` |
| [`mn_boundaries()`](https://temuulene.github.io/mongolstats/reference/mn_boundaries.md)         | Get geographic boundaries | `mn_boundaries(level = "ADM1")`     |

## Best Practices

1.  **Always use labels**: Set `labels = "en"` in
    [`nso_data()`](https://temuulene.github.io/mongolstats/reference/nso_data.md)
    for readable output
2.  **Check metadata first**: Use
    [`nso_table_meta()`](https://temuulene.github.io/mongolstats/reference/nso_table_meta.md)
    to understand dimensions before fetching
3.  **Use appropriate selections**: Specify dimensions by their English
    labels (e.g., `"Total"` not `"0"`)
4.  **Filter carefully**: Exclude total rows (usually code `"0"`) when
    analyzing subgroups
5.  **Clean labels**: Use
    [`trimws()`](https://rdrr.io/r/base/trimws.html) to remove
    leading/trailing spaces from region names before joining

## Common Workflows

### Time Series Analysis

1.  Search for table → Check periods → Fetch years → Plot trend

### Regional Comparison

1.  Search table → Get all regions → Fetch latest year → Compare rates

### Spatial Epidemiology

1.  Fetch regional data → Get boundaries → Join → Create choropleth

## Next Steps

- **Discover More Data**: See the [Discovery
  Guide](https://temuulene.github.io/mongolstats/articles/discovery.md)
  for advanced search techniques
- **Create Maps**: Learn spatial analysis in the [Mapping
  Guide](https://temuulene.github.io/mongolstats/articles/mapping.md)  
- **Reference**: Browse all functions in the
  [Reference](https://temuulene.github.io/mongolstats/reference/index.md)

## Quick Reference: Common Health Tables

| Indicator             | Table_ID          |
|:----------------------|:------------------|
| Infant Mortality      | DT_NSO_2800_019V1 |
| Maternal Mortality    | DT_NSO_2100_050V1 |
| Under-5 Mortality     | DT_NSO_2100_030V2 |
| Cancer Incidence      | DT_NSO_2100_012V1 |
| TB Incidence          | DT_NSO_2800_026V1 |
| Communicable Diseases | DT_NSO_2100_020V2 |
