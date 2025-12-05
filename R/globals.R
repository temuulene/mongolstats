# Global variables used in NSE contexts (e.g., dplyr, ggplot2)
# These are declared to satisfy R CMD check --as-cran
utils::globalVariables(c(
  # Columns frequently used in dplyr pipelines
  "value",
  "Region",
  "Region_en",
  "Month_en",
  "Type",
  "shapeName",
  "name_std",
  "match_std",
  "dist",
  "px_path",
  "list_id",
  "tbl_id",
  "tbl_eng_nm",
  "tbl_nm",
  "label_en"
))
