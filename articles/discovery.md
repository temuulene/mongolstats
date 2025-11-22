# Discovering Public Health Data

``` r
library(mongolstats)
library(dplyr)
library(ggplot2)
nso_options(mongolstats.lang = "en")
```

## Overview

Mongolia’s National Statistics Office maintains comprehensive public
health surveillance data. This guide demonstrates how to discover and
access epidemiological data for research and policy analysis.

## Finding Health Tables

### Search by Keyword

Use
[`nso_itms_search()`](https://temuulene.github.io/mongolstats/reference/nso_itms_search.md)
to find tables related to specific health topics:

``` r
# Infant and maternal health
mortality <- nso_itms_search("mortality")
mortality |>
  select(tbl_id, tbl_eng_nm) |>
  head(10)
#> # A tibble: 10 × 2
#>    tbl_id            tbl_eng_nm                                                 
#>    <chr>             <chr>                                                      
#>  1 DT_NSO_2100_014V1 NUMBER OF INFANT MORTALITY, aimags and the Capital and by …
#>  2 DT_NSO_2100_014V2 INFANT MORTALITY RATE, per 1000 live births, aimags and th…
#>  3 DT_NSO_2100_014V4 INFANT MORTALITY, by sex, by soum, and by year             
#>  4 DT_NSO_2100_014V5 INFANT MORTALITY RATE,  per 1000 live births, by sex, by s…
#>  5 DT_NSO_2100_015V1 INFANT MORTALITY RATE, per 1000 live births, aimags and th…
#>  6 DT_NSO_2100_015V2 INFANT MORTALITY, per 1000 live births, by soum, and by ye…
#>  7 DT_NSO_2100_023V1 MATERNAL MORTALITY RATIO,  per 1,000 live births, by soum,…
#>  8 DT_NSO_2100_030V2 UNDER-FIVE MORTALITY, per 1000 live births, aimags and the…
#>  9 DT_NSO_2100_040V1 NEONATAL MORTALITY, aimags and the Capital and by month    
#> 10 DT_NSO_2100_040V2 NEONATAL MORTALITY RATE, per 1000 live births, aimags and …

# Cancer surveillance
cancer <- nso_itms_search("cancer")
cancer |> select(tbl_id, tbl_eng_nm)
#> # A tibble: 4 × 2
#>   tbl_id            tbl_eng_nm                                                  
#>   <chr>             <chr>                                                       
#> 1 DT_NSO_2100_012V1 NEW CASES OF CANCER, per 10000 population, by type of cancer
#> 2 DT_NSO_2100_013V1 DEATHS OF CANCER, per 10000 population, by year             
#> 3 DT_NSO_2100_044V1 NEW CASES OF CANCER, by age group, by year                  
#> 4 DT_NSO_2100_045V1 NEW CASES AND MORTALITY OF CANCER, per 10000 population, ai…

# Communicable diseases
infectious <- nso_itms_search("tuberculosis")
infectious |> select(tbl_id, tbl_eng_nm)
#> # A tibble: 4 × 2
#>   tbl_id            tbl_eng_nm                                                  
#>   <chr>             <chr>                                                       
#> 1 DT_NSO_2800_025V1 PREVALENCE TUBERCULOSIS PER 100000 PERSON, by aimags and th…
#> 2 DT_NSO_2800_026V1 INCIDENCE OF TUBERCULOSIS PER 100000 PERSON, by aimags and …
#> 3 DT_NSO_2800_027V1 DEATH RATES ASSOCIATED WITH TUBERCULOSIS PER 100000 PERSON,…
#> 4 DT_NSO_2800_028V1 PROPORTION OF TUBERCULOSIS CASES DETECTED AND CURED UNDER D…
```

### Browse by Sector

Health and education statistics are grouped together:

``` r
# View all sectors
sectors <- nso_sectors()
sectors
#> # A tibble: 8 × 3
#>   id                    type  text                 
#>   <chr>                 <chr> <chr>                
#> 1 Economy, environment  l     Economy, environment 
#> 2 Education, health     l     Education, health    
#> 3 Historical data       l     Historical data      
#> 4 Industry, service     l     Industry, service    
#> 5 Labour, business      l     Labour, business     
#> 6 Population, household l     Population, household
#> 7 Regional development  l     Regional development 
#> 8 Society, development  l     Society, development

# Find health-related subsectors
health_sector <- sectors |> filter(grepl("health", text, ignore.case = TRUE))
if (nrow(health_sector) > 0) {
  subsectors <- nso_subsectors(health_sector$id[1])
  subsectors |> head()
}
#> # A tibble: 6 × 3
#>   id                                type  text                             
#>   <chr>                             <chr> <chr>                            
#> 1 Births, deaths                    l     Births, deaths                   
#> 2 Disease                           l     Disease                          
#> 3 General educational schools       l     General educational schools      
#> 4 General indicators for Education  l     General indicators for Education 
#> 5 Health insurance                  l     Health insurance                 
#> 6 Main indicators for Health sector l     Main indicators for Health sector
```

## Case Study: Cancer Epidemiology

### Exploring Cancer Incidence Data

Let’s analyze cancer trends in Mongolia:

``` r
# Find cancer incidence table
cancer_tbl <- "DT_NSO_2100_012V1" # New cases per 10,000 population

# Examine available dimensions
meta <- nso_table_meta(cancer_tbl)
meta
#> # A tibble: 2 × 5
#>   dim                      code               is_time n_values codes            
#>   <chr>                    <chr>              <lgl>      <int> <list>           
#> 1 Type malignant neoplasms Хорт хавдрын төрөл FALSE          7 <tibble [7 × 3]> 
#> 2 Annual                   Он                 FALSE         25 <tibble [25 × 3]>

# View cancer types
cancer_types <- nso_dim_values(cancer_tbl, "Type malignant neoplasms", labels = "en")
cancer_types |> head(10)
#> # A tibble: 7 × 2
#>   code  label_en       
#>   <chr> <chr>          
#> 1 0     "Total"        
#> 2 1     " Liver"       
#> 3 2     " Cervix uteri"
#> 4 3     " Stomach"     
#> 5 4     " Lung"        
#> 6 5     " Oesophagus"  
#> 7 6     " Other"

# Check time coverage
# Note: "Annual" dimension uses internal codes, so we map labels (years) to codes
annual_meta <- nso_dim_values(cancer_tbl, "Annual", labels = "both")
years <- annual_meta$label_en
years
#>  [1] "2024" "2023" "2022" "2021" "2020" "2019" "2018" "2017" "2016" "2015"
#> [11] "2014" "2013" "2012" "2011" "2010" "2009" "2008" "2007" "2006" "2005"
#> [21] "2004" "2003" "2002" "2001" "2000"
```

### Fetching and Visualizing Cancer Trends

``` r
# Fetch top cancer types over recent years
# Get codes for the last 10 years
recent_years <- annual_meta |>
  arrange(label_en) |>
  tail(10) |>
  pull(code)

cancer_data <- nso_data(
  tbl_id = cancer_tbl,
  selections = list(
    "Type malignant neoplasms" = c("1", "2", "3", "4"), # Lung, Liver, Stomach, Cervix
    "Annual" = recent_years
  ),
  labels = "en"
)

# Visualize trends
cancer_data |>
  ggplot(aes(x = as.integer(Annual_en), y = value, color = `Type malignant neoplasms_en`)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3, shape = 21, fill = "white", stroke = 1.5) +
  scale_color_viridis_d(option = "plasma", end = 0.9) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 5)) +
  labs(
    title = "Cancer Incidence Trends in Mongolia",
    subtitle = "New cases per 10,000 population (Recent Trends)",
    x = NULL,
    y = "Incidence Rate",
    color = NULL,
    caption = "Source: NSO Mongolia"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "top",
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "grey40", margin = margin(b = 10)),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.text = element_text(color = "grey30")
  )
```

![](discovery_files/figure-html/cancer-analysis-1.png)

## Case Study: Infant Mortality Surveillance

### Regional Disparities

``` r
# Infant mortality by aimag
imr_tbl <- "DT_NSO_2800_019V1" # IMR per 1,000 live births

# Get metadata
imr_meta <- nso_table_meta(imr_tbl)
aimags <- nso_dim_values(imr_tbl, "Aimag", labels = "en")

# Fetch recent data for all regions
imr_data <- nso_data(
  tbl_id = imr_tbl,
  selections = list(
    "Aimag" = aimags$code,
    "Time (Annual)" = "0" # Code for 2015 (checked via metadata)
  ),
  labels = "en"
) |>
  filter(Aimag != "0") |> # Exclude national total
  mutate(Aimag_en = trimws(Aimag_en))

# Find regions with highest IMR
imr_data |>
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

### Time Trend Analysis

``` r
# Analyze national trend
imr_national <- nso_data(
  tbl_id = imr_tbl,
  selections = list(
    "Aimag" = "0", # National total (code 0)
    "Time (Annual)" = as.character(0:5) # Codes for 2015-2010 (0=2015, 5=2010 based on debug)
  ),
  labels = "en"
)

imr_national |>
  mutate(year = as.integer(`Time (Annual)_en`)) |>
  ggplot(aes(x = year, y = value)) +
  geom_ribbon(aes(ymin = value * 0.9, ymax = value * 1.1), fill = "#e74c3c", alpha = 0.1) + # Illustrative CI
  geom_line(color = "#c0392b", linewidth = 1.5) +
  geom_point(color = "#c0392b", size = 4, shape = 21, fill = "white", stroke = 2) +
  geom_text(aes(label = value), vjust = -1.5, fontface = "bold", color = "#c0392b") +
  scale_x_continuous(breaks = scales::pretty_breaks()) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = c(0, 0.2))) +
  labs(
    title = "Infant Mortality Rate Decline",
    subtitle = "Deaths per 1,000 live births (2010-2015)",
    x = NULL,
    y = "IMR",
    caption = "Source: NSO Mongolia"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "grey40"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  )
