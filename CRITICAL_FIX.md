# CRITICAL FIX for mongolstats 400 Bad Request Error

## Problem

Getting `HTTP 400 Bad Request` when calling `nso_data()` - even though manual curl tests work perfectly!

## Root Cause Found

**JSON Array Auto-Unboxing Issue**

When R's `jsonlite` (used internally by `httr2::req_body_json()`) serializes single-element vectors, it auto-unboxes them to scalars:

```r
# What we had:
vals <- "0"  # Single string
# Gets serialized as: "values": "0"  ❌ WRONG!

# What PXWeb expects:
# "values": ["0"]  ✓ CORRECT!
```

## Fixes Applied (3 critical changes)

### Fix #1: Response Format Case Sensitivity
**File**: `R/pxweb.R` line 268
```r
# Before:
response = list(format = "JSON")  # ❌ Uppercase

# After:
response = list(format = "json")  # ✓ Lowercase
```

### Fix #2: Prevent Array Auto-Unboxing (CRITICAL!)
**File**: `R/pxweb.R` lines 262, 265

```r
# Before (line 262):
values = vals  # ❌ Single values get unboxed to scalars

# After (line 262):
values = I(as.character(vals))  # ✓ I() prevents unboxing

# Before (line 265):
values = vv  # ❌ Could be unboxed

# After (line 265):
values = I(as.character(vv))  # ✓ Always an array
```

**Why `I()` works**: The `I()` function wraps values with "AsIs" class, telling `jsonlite` to preserve them as arrays even if they contain only one element.

### Fix #3: Better Error Messages
**File**: `R/pxweb.R` lines 304-313

Added detailed HTTP error reporting showing:
- Status code
- First 200 chars of response body
- Full error context

## Testing

### Test Script
Run this to verify the fix:

```r
library(mongolstats)

# Enable verbose mode to see request details
options(mongolstats.verbose = TRUE)

# This should now work!
dat <- nso_data(
  tbl_id = "DT_NSO_0300_001V2",
  selections = list(
    Sex = "Total",
    Age = "Total",
    Year = "2024"
  ),
  labels = "en"
)

print(dat)
```

### Expected Output
```
mongolstats: POST to https://data.1212.mn/api/v1/en/NSO/Population,%20household/1_Population,%20household/DT_NSO_0300_001V2.px
mongolstats: Cookie: rxid=...
mongolstats: Body: {"query":[{"code":"Хүйс","selection":{"filter":"item","values":["0"]}},...

# A tibble: 1 × 4
  Sex   Age   Year  value
  <chr> <chr> <chr> <chr>
1 0     0     0     3441598
```

## Technical Details

### What Was Wrong

```json
// BAD (what was being sent before):
{
  "query": [
    {"code": "Хүйс", "selection": {"filter": "item", "values": "0"}}
  ]
}
```

The API sees `"values": "0"` (a string) instead of `"values": ["0"]` (an array) and returns 400 Bad Request.

### What Is Now Sent

```json
// GOOD (what is sent now):
{
  "query": [
    {"code": "Хүйс", "selection": {"filter": "item", "values": ["0"]}}
  ]
}
```

Even with a single value, it's always an array due to `I()`.

## Verification

### Manual curl test (for comparison):
```bash
curl -X POST "https://data.1212.mn/api/v1/en/NSO/Population%2C%20household/1_Population%2C%20household/DT_NSO_0300_001V2.px" \
  -H "Content-Type: application/json" \
  -H "Cookie: rxid=..." \
  -d '{
    "query": [
      {"code": "Хүйс", "selection": {"filter": "item", "values": ["0"]}},
      {"code": "Нас", "selection": {"filter": "item", "values": ["0"]}},
      {"code": "Он", "selection": {"filter": "item", "values": ["0"]}}
    ],
    "response": {"format": "json"}
  }'
```

Returns: `{"columns":[...], "data":[{"key":["0","0","0"],"values":["3441598"]}]}`  ✓

## Files Modified

1. ✅ `R/pxweb.R`:
   - Line 268: lowercase "json"
   - Line 262: Added `I()` wrapper for user selections
   - Line 265: Added `I()` wrapper for auto-selected values
   - Lines 296-301: Added verbose debug logging
   - Lines 304-313: Enhanced error messages

## Next Steps

1. Test with `source("test_verbose.R")` or rebuild package
2. If working, rebuild vignettes: `pkgdown::build_articles()`
3. Run R CMD check: `rcmdcheck::rcmdcheck()`
4. Commit changes

## Why This Wasn't Caught Earlier

- Manual curl tests used explicit JSON strings with `["0"]`
- R's jsonlite auto-unboxing is "helpful" for most APIs but breaks PXWeb
- Error message was generic "Bad Request" without response body
- The code logic was correct; serialization was the issue

## Summary

**3 lines changed, 3 bugs fixed:**
1. Case sensitivity: `"JSON"` → `"json"`
2. Array preservation: `vals` → `I(vals)`
3. Better errors: Added HTTP response body logging

This should resolve all 400 Bad Request errors!
