#!/usr/bin/env Rscript
# Debug the full mongolstats flow

library(mongolstats)

# Enable verbose logging
options(mongolstats.verbose = TRUE)
options(mongolstats.timeout = 60)
options(mongolstats.retry_tries = 3L)

cat("\n")
cat("=" * 70, "\n", sep="")
cat("DEBUGGING mongolstats nso_data() flow\n")
cat("=" * 70, "\n\n", sep="")

tbl_id <- "DT_NSO_0300_001V2"

# Step 1: Check if table is in index
cat("Step 1: Check table in index\n")
cat("-" * 40, "\n", sep="")
itms <- nso_itms()
found <- tbl_id %in% itms$tbl_id
cat(sprintf("Table %s in index: %s\n", tbl_id, found))
if (found) {
  entry <- itms[itms$tbl_id == tbl_id, ]
  cat("Entry:\n")
  print(entry[1, c("tbl_id", "tbl_eng_nm", "px_path", "px_file")])
}
cat("\n")

# Step 2: Get metadata
cat("Step 2: Get metadata\n")
cat("-" * 40, "\n", sep="")
vars <- nso_itms_detail(tbl_id)
cat(sprintf("Got %d rows of metadata\n", nrow(vars)))
cat("Variables:\n")
print(unique(vars$field))
cat("\nSex dimension:\n")
print(vars[vars$field == "Sex", c("field", "itm_id", "scr_eng")])
cat("\n")

# Step 3: Try data fetch with LABELS (what vignettes do)
cat("Step 3: Fetch data using LABELS\n")
cat("-" * 40, "\n", sep="")
cat("Calling: nso_data(tbl_id, selections=list(Sex='Total', Age='Total', Year='2024'))\n\n")

result <- tryCatch({
  dat <- nso_data(
    tbl_id = tbl_id,
    selections = list(Sex = "Total", Age = "Total", Year = "2024"),
    labels = "en"
  )
  cat(sprintf("✓ SUCCESS! Got %d rows\n", nrow(dat)))
  print(head(dat, 3))
  dat
}, error = function(e) {
  cat("✗ ERROR!\n")
  cat("Message:", conditionMessage(e), "\n")
  cat("Class:", paste(class(e), collapse=", "), "\n")
  e
})

cat("\n")

# Step 4: Try data fetch with CODES (what should work)
cat("Step 4: Fetch data using CODES\n")
cat("-" * 40, "\n", sep="")
cat("Calling: nso_data(tbl_id, selections=list(Sex='0', Age='0', Year='0'))\n\n")

result2 <- tryCatch({
  dat2 <- nso_data(
    tbl_id = tbl_id,
    selections = list(Sex = "0", Age = "0", Year = "0"),
    labels = "en"
  )
  cat(sprintf("✓ SUCCESS! Got %d rows\n", nrow(dat2)))
  print(head(dat2, 3))
  dat2
}, error = function(e) {
  cat("✗ ERROR!\n")
  cat("Message:", conditionMessage(e), "\n")
  cat("Class:", paste(class(e), collapse=", "), "\n")
  e
})

cat("\n")
cat("=" * 70, "\n", sep="")
cat("DONE\n")
cat("=" * 70, "\n", sep="")
