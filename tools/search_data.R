library(mongolstats)
library(dplyr)
library(sf)

# Search for tables with "by soum"
cat("Searching for 'by soum' tables...\n")
soum_tables <- nso_itms_search("by soum")
if (nrow(soum_tables) > 0) {
    print(soum_tables |> select(tbl_id, tbl_eng_nm) |> head(20))
} else {
    cat("No tables found with 'by soum'. Trying 'soum'...\n")
    soum_tables <- nso_itms_search("soum")
    print(soum_tables |> select(tbl_id, tbl_eng_nm) |> head(20))
}

# Check boundaries
cat("\nChecking ADM2 boundaries for UB districts...\n")
soums <- mn_boundaries(level = "ADM2")
print(colnames(soums))

# Try to find UB districts
# Assuming there is a column for ADM1 (Aimag/City)
# Let's look at the first few rows to guess the column
print(head(soums))

# Filter for Ulaanbaatar if possible
# Usually UB is ADM1_EN = "Ulaanbaatar" or similar
if ("ADM1_EN" %in% colnames(soums)) {
    ub_districts <- soums |> filter(grepl("Ulaanbaatar", ADM1_EN, ignore.case = TRUE))
    cat("\nPotential UB Districts found:\n")
    print(ub_districts$ADM2_EN)
} else if ("name_en" %in% colnames(soums)) {
    # Fallback if column names are different
    cat("\nColumn names are different. Printing unique values of likely ADM1 column...\n")
}
