
devtools::load_all()
library(dplyr)





ids <- c(
  "DT_NSO_2024_135V01",
  "DT_NSO_2400_015V1",
  "DT_NSO_2300_005V12",
  "DT_NSO_2400_028V1",
  "DT_NSO_2400_005V1"
)


# Check what years are available in each table

# 1. Water Quality
cat("\n=== Water Quality Years ===\n")
water_test <- nso_data("DT_NSO_2300_005V12", list(), labels = "en")
print(unique(water_test$Year_en))

# 2. Dust Days
cat("\n=== Dust Days Structure ===\n")
dust_test <- nso_data("DT_NSO_2400_028V1", list(), labels = "en")
print(names(dust_test))
print(head(dust_test$Month_en, 20))

# 3. Air Pollutants
cat("\n=== Air Pollutants Years ===\n")
air_test <- nso_data("DT_NSO_2024_135V01", list(), labels = "en")
print(unique(air_test$Year_en))

# 4. Forest Fires
cat("\n=== Forest Fires Years ===\n")
fire_test <- nso_data("DT_NSO_2400_005V1", list(), labels = "en")
print(unique(fire_test$Year_en))





