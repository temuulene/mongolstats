# Analytical vignette revisions

## Changes

- Added inspectable teaching helpers in `inst/examples/analysis-helpers.R` for
  strict count aggregation, expected calendar grids, validated joins, age
  standardisation, conditional Poisson intervals and conservative funnel flags.
- Updated all seven vignette sources. Unknown observations remain unknown;
  numerator and denominator periods are paired; incomplete estimates are
  identified rather than presented as zero or within screening limits.
- Revised cancer, mortality, geographic and environmental interpretation.
  Added pandemic sensitivities, count-model diagnostics, dated reference values,
  source/fallback labels, coverage tables and enduring provenance exports.
- Added regression checks for incomplete age/period/geographic data, invalid
  denominators, observation gaps, hospital subsets, explicit fallback behaviour,
  a January mortality peak and an entirely unobserved dust-year comparison.
- Website builds retain warnings in a maintainer log. The existing weekly NSO
  canary also runs the analytical articles and retains outputs without deployment.

## Verification

- Package and recorded-response tests pass; live integration tests skip offline.
- New analytical regressions and website safeguard tests pass.
- All seven sources knit in nonexecuting package-check mode without network use.
- Bundled air calculations and figures execute, with historical source labels
  and missing percentage counts visible. Updated figures were visually reviewed.
- The full mortality article executes with constructed data and changes its
  reported peak to January. Empty complete-year dust results render safely.
- Lint and the package source build pass.

## Remaining source verification

Direct NSO requests remain blocked by this session's network environment. A fresh
end-to-end live website render and confirmation of source definitions, boundary
vintages, monitoring inventories and revised standard details remain pending.
These uncertainties are explicitly described in the tutorials rather than filled
with assumed definitions or values. Full installed-package checking also needs
the check subprocess to discover the available dependency library.
