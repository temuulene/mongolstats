# Repository Guidelines

## Project Structure & Modules
- R package layout:
  - Source: `R/` (exported functions use `nso_*` and `mn_*`; internal helpers start with `.`)
  - Data/docs: `inst/extdata/px_index.json`, `man/`, `vignettes/`
  - Tests: `tests/testthat/`
  - Metadata: `DESCRIPTION`, `NAMESPACE`, `_pkgdown.yml`
  - Tooling: `tools/` (build, check, site)

## Build, Test, and Dev Commands
- Quick smoke test: `Rscript tools/smoke.R`
- Run unit tests: `Rscript -e "invisible(lapply(list.files('R', full.names=TRUE), source)); library(testthat); test_dir('tests/testthat', reporter='summary')"`
- Regenerate Rd docs: `Rscript -e "roxygen2::roxygenise()"`
- Build pkgdown site: `Rscript tools/build_site.R`
- Full R CMD check: `Rscript tools/full_check.R`

## Coding Style & Naming
- R style: 2‑space indent, snake_case object names, explicit arguments, vectorized dplyr/purrr where possible.
- Internal helpers: prefix with `.` and keep small/composable; avoid side effects.
- Document all exported functions with roxygen2; keep examples light and non‑networked by default.
- Prefer high‑level PXWeb wrappers (`nso_*`) over bespoke HTTP code; update `inst/extdata/px_index.json` when changing discovery/indexing.

## Testing Guidelines
- Framework: `testthat` (edition 3). Place tests in `tests/testthat/` as `test-*.R`.
- Cover core flows: discovery, variables, data fetching, periods, and geography joins (exact/fuzzy).
- Tests must pass locally via the command above; add fixtures or skip network where needed.

## Commit & Pull Requests
- Use Conventional Commits: `feat:`, `fix:`, `docs:`, `chore:`, `ci:`, `refactor:` with optional scope (e.g., `fix(pxweb): …`).
- PRs should include: concise description, linked issues, reproduction steps, and impact on docs/tests.
- Before opening a PR: run roxygenise (to refresh `NAMESPACE`/`man/`), run tests, and (optionally) build the site.

## Agent Notes
- Keep changes minimal and ergonomic for users; favor additive APIs.
- Centralize HTTP behavior in `R/http.R`; cache via `R/cache.R` only through provided toggles.
- For geography, normalize names with provided helpers and avoid introducing new external services without discussion.

