#!/usr/bin/env Rscript
if (!requireNamespace("styler", quietly = TRUE)) {
  install.packages("styler", repos = "https://cloud.r-project.org")
}
styler::style_pkg(
  transformers = styler::tidyverse_style(),
  filetype = c("R", "Rmd")
)
cat("Styling complete\n")
