# mongolstats Debugging Findings

## Issue Summary

Vignettes failing with error: `PXWeb request failed with HTTP error`

## Root Causes Identified

### ✅ RESOLVED: Table Index is Up-to-Date
- **Finding**: DT_NSO_0300_001V2 EXISTS in `inst/extdata/px_index.json` (1183 entries total)
- **Status**: Not an issue

### ✅ VERIFIED: PXWeb API is Accessible
- **Finding**: API at https://data.1212.mn/api/v1 is responding correctly
- **Test**: Successfully retrieved metadata for DT_NSO_0300_001V2
- **Status**: Not an issue

### ⚠️ CRITICAL: PXWeb Variable Codes are in Mongolian
- **Finding**: Variable `code` field uses Mongolian Cyrillic, not English
  - Example: `code: "Хүйс"` (Mongolian) vs `text: "Sex"` (English)
- **Impact**: POST queries MUST use Mongolian codes in query JSON
- **Package Status**: Code at `R/pxweb.R:262` correctly uses `v$code` (Mongolian)
- **Conclusion**: This is CORRECT behavior, not a bug

### ✅ VERIFIED: Label-to-Code Mapping Works
- **Finding**: Code at lines 235-245 correctly:
  1. Matches user selections by English `text` field
  2. Maps label values to codes via `valueTexts` → `values`
  3. Uses Mongolian `code` in POST query
- **Status**: Logic is correct

### ✅ VERIFIED: Cookie Seeding Works
- **Finding**: Lines 220-229 correctly extract `rxid` cookie via GET request
- **Test**: Manual curl confirmed cookie extraction works
- **Status**: Implementation is correct

### ⚠️ POTENTIAL ISSUE: POST Request Format
- **Finding**: Manual POST test with correct Mongolian codes SUCCEEDS:
  ```bash
  curl POST with {"code": "Хүйс", ...} → Returns JSON data ✓
  ```
- **Question**: Why might R package POST fail if manual test works?

## Successful Manual Test

```bash
URL="https://data.1212.mn/api/v1/en/NSO/Population,%20household/1_Population,%20household/DT_NSO_0300_001V2.px"

QUERY='{
  "query": [
    {"code": "Хүйс", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Нас", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Он", "selection": {"filter": "item", "values": ["0"]}}
  ],
  "response": {"format": "json"}
}'

curl -X POST "$URL" -H "Content-Type: application/json" -H "Cookie: rxid=..." -d "$QUERY"
```

**Result**: `{"columns":[...], "data":[{"key":["0","0","0"],"values":["3441598"]}]}`

✅ Returns population data successfully!

## Table Metadata Structure

**Table**: DT_NSO_0300_001V2 (RESIDENT POPULATION IN MONGOLIA)

**Variables**:
1. **Sex** (Хүйс)
   - Codes: `["0", "1", "2"]`
   - Labels: `["Total", "Male", "Female"]`

2. **Age** (Нас)
   - Codes: `["0", "1", ..., "87"]`
   - Labels: `["Total", "0", "1", ..., "85+"]`

3. **Year** (Он)
   - Codes: `["0", "1", ..., "24"]`
   - Labels: `["2024", "2023", ..., "2000"]`

## Recommended Next Steps

### 1. Add Better Error Logging
Update `R/pxweb.R` to log:
- Exact URL being POSTed
- Full request body
- Full response body (not just status code)

### 2. Test with R Package Directly
Run `debug_full_flow.R` to see actual error from R

### 3. Check Response Format
Line 268: `response = list(format = "JSON")` uses uppercase "JSON"
- Manual test showed lowercase `"json"` works
- Try changing to lowercase

### 4. Verify URL Encoding
The px_path contains special characters:
- `"Population, household/1_Population, household"`
- Ensure comma and space are properly encoded

### 5. Consider Response Format Options
Test if API accepts:
- `"json"` (lowercase)
- `"JSON"` (uppercase)
- `"json-stat2"`
- No format specified

## Files to Update

1. **R/pxweb.R**
   - Line 268: Try lowercase `"json"` instead of `"JSON"`
   - Lines 296-313: Add detailed error logging

2. **Vignettes**
   - Once POST working, verify all examples use valid tables
   - Add error handling with informative messages

3. **Tests**
   - Add integration tests with real API calls
   - Test label→code mapping explicitly
