## Release

This updates the CRAN release 0.2.0 to 0.4.0, including the changes developed
under the intermediate 0.3.0 version. Time columns now use stable period labels,
period discovery returns a tibble, and parallel fetching uses mirai. The older
boundary helpers are deprecated in favour of mongolmaps. New interfaces cover
source provenance and the public NSO data and metadata portals; see NEWS.md.

mongolmaps (>= 0.2.0) is now available from CRAN and remains in Suggests. The
GitHub Remotes override has been removed. The maintainer and MIT software
license are unchanged. Bundled NSO material now has explicit source, copyright,
and applicable-license attribution in inst/COPYRIGHTS.

## Check results

Local Windows 11 x86_64, R 4.6.1, UTF-8, with CRAN mongolmaps 0.2.0:

0 errors | 0 warnings | 0 notes

The exact source archive was checked with --as-cran and remote incoming checks,
including the PDF reference manual, examples, tests, and vignette rebuilding.
URL and spelling checks pass. The complete offline suite has 867 passing
expectations; coverage is 92.91%.

The same source archive was checked by win-builder on Windows Server 2022,
R Under development (2026-10-28 r90783 ucrt), UTF-8:

0 errors | 0 warnings | 1 note

The sole NOTE flags "tibbles" in DESCRIPTION as possibly misspelled. This is
the standard plural of tibble, the data-frame class returned by the package.
Installation, examples, tests, vignette rebuilding, and the PDF and HTML
reference manuals all passed.

## Reverse dependencies

The only CRAN reverse dependency is mongolmaps (reverse Suggests). Its CRAN
0.2.0 source was checked in isolated libraries against both CRAN mongolstats
0.2.0 and this candidate. Both runs passed 532 assertions, with 49 upstream
CRAN-guarded skips, and showed no new regressions. Both had the same incoming
version warning from rechecking an already released mongolmaps version;
there were no other errors, warnings, or notes.

## External services

Live API examples and integration tests are guarded off on CRAN. Core behavior
is tested with offline and recorded-response tests. A separately run live
canary and population-map check also passed. Metadata fixtures describe public
catalogue records and collection forms, not underlying respondent records.
