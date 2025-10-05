#!/usr/bin/env Rscript
# Test with verbose logging to see exactly what's being sent

library(mongolstats)

# Enable ALL debug output
options(mongolstats.verbose = TRUE)
options(mongolstats.timeout = 60)
options(mongolstats.retry_tries = 1L)  # Only try once for faster debugging

cat("\n")
cat("==================================================================\n")
cat("VERBOSE TEST - You will see exactly what's being sent\n")
cat("==================================================================\n\n")

# Try the simplest possible request
cat("Attempting: nso_data('DT_NSO_0300_001V2', list(Sex='Total', Age='Total', Year='2024'))\n\n")

result <- tryCatch({
  dat <- nso_data(
    tbl_id = "DT_NSO_0300_001V2",
    selections = list(
      Sex = "Total",
      Age = "Total",
      Year = "2024"
    ),
    labels = "en"
  )
  cat("\n✓ SUCCESS!\n")
  cat(sprintf("Got %d rows\n", nrow(dat)))
  print(head(dat))
  dat
}, error = function(e) {
  cat("\n✗ FAILED\n")
  cat("Error message:\n")
  cat(conditionMessage(e), "\n\n")
  cat("Error class:", paste(class(e), collapse=", "), "\n")

  # Print call stack for debugging
  cat("\nCall stack:\n")
  print(sys.calls())

  e
})

cat("\n==================================================================\n")
cat("If you see 'HTTP 400 Bad Request', copy the Body: line above\n")
cat("and test it with curl to see if the JSON is malformed.\n")
cat("==================================================================\n")
