library(mongolstats)
library(dplyr)
library(stringr)

# Fetch monthly data with year selection
cat("Fetching monthly air quality data for 2023-2025...\n")
air_monthly <- nso_data(
  "DT_NSO_2400_015V2",
  selections = list(
    Year = as.character(2023:2025)
  ),
  labels = "en"
)

cat("\nChecking Year column name...\n")
print(names(air_monthly))

cat("\nChecking unique values in Month_en column...\n")
dates <- unique(air_monthly$Month_en)
print(head(dates, 20))
print(tail(dates, 20))

cat("\nExtracting years from Month_en...\n")
years <- unique(substr(air_monthly$Month_en, 1, 4))
print(sort(years))

cat("\nDate range in data:\n")
cat("Earliest:", min(air_monthly$Month_en), "\n")
cat("Latest:", max(air_monthly$Month_en), "\n")
