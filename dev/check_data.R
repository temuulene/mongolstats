
library(mongolstats)
library(dplyr)
library(stringr)

# 1. Check Air Quality Data for 2025 and PM availability
cat("Checking Air Quality Data...\n")
air_monthly <- nso_data(
  "DT_NSO_2400_015V2",
  selections = list(
    Year = c("2023", "2024", "2025")
  ),
  labels = "en"
)

# Filter for UB stations
ub_stations <- c(
  "Misheel-Expo center", "West crossroad", "1st micro district", 
  "13th micro district", "32nd Toirog", "Ofitseruudiin ordon", 
  "Kharkhorin market", "Urgakh naran micro district", "Dambdarjaa", 
  "Khailaast", "Tolgoit", "Zuragt", "Amgalan", "Nisekh", 
  "Tavan buudal", "Bayankhoshuu", "Sharkhad", "100 ail"
)

air_ub <- air_monthly %>%
  filter(!is.na(value)) %>%
  mutate(
    Station = str_trim(Location_en),
    Pollutant = str_trim(`Indicator of air pollution_en`)
  ) %>%
  filter(Station %in% ub_stations)

cat("Available Years:\n")
print(unique(air_ub$Year_en))

cat("\nAvailable Pollutants in UB:\n")
print(unique(air_ub$Pollutant))

cat("\nChecking PM data specifically:\n")
pm_data <- air_ub %>% 
  filter(str_detect(Pollutant, "PM")) %>%
  group_by(Pollutant) %>%
  summarise(count = n(), min_date = min(Month_en), max_date = max(Month_en))
print(pm_data)

# 2. Check Water Quality Data
cat("\nChecking Water Quality Data...\n")
water <- nso_data(
  "DT_NSO_2300_005V12",
  selections = list(),
  labels = "en"
)
cat("Total Water Stations:", n_distinct(water$`Station location_en`), "\n")

