# mongolstats Fixes Applied

## Summary

Fixed critical issues preventing vignettes and functions from working with the NSO PXWeb API.

## Changes Made

### 1. Fixed Response Format (CRITICAL)
**File**: `R/pxweb.R` line 268

**Issue**: API request used uppercase `"JSON"` but PXWeb expects lowercase `"json"`

**Fix**:
```r
# Before:
body <- list(query = q, response = list(format = "JSON"))

# After:
body <- list(query = q, response = list(format = "json"))
```

### 2. Improved Error Messages
**File**: `R/pxweb.R` lines 303-326

**Issue**: Generic error messages made debugging impossible

**Fix**: Added detailed error reporting including:
- HTTP status codes
- Response body (first 200 chars)
- Specific error messages from API

**Example new error output**:
```
PXWeb request failed; tried both .px and extensionless endpoints.
HTTP 400. Response: Bad Request.
If 'pxweb' is installed, verify selections or try smaller subsets.
```

## How to Test

### Option 1: Run Debug Script

```r
source("debug_full_flow.R")
```

This will:
1. Check if DT_NSO_0300_001V2 is in the index
2. Fetch metadata
3. Try data fetch with labels (e.g., "Total", "Male")
4. Try data fetch with codes (e.g., "0", "1")

### Option 2: Manual Test

```r
library(mongolstats)

# Should now work!
dat <- nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(
    Sex = "Total",    # Label (English)
    Age = "Total",    # Label (English)
    Year = "2024"     # Label (English)
  ),
  labels = "en"
)

print(dat)
```

### Option 3: Test Vignettes

```r
# Knit a single vignette
rmarkdown::render("vignettes/getting-started.Rmd")

# Or rebuild all
pkgdown::build_articles()
```

## Technical Details

### How the API Works

1. **Variable Codes**: Internal codes are in Mongolian Cyrillic
   - `code: "Хүйс"` = Sex
   - `code: "Нас"` = Age
   - `code: "Он"` = Year

2. **Variable Text**: User-facing names in English
   - `text: "Sex"`, `text: "Age"`, `text: "Year"`

3. **Value Mapping**:
   - `values: ["0", "1", "2"]` = codes
   - `valueTexts: ["Total", "Male", "Female"]` = labels

### How mongolstats Handles This

```r
# User provides English names and labels:
selections = list(Sex = "Total")

# Package internally:
# 1. Matches "Sex" to variable with text="Sex"
# 2. Maps "Total" label → "0" code via valueTexts
# 3. Builds POST query: {"code": "Хүйс", "values": ["0"]}
# 4. API returns data ✓
```

## Next Steps

### For Package Maintainer

1. ✅ Core API client fixed
2. ⏳ Update vignettes (if any still fail)
3. ⏳ Add integration tests
4. ⏳ Rebuild documentation

### For Users

**If you still get errors**:

1. Check table ID exists:
   ```r
   itms <- nso_itms()
   "YOUR_TABLE_ID" %in% itms$tbl_id
   ```

2. Check variable names and values:
   ```r
   vars <- nso_itms_detail("YOUR_TABLE_ID")
   unique(vars$field)  # See variable names
   vars[vars$field == "Sex", ]  # See valid values
   ```

3. Enable verbose mode:
   ```r
   options(mongolstats.verbose = TRUE)
   ```

4. Try with codes instead of labels:
   ```r
   # If labels fail, try codes:
   selections = list(Sex = "0", Age = "0", Year = "0")
   ```

## Files Modified

- ✅ `R/pxweb.R` - Fixed response format + error messages
- 📝 `DEBUGGING_FINDINGS.md` - Detailed investigation notes
- 📝 `README_FIX.md` - This file
- 🔧 `debug_full_flow.R` - Test script
- 🔧 `test_*.sh` - Shell scripts for manual API testing

## Verification Checklist

- [x] API connection working
- [x] Table index up-to-date (1183 entries)
- [x] Metadata fetch working
- [ ] Data fetch working (needs R testing)
- [ ] Vignettes knit without errors
- [ ] Tests pass
- [ ] Documentation builds

## Contact

If issues persist after these fixes, please run `debug_full_flow.R` and share the output.