```

![](discovery_files/figure-html/imr-trends-1.png)

## Case Study: Tuberculosis Burden

``` r
# TB incidence
tb_incidence <- nso_data(
  tbl_id = "DT_NSO_2800_026V1", # TB per 100,000
  selections = list(
    "Aimag" = "0", # National Total
    "Time (Annual)" = as.character(0:5) # Codes for recent years (checked via metadata)
  ),
  labels = "en"
)

# TB mortality
tb_mortality <- nso_data(
  tbl_id = "DT_NSO_2800_027V1", # TB deaths per 100,000
  selections = list(
    "Aimag" = "0", # National Total
    "Time (Annual)" = as.character(0:5)
  ),
  labels = "en"
)

# Combine for case-fatality analysis
tb_combined <- tb_incidence |>
  select(time = `Time (Annual)_en`, incidence = value) |>
  left_join(
    tb_mortality |> select(time = `Time (Annual)_en`, mortality = value),
    by = "time"
  ) |>
  mutate(
    case_fatality = (mortality / incidence) * 100,
    year = as.integer(time)
  )

# Visualize
tb_combined |>
  ggplot(aes(x = year)) +
  geom_col(aes(y = incidence, fill = "Incidence"), alpha = 0.8, width = 0.7) +
  geom_line(aes(y = mortality * 50, color = "Mortality (x50)"), linewidth = 1.5) +
  geom_point(aes(y = mortality * 50, color = "Mortality (x50)"), size = 3, shape = 21, fill = "white", stroke = 2) +
  scale_y_continuous(
    name = "Incidence (per 100,000)",
    sec.axis = sec_axis(~ . / 50, name = "Mortality (per 100,000)")
  ) +
  scale_fill_manual(values = c("Incidence" = "#34495e"), name = NULL) +
  scale_color_manual(values = c("Mortality (x50)" = "#e74c3c"), name = NULL) +
  labs(
    title = "Tuberculosis Burden in Mongolia",
    subtitle = "Incidence vs. Mortality Trends",
    x = NULL,
    caption = "Source: NSO Mongolia"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(color = "grey40"),
    legend.position = "top",
    legend.box = "horizontal",
    panel.grid.minor = element_blank(),
    axis.title.y.right = element_text(color = "#e74c3c", margin = margin(l = 10)),
    axis.text.y.right = element_text(color = "#e74c3c"),
    axis.title.y.left = element_text(color = "#34495e", margin = margin(r = 10)),
    axis.text.y.left = element_text(color = "#34495e")
  )
```

![](discovery_files/figure-html/tb-data-1.png)

## Tips for Epidemiological Research

1.  **Always check time coverage**: Use
    [`nso_table_periods()`](https://temuulene.github.io/mongolstats/reference/nso_table_periods.md)
    to verify data availability
2.  **Use labels for clarity**: Set `labels = "en"` to get readable
    dimension names
3.  **Join multiple indicators**: Combine tables to calculate derived
    metrics (e.g., case-fatality rates)
4.  **Account for denominator data**: Link disease counts with
    population data for rate calculations
5.  **Regional analysis**: Most health tables include breakdowns by
    aimag and soum for geographic analysis

## Next Steps

- **Mapping Health Outcomes**: See the [Mapping
  Guide](https://temuulene.github.io/mongolstats/articles/mapping.md)
  for spatial epidemiology
- **Reference Documentation**: Explore all available functions in the
  [Reference](https://temuulene.github.io/mongolstats/reference/index.md)
