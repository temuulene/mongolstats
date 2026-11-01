build_package_site <- function(
  root = ".",
  destination = file.path(root, "docs")
) {
  root <- normalizePath(root, winslash = "/")
  destination <- fs::path_abs(destination)
  withr::local_dir(root)
  withr::local_envvar(NOT_CRAN = "")
  withr::local_options(list(rmarkdown.html_vignette.check_title = FALSE))
  if (nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_"))) {
    stop("Build the website outside package checks.")
  }
  dir.create(destination, recursive = TRUE, showWarnings = FALSE)
  rmarkdown::render("README.Rmd", envir = new.env(), quiet = TRUE)
  # pkgdown renders each article in a fresh R process, so knitr hooks set here
  # cannot see article warnings. tools/check_vignettes.R records them instead
  # in the live canary's build-warnings.log.
  source("tools/site_helpers.R", local = TRUE)
  source("pkgdown/build-mn.R", local = TRUE)
  pkgdown::build_site(
    override = list(destination = destination),
    preview = FALSE,
    install = FALSE,
    new_process = FALSE,
    lazy = FALSE
  )
  build_development_aliases(destination)
  build_mongolian_site(root, file.path(destination, "mn"))
  result <- check_site(destination)
  print(result$figures, row.names = FALSE)
  jsonlite::write_json(
    result,
    file.path(destination, "site-checks.json"),
    auto_unbox = TRUE,
    pretty = TRUE
  )
  invisible(result)
}

if (sys.nframe() == 0L) {
  args <- commandArgs(trailingOnly = TRUE)
  build_package_site(destination = if (length(args)) args[[1]] else "docs")
}
