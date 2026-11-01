# Execute analytical articles against the live source without deploying a site.
# Run against an installed development package: Rscript tools/check_vignettes.R
check_vignettes <- function(
  destination = "check_vignettes",
  files = list.files("vignettes", pattern = "[.]Rmd$", recursive = TRUE, full.names = TRUE)
) {
  if (nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_"))) {
    stop("Run live vignette checks outside package checks.")
  }
  root <- normalizePath(".", winslash = "/")
  dir.create(destination, recursive = TRUE, showWarnings = FALSE)
  destination <- normalizePath(destination, winslash = "/")
  withr::local_envvar(c(IN_PKGDOWN = "true", NOT_CRAN = ""))
  old_chunks <- knitr::opts_chunk$get()
  old_knit <- knitr::opts_knit$get()
  old_warning <- knitr::knit_hooks$get("warning")
  old_option <- knitr::opts_hooks$get("warning")
  on.exit(
    {
      knitr::opts_chunk$restore(old_chunks)
      knitr::opts_knit$restore(old_knit)
      knitr::knit_hooks$set(warning = old_warning)
      knitr::opts_hooks$set(warning = old_option)
    },
    add = TRUE
  )
  warnings <- file.path(destination, "build-warnings.log")
  writeLines("Live analytical vignette warnings:", warnings)
  knitr::opts_knit$set(root.dir = root)
  knitr::opts_hooks$set(warning = function(options) {
    options$warning <- TRUE
    options
  })
  knitr::knit_hooks$set(warning = function(x, options) {
    cat(paste0("[", options$label, "] ", x, "\n"), file = warnings, append = TRUE)
    ""
  })
  for (file in files) {
    label <- tools::file_path_sans_ext(basename(file))
    cat("Checking ", label, "\n", sep = "")
    knitr::opts_chunk$set(
      eval = TRUE, purl = TRUE,
      fig.path = paste0(destination, "/", label, "-")
    )
    knitr::knit(file,
      output = file.path(destination, paste0(label, ".md")),
      envir = new.env(), quiet = TRUE
    )
  }
  writeLines(capture.output(utils::sessionInfo()), file.path(destination, "session-info.txt"))
  invisible(files)
}

if (sys.nframe() == 0L) check_vignettes()
