# Convert DMS to Decimal Degrees
# Helper function
dms_to_decimal <- function(degrees, minutes, seconds) {
  degrees + minutes/60 + seconds/3600
}

# Convert the coordinates
coords <- list(
  "32nd Toirog" = c(
    dms_to_decimal(47, 56, 21.6),
    dms_to_decimal(106, 54, 51.6)
  ),
  "Ofitseruudiin ordon" = c(
    dms_to_decimal(47, 54, 59.8),
    dms_to_decimal(106, 58, 21.2)
  ),
  "Kharkhorin market" = c(
    dms_to_decimal(47, 54, 38.1),
    dms_to_decimal(106, 50, 13.6)
  ),
  "Urgakh naran micro district" = c(
    dms_to_decimal(47, 52, 25.6),
    dms_to_decimal(107, 6, 54.1)
  ),
  "Dambdarjaa" = c(
    dms_to_decimal(47, 59, 17.7),
    dms_to_decimal(106, 57, 4.2)
  ),
  "Khailaast" = c(
    dms_to_decimal(47, 57, 48.7),
    dms_to_decimal(106, 53, 38.0)
  ),
  "Tolgoit" = c(
    dms_to_decimal(47, 55, 13.0),
    dms_to_decimal(106, 47, 57.3)
  ),
  "Amgalan" = c(
    dms_to_decimal(47, 54, 22.5),
    dms_to_decimal(107, 0, 59.6)
  ),
  "Tavan buudal" = c(
    dms_to_decimal(47, 57, 16.2),
    dms_to_decimal(106, 54, 53.4)
  ),
  "Bayankhoshuu" = c(
    dms_to_decimal(47, 56, 43.9),
    dms_to_decimal(106, 49, 22.5)
  )
)

# Print results
cat("Converted coordinates:\n\n")
for (name in names(coords)) {
  cat(sprintf('"%s", %.6f, %.6f\n', name, coords[[name]][1], coords[[name]][2]))
}
