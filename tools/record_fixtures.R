#!/usr/bin/env Rscript
# Record httptest2 fixtures for tests/testthat/test-recorded-*.R.
#
# Run from the package root with network access:
#
#   Rscript tools/record_fixtures.R
#
# Then commit the new files under tests/testthat/px_*.
#
# Design notes:
# - Fixtures are captured into a temp directory and then copied into
#   tests/testthat/. This avoids two failure modes:
#   (1) with_mock_dir() silently switches to *replay* mode if the target
#       directory exists -- and cloud-synced folders (Google Drive) can
#       resurrect a deleted empty directory between unlink() and recording;
#   (2) a partially failed recording never clobbers working fixtures.
# - The capture is verified: if zero files were recorded, the script stops
#   with diagnostics instead of reporting success.

if (!requireNamespace("httptest2", quietly = TRUE)) {
  stop("httptest2 is required to record fixtures.")
}
if (!requireNamespace("devtools", quietly = TRUE)) {
  stop("devtools is required to load the package for recording.")
}
if (!file.exists("DESCRIPTION")) {
  stop("Run this script from the package root.")
}

cat(sprintf(
  "httptest2 %s / httr2 %s / R %s\n",
  utils::packageVersion("httptest2"),
  utils::packageVersion("httr2"),
  getRversion()
))

devtools::load_all(".", quiet = TRUE)

# Real PXWeb URLs embed the catalogue folder path, which pushes fixture paths
# past the 100 bytes R CMD build can store portably. Rename recordings to
# px/<lang>/<table file> (and px/<lang>.json for the catalogue root); the
# with_px_fixtures() test helper requests the same short URLs on replay.
short_mock_path <- function(f) {
  m <- regmatches(f, regexec("^[^/]+/api/v1/(en|mn)/NSO(.*)$", f))[[1]]
  if (!length(m)) {
    stop("Unexpected fixture path: ", f, call. = FALSE)
  }
  lang <- m[2]
  rest <- m[3]
  if (startsWith(rest, "/")) {
    file.path("px", lang, basename(rest))
  } else {
    paste0("px/", lang, rest)
  }
}

record <- function(dir, expr) {
  # Reseed the PXWeb session cookie inside each capture so the seeding GET
  # is part of every fixture set.
  .px_clear_session_cookie("en")
  .px_clear_session_cookie("mn")

  tmp <- file.path(tempdir(), paste0("fixtures_", dir))
  unlink(tmp, recursive = TRUE)
  dir.create(tmp, recursive = TRUE)

  httptest2::.mockPaths(tmp)
  on.exit(httptest2::.mockPaths(NULL), add = TRUE)
  httptest2::capture_requests(expr)

  files <- list.files(tmp, recursive = TRUE)
  if (!length(files)) {
    stop(
      "capture_requests() recorded nothing for '", dir, "'.\n",
      "The requests ran (against the live API) but were not intercepted.\n",
      "This usually means an httptest2/httr2 version incompatibility --\n",
      "try updating both packages: install.packages(c('httptest2', 'httr2'))\n",
      "and check https://github.com/nealrichardson/httptest2/issues",
      call. = FALSE
    )
  }

  target <- file.path("tests", "testthat", dir)
  for (f in files) {
    dest <- file.path(target, short_mock_path(f))
    dir.create(dirname(dest), recursive = TRUE, showWarnings = FALSE)
    file.copy(file.path(tmp, f), dest, overwrite = TRUE)
  }
  cat(sprintf("Recorded %d file(s) into %s:\n", length(files), target))
  cat(paste0("  ", files, collapse = "\n"), "\n")
}

# Mirror the calls in test-recorded-http.R -------------------------------

record("px_dims", {
  nso_dims("DT_NSO_0300_001V2")
})

record("px_data", {
  nso_data(
    tbl_id = "DT_NSO_0300_001V2",
    selections = list(Sex = "Total", Age = "Total", Year = "2024"),
    labels = "code"
  )
})

# Mirror the calls in test-recorded-search.R -----------------------------

record("px_meta", {
  nso_table_meta("DT_NSO_0300_001V2")
})

record("px_sectors", {
  nso_sectors()
})

cat("Done. Commit the fixture directories, then re-run devtools::test():\n")
cat("the recorded tests should PASS rather than SKIP.\n")
