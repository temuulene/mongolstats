library(httr)
library(jsonlite)

# Direct approach: Get all stations in Ulaanbaatar bounds using real API token
# UB coordinates roughly: 47.85-47.95 lat, 106.75-107.05 lng
bounds_url <- "https://api.waqi.info/v2/map/bounds?latlng=47.85,106.75,47.95,107.05&networks=all&token=4498ab3b689ea7d15cd5d9c3fa0f0c06671997c8"

cat("Fetching UB stations using geographic bounds...\n")
response <- GET(bounds_url)
raw_data <- content(response, as = "text")
data <- fromJSON(raw_data)

if (data$status == "ok") {
  cat("Found", length(data$data), "stations in Ulaanbaatar bounds\n\n")
  
  # Extract station info from map bounds
  # The data comes as a list where each element contains station info
  ub_stations <- do.call(rbind, lapply(data$data, function(x) {
    data.frame(
      idx = ifelse(is.null(x$uid), NA, x$uid),
      Station_Name = ifelse(is.null(x$station) || is.null(x$station$name), NA, x$station$name),
      Latitude = as.numeric(ifelse(is.null(x$lat), NA, x$lat)),
      Longitude = as.numeric(ifelse(is.null(x$lon), NA, x$lon)),
      AQI = ifelse(is.null(x$aqi) || x$aqi == "-", NA, as.numeric(x$aqi)),
      stringsAsFactors = FALSE
    )
  }))
  
  # Remove any rows with NA station names
  ub_stations <- ub_stations[!is.na(ub_stations$Station_Name), ]
  
  print(ub_stations)
  write.csv(ub_stations, "ub_stations_api.csv", row.names = FALSE)
  cat("\nSaved to ub_stations_api.csv\n")
  cat("\nNow we need to match these WAQI station names with our NSO station names...\n")
} else {
  cat("Error:", data$message, "\n")
}
