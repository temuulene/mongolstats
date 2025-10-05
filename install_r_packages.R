#!/usr/bin/env Rscript
# Install required R packages for mongolstats development

cat("========================================\n")
cat("Installing R packages for development\n")
cat("========================================\n\n")

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Essential development packages
dev_packages <- c(
  "devtools",
  "roxygen2",
  "rcmdcheck",
  "pkgdown",
  "testthat",
  "remotes"
)

cat("Installing development packages:\n")
cat(paste("-", dev_packages, collapse = "\n"), "\n\n")

install.packages(dev_packages)

cat("\n========================================\n")
cat("Installing package dependencies\n")
cat("========================================\n\n")

# Install package-specific dependencies
if (requireNamespace("devtools", quietly = TRUE)) {
  devtools::install_dev_deps()
} else {
  cat("devtools not available, skipping dev deps\n")
}

cat("\n========================================\n")
cat("Installation Complete!\n")
cat("========================================\n\n")

cat("Installed packages:\n")
installed <- rownames(installed.packages())
for (pkg in dev_packages) {
  status <- if (pkg %in% installed) "✓" else "✗"
  cat(sprintf("  %s %s\n", status, pkg))
}

cat("\nYou can now run:\n")
cat("  Rscript -e 'roxygen2::roxygenise()'\n")
cat("  Rscript -e 'devtools::test()'\n")
cat("  Rscript -e 'rcmdcheck::rcmdcheck()'\n")
cat("  Rscript -e 'pkgdown::build_site()'\n\n")
