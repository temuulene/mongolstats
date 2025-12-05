# Station Matching Summary
# NSO Stations vs. WAQI Stations

## Already Matched (6 stations):
# NSO Station                    -> WAQI Station                                  Lat       Lng
# -----------------------------------------------------------------------------------------
# Misheel-Expo center            -> Misheel Expo, Ulaanbaatar (Мишээл экспо)    47.89428  106.8825
# 1st micro district             -> 1-р хороолол                                 47.91798  106.8481
# Nisekh                         -> Nisekh, Ulaanbaatar (Нисэх)                 47.86394  106.7791
# Sharkhad                       -> Шархад                                       47.93375  107.0103
# 100 ail                        -> 100 Ail, Ulaanbaatar                         47.93291  106.9214

## UNMATCHED NSO Stations (12 stations need matching):
# 1.  West crossroad
# 2.  13th micro district
# 3.  32nd Toirog
# 4.  Ofitseruudiin ordon
# 5.  Kharkhorin market
# 6.  Urgakh naran micro district
# 7.  Dambdarjaa
# 8.  Khailaast
# 9.  Tolgoit
# 10. Zuragt
# 11. Amgalan
# 12. Tavan buudal
# 13. Bayankhoshuu

## Available WAQI Stations (7 unmatched):
# A. Baruun 4 zam - 2                                         47.91576  106.8940
# B. M.N.B., Ulaanbaatar (МҮОНРТ)                            47.92973  106.8886
# C. Mongol Gazar, Ulaanbaatar (Монгол газар)                47.90354  106.8507
# D. Богд хааны ордон музей                                   47.89694  106.9064
# E. Ulaanbaatar US Embassy, Ulaanbaatar (АНУ-ын ЭСЯ)       47.92839  106.9295
# F. Bukhiin Urguu, Ulaanbaatar                              47.91761  106.9374
# G. Яармаг                                                   47.86834  106.8354

# NOTES:
# - NSO has 18 stations total (6 matched, 12 unmatched)
# - WAQI has 12 stations total (6 matched, 6 unmatched) - but we have 1 extra in the list
# - Need to match the 12 NSO stations to the 7 WAQI stations (some NSO stations may not have WAQI equivalents)

cat("
================================================================================
STATION MATCHING NEEDED
================================================================================

ALREADY MATCHED (6):
")
cat("  ✓ Misheel-Expo center       = Misheel Expo, Ulaanbaatar\n")
cat("  ✓ 1st micro district        = 1-р хороолол\n")
cat("  ✓ Nisekh                    = Nisekh, Ulaanbaatar\n")
cat("  ✓ Sharkhad                  = Шархад\n")
cat("  ✓ 100 ail                   = 100 Ail, Ulaanbaatar\n")

cat("\n================================================================================\n")
cat("UNMATCHED NSO STATIONS (12):\n")
cat("================================================================================\n\n")

nso_unmatched <- c(
  "1.  West crossroad",
  "2.  13th micro district",
  "3.  32nd Toirog",
  "4.  Ofitseruudiin ordon",
  "5.  Kharkhorin market",
  "6.  Urgakh naran micro district",
  "7.  Dambdarjaa",
  "8.  Khailaast",
  "9.  Tolgoit",
  "10. Zuragt",
  "11. Amgalan",
  "12. Tavan buudal",
  "13. Bayankhoshuu"
)
cat(paste(nso_unmatched, collapse = "\n"), "\n")

cat("\n================================================================================\n")
cat("AVAILABLE WAQI STATIONS (7):\n")
cat("================================================================================\n\n")

waqi_unmatched <- c(
  "A. Baruun 4 zam - 2                             (47.91576, 106.8940)",
  "B. M.N.B., Ulaanbaatar (МҮОНРТ)                (47.92973, 106.8886)",
  "C. Mongol Gazar, Ulaanbaatar (Монгол газар)    (47.90354, 106.8507)",
  "D. Богд хааны ордон музей                       (47.89694, 106.9064)",
  "E. Ulaanbaatar US Embassy (АНУ-ын ЭСЯ)        (47.92839, 106.9295)",
  "F. Bukhiin Urguu, Ulaanbaatar                  (47.91761, 106.9374)",
  "G. Яармаг                                       (47.86834, 106.8354)"
)
cat(paste(waqi_unmatched, collapse = "\n"), "\n")

cat("\n================================================================================\n")
cat("PLEASE MATCH:\n")
cat("================================================================================\n")
cat("For each NSO station (1-13), tell me which WAQI station (A-G) it matches.\n")
cat("If a station has no match, say 'no match'.\n")
cat("\nExample: 1=A, 2=B, 3=no match, etc.\n")
cat("================================================================================\n")
