#!/usr/bin/env Rscript
# Test JSON auto-unboxing behavior

library(jsonlite)

# Simulate what mongolstats creates
body <- list(
  query = list(
    list(code = "Хүйс", selection = list(filter = "item", values = "0")),
    list(code = "Нас", selection = list(filter = "item", values = "0")),
    list(code = "Он", selection = list(filter = "item", values = "0"))
  ),
  response = list(format = "json")
)

cat("Test 1: Default toJSON (auto_unbox=FALSE)\n")
cat("==========================================\n")
json1 <- toJSON(body, auto_unbox = FALSE, pretty = TRUE)
cat(json1)
cat("\n\n")

cat("Test 2: With auto_unbox=TRUE\n")
cat("=============================\n")
json2 <- toJSON(body, auto_unbox = TRUE, pretty = TRUE)
cat(json2)
cat("\n\n")

cat("Test 3: With explicit arrays\n")
cat("=============================\n")
body2 <- list(
  query = list(
    list(code = "Хүйс", selection = list(filter = "item", values = c("0"))),
    list(code = "Нас", selection = list(filter = "item", values = c("0"))),
    list(code = "Он", selection = list(filter = "item", values = c("0")))
  ),
  response = list(format = "json")
)
json3 <- toJSON(body2, auto_unbox = TRUE, pretty = TRUE)
cat(json3)
cat("\n\n")

cat("Expected format (what curl sends successfully):\n")
cat("================================================\n")
expected <- '{
  "query": [
    {"code": "Хүйс", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Нас", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Он", "selection": {"filter": "item", "values": ["0"]}}
  ],
  "response": {"format": "json"}
}'
cat(expected)
cat("\n\n")

cat("Comparison:\n")
cat("===========\n")
cat("Test 1 (auto_unbox=FALSE): values will be [[\"0\"]] - WRONG!\n")
cat("Test 2 (auto_unbox=TRUE):  values will be \"0\" - WRONG! (needs array)\n")
cat("Test 3 (auto_unbox=TRUE with c()): values will be [\"0\"] - CORRECT!\n")
