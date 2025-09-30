# Contributing to mongolstats

Thanks for your interest in contributing! This project welcomes issues, ideas, and pull requests.

## Setup

- Requires R (>= 4.1). Recommended: RStudio for vignette building (bundles Pandoc).
- Install dependencies as you go; smoke/test scripts handle most of it.

## Development workflow

- Explore functions in `R/` and run a quick smoke test:
  - `Rscript tools/smoke.R`
- Run unit tests:
  - `Rscript -e "invisible(lapply(list.files('R', full.names=TRUE), source)); library(testthat); test_dir('tests/testthat', reporter='summary')"`
- Build the pkgdown site locally (requires Pandoc or RStudio):
  - `Rscript tools/build_site.R`

## Pull requests

- Keep changes focused and tidyverse-styled.
- Add tests for new behavior where feasible.
- Update README or vignettes if user-facing behavior changes.

## Code of Conduct

By participating, you agree to abide by the Code of Conduct in CODE_OF_CONDUCT.md.

