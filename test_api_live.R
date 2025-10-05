#!/usr/bin/env Rscript
# Live API test script
# This tests if mongolstats can actually fetch data from the current NSO PXWeb API

library(mongolstats)

cat("=" " ", "=" , "\n", sep="")
cat("Testing mongolstats with live NSO PXWeb API\n")
cat("=" , "", "=", "\n", sep="")

# Enable caching for faster repeated calls
cat("\n1. Enabling cache...\n")
try(nso_cache_enable(), silent = FALSE)

# Test 1: List tables
cat("\n2. Testing nso_itms()...\n")
itms <- try(nso_itms(), silent = FALSE)
if (!inherits(itms, "try-error")) {
  cat(sprintf("   ✓ Found %d tables\n", nrow(itms)))
  if (nrow(itms) > 0) {
    cat("   First 3 tables:\n")
    print(head(itms[, c("tbl_id", "tbl_eng_nm")], 3))
  }
} else {
  cat("   ✗ Failed to list tables\n")
}

# Test 2: Check if DT_NSO_0300_001V2 exists
cat("\n3. Checking for DT_NSO_0300_001V2...\n")
if (!inherits(itms, "try-error") && nrow(itms) > 0) {
  found <- "DT_NSO_0300_001V2" %in% itms$tbl_id
  if (found) {
    cat("   ✓ Table DT_NSO_0300_001V2 found in index\n")
  } else {
    cat("   ✗ Table DT_NSO_0300_001V2 NOT in index - need to rebuild!\n")
  }
}

# Test 3: Get variables for DT_NSO_0300_001V2
cat("\n4. Testing nso_itms_detail('DT_NSO_0300_001V2')...\n")
vars <- try(nso_itms_detail("DT_NSO_0300_001V2"), silent = FALSE)
if (!inherits(vars, "try-error")) {
  cat(sprintf("   ✓ Got metadata with %d rows\n", nrow(vars)))
  cat("   Variables found:\n")
  print(unique(vars$field))
  cat("\n   Sex dimension codes:\n")
  print(vars[vars$field == "Sex", c("itm_id", "scr_eng")])
} else {
  cat("   ✗ Failed to get table metadata\n")
}

# Test 4: Try fetching data using CODES (not labels)
cat("\n5. Testing nso_data() with CODES...\n")
dat <- try(nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(Sex = "0", Age = "0", Year = "0"),  # Using codes!
  labels = "en"
), silent = FALSE)
if (!inherits(dat, "try-error")) {
  cat(sprintf("   ✓ Fetched %d rows\n", nrow(dat)))
  print(head(dat, 3))
} else {
  cat("   ✗ Failed to fetch data\n")
}

# Test 5: Try fetching data using LABELS (as vignettes do)
cat("\n6. Testing nso_data() with LABELS...\n")
dat2 <- try(nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(Sex = "Total", Age = "Total", Year = "2024"),  # Using labels!
  labels = "en"
), silent = FALSE)
if (!inherits(dat2, "try-error")) {
  cat(sprintf("   ✓ Fetched %d rows\n", nrow(dat2)))
  print(head(dat2, 3))
} else {
  cat("   ✗ Failed with labels - label-to-code mapping broken!\n")
}

cat("\n", "=", "", "=", "\n", sep="")
cat("Test complete!\n")
cat("=", "", "=", "\n\n", sep="")
