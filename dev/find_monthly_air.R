
library(mongolstats)
library(dplyr)


# Search for AIR generally
cat("Searching for AIR...\n")
res <- nso_search("AIR")
print(res %>% select(tbl_id, tbl_eng_nm))

# Based on previous knowledge, DT_NSO_2400_015V2 is likely the monthly one
# Let's try to fetch station list from it
cat("\nFetching station list from DT_NSO_2400_015V2...\n")
tryCatch({
  # Get metadata to find station dimension
  meta <- nso_table_meta("DT_NSO_2400_015V2")
  print(meta)
  


  # Fetch pollutant values
  # Dimension name from previous output: "Indicator of air pollution"
  pollutants <- nso_dim_values("DT_NSO_2400_015V2", "Indicator of air pollution", labels = "en")
  print(pollutants)
}, error = function(e) {
  cat("Error fetching pollutants:", e$message, "\n")
})



