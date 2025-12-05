library(httr)
library(jsonlite)
library(dplyr)

# Fetch UB stations using WAQI API
# Using the demo token as shown in the API documentation

# 1. Search for Ulaanbaatar stations
search_url <- "https://api.waqi.info/search/?token=demo&keyword=ulaanbaatar"

response <- GET(search_url)
data <- content(response, as = "text") %>% fromJSON()

if (data$status == "ok") {
  stations_data <- data$data
  
  cat("Found", nrow(stations_data), "stations in Ulaanbaatar\n\n")
  
  # Extract station information (accessing nested list-cols correctly)
  ub_stations_api <- data.frame(
    idx = stations_data$uid,
    Station_Name = sapply(1:nrow(stations_data), function(i) stations_data$station$name[i]),
    Latitude = sapply(1:nrow(stations_data), function(i) stations_data$station$geo[[i]][1]),
    Longitude = sapply(1:nrow(stations_data), function(i) stations_data$station$geo[[i]][2]),
    AQI = stations_data$aqi,
    stringsAsFactors = FALSE
  )
  
  print(ub_stations_api)
  
  # Save to CSV for reference
  write.csv(ub_stations_api, "ub_stations_waqi.csv", row.names = FALSE)
  cat("\nSaved to ub_stations_waqi.csv\n")
  
} else {
  cat("Error:", data$message, "\n")
}

# Also try map bounds for broader coverage
cat("\n\nFetching stations using map bounds...\n")
# Ulaanbaatar bounds: approximately 47.8-48.0 lat, 106.7-107.0 lng
bounds_url <- "https://api.waqi.info/v2/map/bounds?latlng=47.8,106.7,48.0,107.0&networks=all&token=demo"

response2 <- GET(bounds_url)
data2 <- content(response2, as = "text") %>% fromJSON()

if (data2$status == "ok") {
  cat("Found", length(data2$data), "stations in the bounds\n")
  
  # Extract station info from map bounds
  stations_bounds <- do.call(rbind, lapply(data2$data, function(x) {
    data.frame(
      idx = x$uid,
      Station_Name = x$station$name,
      Latitude = x$lat,
      Longitude = x$lon,
      AQI = x$aqi,
      stringsAsFactors = FALSE
    )
  }))
  
  print(stations_bounds)
  write.csv(stations_bounds, "ub_stations_bounds.csv", row.names = FALSE)
  cat("\nSaved to ub_stations_bounds.csv\n")
}
