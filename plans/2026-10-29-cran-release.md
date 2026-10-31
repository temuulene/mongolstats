# mongolstats 0.4.0 CRAN preparation

## Verified 2026-10-29

- CRAN currently supplies mongolmaps 0.2.0 and mongolstats 0.2.0.
- The candidate requires mongolmaps >= 0.2.0 in Suggests and has no GitHub
  dependency override. The installed mapping dependency is from CRAN.
- All exported functions have documented returns and examples. Examples and
  vignettes restore their settings; the standard PDF manual builds successfully.
- Bundled NSO extracts have explicit source and license attribution.
- Regression tests preceded fixes for clean-session retry evaluation,
  distance-calculation threads, and small managed cache defaults.
- The complete offline suite passes 867 expectations without warnings or
  failures. Coverage is 92.91%; lint, URL, and reviewed spelling checks pass.
- The exact source archive passes --as-cran with remote incoming checks,
  examples, tests, vignettes, and PDF manual: zero errors, warnings, and notes.
- CRAN mongolmaps joins and plots all 22 aimag-level units offline and with
  live NSO population observations.
- Reverse-dependency comparison against CRAN mongolstats 0.2.0 finds no new
  regressions in mongolmaps 0.2.0: 532 assertions pass in both environments.
  The identical incoming-version warning concerns rechecking a released package.
- Source content and commit-metadata audits contain no prohibited references.

## Initial checked source

Filename: `mongolstats_0.4.0.tar.gz`

SHA256: `e3ce8ef6d773966a599f9bdc09e476dc96fd2eaf98fe8291499c04d09f8c02b0`

The same archive was locally checked, reverse-checked, audited, and uploaded
to win-builder for Windows R-devel after explicit maintainer approval.
Windows R-devel (2026-10-28 r90783 ucrt) passed with zero errors, zero warnings,
and one NOTE flagging the valid technical term "tibbles" in DESCRIPTION.
The NOTE is explained in cran-comments.md. Examples, tests, vignettes, and
both reference manuals passed. The remote log is saved with the release packet.

Final release-packet review: 2026-10-30.

At this preparation checkpoint, no commit, remote push, CRAN submission, or
website publication had been performed. Subsequent publication status is
recorded with the release packet.

## Final selected source, 2026-10-30

The archive was rebuilt after qualifying a test helper with its namespace to
pass lint in a clean session. Package R code is unchanged. Final verification
results and submission status are recorded with the release packet.

Filename: `mongolstats_0.4.0.tar.gz`

SHA256: `dd6b43d46adfb34ae7c3c326bbd6b7fe3d67b22e4de6b9dda23fb13b466be264`
