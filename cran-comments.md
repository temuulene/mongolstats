# CRAN submission comments for mongolstats

## Test environments
- GitHub Actions: ubuntu-latest (R-CMD-check)
- Local Windows: R 4.5.x

## R CMD check results
- 0 errors | 0 warnings | 0 notes (expected after passing CI)

## Reverse dependencies
- None

## Additional notes
- This package performs HTTP requests to data.1212.mn (PXWeb API) and geoboundaries.org. Network-dependent tests are skipped on CRAN/offline.
- Vignettes require Pandoc; pkgdown site is built in CI.
