# UB Air Quality Station Mapping
# Based on station names from NSO data

library(dplyr)
library(tibble)

# Create station-to-district mapping based on known UB districts and station names
# Ulaanbaatar has 9 districts: Bayangol, Bayanzurkh, Songino Khairkhan, Khan-Uul, 
# Sukhbaatar, Chingeltei, Nalaikh, Baganuur, Bagakhangai

ub_stations <- tribble(
  ~Station, ~District, ~Latitude, ~Longitude, ~Notes,
  "Misheel-Expo center", "Bayanzurkh", 47.9170, 106.9500, "Near Misheel area",
  "West crossroad", "Songino Khairkhan", 47.9100, 106.8200, "Western district",
  "1st micro district", "Sukhbaatar", 47.9200, 106.9200, "Central downtown",
  "13th micro district", "Sukhbaatar", 47.9150, 106.9400, "Central area",
  "32nd Toirog", "Khan-Uul", 47.8950, 106.9300, "Southern district",
  "Ofitseruudiin ordon", "Bayangol", 47.9100, 106.8800, "Western central",
  "Kharkhorin market", "Bayangol", 47.9000, 106.8700, "Market area",
  "Urgakh naran micro district", "Bayanzurkh", 47.9300, 106.9700, "Eastern district",
  "Dambdarjaa", "Chingeltei", 47.9250, 106.9100, "Northern central",
  "Khailaast", "Chingeltei", 47.9350, 106.9150, "Northern area",
  "Tolgoit", "Bayanzurkh", 47.9200, 106.9800, "Eastern hills",
  "Zuragt", "Bayanzurkh", 47.9250, 106.9650, "Eastern area",
  "Amgalan", "Bayanzurkh", 47.9180, 106.9550, "Eastern district",
  "Nisekh", "Khan-Uul", 47.8900, 106.9100, "Southern area",
  "Tavan buudal", "Songino Khairkhan", 47.9050, 106.8500, "Western area",
  "Bayankhoshuu", "Songino Khairkhan", 47.8950, 106.7800, "Far west",
  "Sharkhad", "Khan-Uul", 47.8800, 106.9200, "Southern hills",
  "100 ail", "Bayanzurkh", 47.9100, 106.9600, "Eastern neighborhood"
)

print(ub_stations)

# Count by district
district_count <- ub_stations %>%
  count(District, sort = TRUE)

print("\nStations per District:")
print(district_count)
