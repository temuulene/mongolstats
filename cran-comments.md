## Test environments
- local Windows 11 install, R 4.5.2
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
Network-dependent examples use `@examplesIf curl::has_internet()` to ensure they only run when internet is available and skip gracefully on CRAN's offline test environments.

## Reverse dependencies
There are no reverse dependencies to check.

