#!/usr/bin/env Rscript
# Rebuild PXWeb index
# WARNING: This takes 10-15 minutes as it crawls the entire API tree

library(mongolstats)

cat("\n")
cat("==================================================================\n")
cat("Rebuilding PXWeb Index for data.1212.mn\n")
cat("==================================================================\n")
cat("\n")
cat("This will crawl the entire PXWeb API tree at data.1212.mn.\n")
cat("Expected time: 10-15 minutes\n")
cat("\n")

# Enable verbose mode to see progress
options(mongolstats.verbose = TRUE)
options(mongolstats.timeout = 60)
options(mongolstats.retry_tries = 5L)

start_time <- Sys.time()

cat("Starting crawl at:", format(start_time), "\n\n")

# Rebuild the index
tryCatch({
  idx <- nso_rebuild_px_index(
    path = file.path("inst", "extdata", "px_index.json"),
    write = TRUE
  )

  end_time <- Sys.time()
  elapsed <- difftime(end_time, start_time, units = "mins")

  cat("\n")
  cat("==================================================================\n")
  cat("SUCCESS!\n")
  cat("==================================================================\n")
  cat(sprintf("Tables found: %d\n", nrow(idx)))
  cat(sprintf("Time elapsed: %.2f minutes\n", as.numeric(elapsed)))
  cat(sprintf("Output file: inst/extdata/px_index.json\n"))
  cat(sprintf("File size: %.2f MB\n", file.size("inst/extdata/px_index.json") / 1024^2))
  cat("\n")

  # Check if our test table is there
  if ("DT_NSO_0300_001V2" %in% idx$tbl_id) {
    cat("✓ DT_NSO_0300_001V2 found in new index\n")
  } else {
    cat("✗ WARNING: DT_NSO_0300_001V2 still not found!\n")
  }

  cat("\n")

}, error = function(e) {
  cat("\n")
  cat("==================================================================\n")
  cat("ERROR!\n")
  cat("==================================================================\n")
  cat("Message:", conditionMessage(e), "\n")
  cat("\n")
  stop(e)
})
