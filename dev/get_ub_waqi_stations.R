library(httr)
library(jsonlite)
library(dplyr)

# Fetch UB stations with proper token
bounds_url <- "https://api.waqi.info/v2/map/bounds?latlng=47.85,106.75,47.95,107.05&networks=all&token=4498ab3b689ea7d15cd5d9c3fa0f0c06671997c8"

cat("Fetching UB stations from WAQI API...\n")
response <- GET(bounds_url)
raw_data <- content(response, as = "text")
data <- fromJSON(raw_data)

if (data$status == "ok") {
  # Data is already a dataframe, just clean it up
  ub_stations_waqi <- data$data %>%
    mutate(
      Station_WAQI = station$name,
      Latitude = as.numeric(lat),
      Longitude = as.numeric(lon),
      AQI = as.numeric(ifelse(aqi == "-", NA, aqi)),
      UID = uid
    ) %>%
    select(UID, Station_WAQI, Latitude, Longitude, AQI)
  
  cat("\nFound", nrow(ub_stations_waqi), "stations in Ulaanbaatar:\n\n")
  print(ub_stations_waqi)
  
  # Save to CSV
  write.csv(ub_stations_waqi, "ub_stations_waqi_coordinates.csv", row.names = FALSE)
  cat("\n✓ Saved to ub_stations_waqi_coordinates.csv\n")
  
  # Now create mapping to match with NSO station names
  # NSO stations from environmental data
  nso_stations <- c(
    "Misheel-Expo center", "West crossroad", "1st micro district", 
    "13th micro district", "32nd Toirog", "Ofitseruudiin ordon", 
    "Kharkhorin market", "Urgakh naran micro district", "Dambdarjaa", 
    "Khailaast", "Tolgoit", "Zuragt", "Amgalan", "Nisekh", 
    "Tavan buudal", "Bayankhoshuu", "Sharkhad", "100 ail"
  )
  
  cat("\nNSO Stations to match:\n")
  cat(paste(nso_stations, collapse = "\n"), "\n")
  
  cat("\n\nWAQI Station Names (Mongolian):\n")
  cat(paste(ub_stations_waqi$Station_WAQI, collapse = "\n"), "\n")
  
} else {
  cat("Error:", data$message, "\n")
}
