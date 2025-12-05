library(mongolstats)
library(dplyr)
library(ggplot2)

nso_options(mongolstats.lang = "en")

ub_name_map <- c(
    "Baganuur" = "Baganuur",
    "Bagaxangai" = "Bagakhangai",
    "Bayangol" = "Bayangol",
    "Bayanzu'rx" = "Bayanzurkh",
    "Chingeltei" = "Chingeltei",
    "Nalaix" = "Nalaikh",
    "Songinoxairxan" = "Songinokhairkhan",
    "Su'xbaatar" = "Sukhbaatar",
    "Xan-Uul" = "Khan-Uul"
)

get_ub_data <- function(tbl_id, ...) {
    df <- nso_data(tbl_id, labels = "en", ...)
    df |>
        filter(grepl("^511", Region)) |>
        mutate(Region_clean = trimws(Region_en)) |>
        filter(Region_clean %in% ub_name_map) |>
        select(-Region_clean)
}

print("--- 1. POPULATION TREND DATA ---")
# Fetch historical population data
pop_trend <- get_ub_data("DT_NSO_0300_002V4", 
                         selections = list(Year = as.character(2013:2024)))
print(head(pop_trend))
print("Year mapping:")
print(unique(pop_trend[, c("Year", "Year_en")]))

print("--- 2. RESPIRATORY MORTALITY DATA ---")
# Get Respiratory Deaths
resp_meta <- nso_dim_values("DT_NSO_2100_027V1", "Indicator", labels = "en")
resp_code <- resp_meta |> 
    filter(grepl("respiratory", label_en, ignore.case = TRUE)) |> 
    pull(code)
print(paste("Resp Code:", resp_code))

resp_deaths <- get_ub_data("DT_NSO_2100_027V1", 
                           selections = list(Indicator = resp_code, Year = "2024"))
print("Respiratory Deaths 2024:")
print(resp_deaths)

print("--- 3. IMR DATA ---")
imr_data <- get_ub_data("DT_NSO_2100_015V2", 
                        selections = list(Year = "2024"))
print("IMR Data 2024:")
print(imr_data)
