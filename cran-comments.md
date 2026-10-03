## Test environments
- local Windows 11 install, R 4.6.1
- GitHub Actions (ubuntu-latest, windows-latest, macOS-latest), R release and devel

## R CMD check results
0 errors ✔ | 0 warnings ✔ | 0 notes ✔

- This is an update release (0.2.0 -> 0.3.0). Periods are now returned by
  label, tables that the National Statistics Office moves within its
  catalogue are located automatically, large requests are split to respect
  the server's limits, and the 'geoBoundaries' helpers are deprecated in
  favour of the companion package 'mongolmaps' (in Suggests). 'sf' moved
  from Imports to Suggests. See NEWS.md for details.

## Package purpose
mongolstats provides convenient access to Mongolia's National Statistics Office (NSO) data through their PXWeb API.

## Acronyms in DESCRIPTION
- NSO: National Statistics Office (of Mongolia)
- PXWeb: PC-Axis Web API (standard format for statistical data)
- API: Application Programming Interface

## Examples
Network-dependent examples are guarded with
`@examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()`,
so they never contact the live PXWeb API during CRAN checks and only run
locally and on CI where NOT_CRAN is set. Examples of the table catalogue
(`nso_tables()`, `nso_search()`) use the index bundled with the package and
need no network access. The one example that crawls the full table
catalogue (`nso_rebuild_px_index()`) is wrapped in `\dontrun{}` because it
takes several minutes.

## Reverse dependencies
There are no reverse dependencies on CRAN. The companion package
'mongolmaps' suggests mongolstats.
