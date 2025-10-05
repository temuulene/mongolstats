# Phase 7: Rebuild Documentation and Verification Instructions

Since R/Rscript is not available in the WSL environment, please run these commands in RStudio to complete Phase 7.

## Steps to Complete

### 1. Generate roxygen2 documentation

```r
roxygen2::roxygenise()
```

This will update all `.Rd` files in `man/` and regenerate `NAMESPACE` based on roxygen2 comments in R source files.

### 2. Run R CMD check

```r
rcmdcheck::rcmdcheck(
  args = c("--no-manual", "--as-cran"),
  error_on = "warning"
)
```

This performs a comprehensive package check. Expected outcome: 0 errors, 0 warnings, 0 notes.

**Common issues to watch for:**
- Undeclared imports (should all be fixed)
- Documentation mismatches
- Example errors
- Test failures

### 3. Run integration tests

```r
# Run all tests
devtools::test()

# Or specifically run integration tests
testthat::test_file("tests/testthat/test-integration.R")
```

This will test:
- Basic data fetching with valid selections
- Label-based vs code-based selections
- Multiple value selections
- Period extraction
- Batch operations (nso_package)
- Label-to-code mapping equivalence

### 4. Build vignettes

```r
pkgdown::build_articles()
```

This builds individual vignettes. Check output for any knitting errors in:
- `vignettes/getting-started.Rmd`
- `vignettes/discovery.Rmd`
- `vignettes/mapping.Rmd`

### 5. Build complete pkgdown site

```r
pkgdown::build_site(preview = FALSE, install = FALSE)
```

This rebuilds the entire documentation site in `docs/`.

### 6. Preview the site locally

```r
pkgdown::build_site(preview = TRUE)
```

Or manually open `docs/index.html` in a browser to verify:
- Function reference pages render correctly
- Vignettes display without errors
- Examples run successfully
- All links work

### 7. Final verification checklist

- [ ] `roxygen2::roxygenise()` ran without errors
- [ ] `rcmdcheck::rcmdcheck()` shows 0 errors, 0 warnings, 0 notes
- [ ] All integration tests pass
- [ ] Vignettes build without errors
- [ ] pkgdown site builds successfully
- [ ] Site preview shows all content correctly
- [ ] No broken links in documentation

## Files Modified (Summary)

### Core fixes:
- **R/pxweb.R** (lines 262, 265, 268, 296-313, 343)
  - Changed response format to lowercase "json"
  - Added I() wrapper to prevent JSON auto-unboxing
  - Enhanced error messages with debug logging
  - Fixed response parsing to use Filter() instead of data frame subsetting

### Documentation fixes:
- **vignettes/getting-started.Rmd** (lines 77-95)
  - Corrected Sex codes from "T"/"M"/"F" to "0"/"1"/"2"
- **vignettes/mapping.Rmd** (lines 46-54)
  - Fixed syntax error with extra ```{r

### New tests:
- **tests/testthat/test-integration.R**
  - 7 comprehensive integration tests
  - Tests label-based and code-based selections
  - Tests multiple values and batch operations
  - Tests label-to-code mapping equivalence

## What to Do After Verification

Once all checks pass:

1. Clean up debug files (optional):
   ```bash
   rm test_*.sh test_*.R debug_*.R rebuild_index.R add_missing_table.py
   ```

2. Stage the important changes:
   ```bash
   git add R/pxweb.R
   git add vignettes/getting-started.Rmd vignettes/mapping.Rmd
   git add tests/testthat/test-integration.R
   git add NAMESPACE man/  # if roxygen updated these
   ```

3. Commit with a descriptive message

4. Push to GitHub

5. Update pkgdown site if needed

## Expected Outcomes

After completing these steps:
- Package passes R CMD check with no issues
- All vignettes knit successfully
- Integration tests validate core functionality
- Documentation is up to date
- pkgdown site displays correctly

## Troubleshooting

If you encounter errors during any step, check:
- Internet connectivity (tests require API access)
- API availability at data.1212.mn
- Correct versions of dependencies
- Clear any cached objects with `devtools::clean_dll()`

If tests fail intermittently, it may be due to:
- API rate limiting
- Network timeouts
- Temporary API unavailability

The integration tests use `skip_on_cran()` and `skip_if_offline()` to handle these gracefully.
