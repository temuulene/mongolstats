library(httr)
library(jsonlite)

# Fetch and examine structure
bounds_url <- "https://api.waqi.info/v2/map/bounds?latlng=47.85,106.75,47.95,107.05&networks=all&token=4498ab3b689ea7d15cd5d9c3fa0f0c06671997c8"

cat("Fetching UB stations...\n")
response <- GET(bounds_url)
raw_data <- content(response, as = "text")
data <- fromJSON(raw_data)

cat("Status:", data$status, "\n")
cat("Data structure:\n")
str(data$data)

cat("\n\nRaw JSON sample:\n")
cat(substr(raw_data, 1, 500))

cat("\n\n\nProcessing...\n")  

# The data is likely a vector of simple values, let me check
if (is.list(data$data) && length(data$data) > 0) {
  cat("First element:\n")
  print(data$data[[1]])
}
