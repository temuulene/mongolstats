## Test environments
- local Windows 11 install, R 4.6.1
- GitHub Actions (ubuntu-latest, windows-latest, macOS-latest), R release and devel

## R CMD check results
0 errors ✔ | 0 warnings ✔ | 0 notes ✔

- Resubmission after fixing CRAN check errors

## Package purpose
mongolstats provides convenient access to Mongolia's National Statistics Office (NSO) data through their PXWeb API, with additional utilities for working with administrative boundaries from GeoBoundaries.

## Acronyms in DESCRIPTION
- NSO: National Statistics Office (of Mongolia)
- PXWeb: PC-Axis Web API (standard format for statistical data)
- API: Application Programming Interface

## Examples
Network-dependent examples are guarded with
`@examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()`,
so they never contact the live PXWeb API during CRAN checks and only run
locally and on CI where NOT_CRAN is set. The one example that crawls the full
table catalogue (`nso_rebuild_px_index()`) is wrapped in `\dontrun{}` because
it takes several minutes.

## Reverse dependencies
There are no reverse dependencies to check.

