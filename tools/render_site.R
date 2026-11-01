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
  warning_log <- file.path(destination, "build-warnings.log")
  writeLines("Warnings captured while building the documentation:", warning_log)
  # Keep warnings available to maintainers even when articles hide them.
  previous_warning_hook <- knitr::knit_hooks$get("warning")
  previous_warning_option <- knitr::opts_hooks$get("warning")
  on.exit(
    {
      knitr::knit_hooks$set(warning = previous_warning_hook)
      knitr::opts_hooks$set(warning = previous_warning_option)
    },
    add = TRUE
  )
  knitr::opts_hooks$set(warning = function(options) {
    options$warning <- TRUE
    options
  })
  knitr::knit_hooks$set(warning = function(x, options) {
    cat(paste0("[", options$label, "] ", x, "\n"),
      file = warning_log, append = TRUE
    )
    ""
  })
  source("tools/site_helpers.R", local = TRUE)
  source("pkgdown/build-mn.R", local = TRUE)
  rmarkdown::render("README.Rmd", envir = new.env(), quiet = TRUE)
  pkgdown::build_site(
    override = list(destination = destination),
    preview = FALSE,
    install = FALSE,
    new_process = FALSE,
    lazy = FALSE
  )
  build_mongolian_site(root, file.path(destination, "mn"))
  home_path <- file.path(destination, "index.html")
  home <- xml2::read_html(home_path)
  head <- xml2::xml_find_first(home, "//head")
  xml2::xml_add_child(
    head,
    "link",
    rel = "alternate",
    hreflang = "en",
    href = "index.html"
  )
  xml2::xml_add_child(
    head,
    "link",
    rel = "alternate",
    hreflang = "mn",
    href = "mn/index.html"
  )
  xml2::write_html(home, home_path)
  sitemap_path <- file.path(destination, "sitemap.xml")
  sitemap <- xml2::read_xml(sitemap_path)
  mongolian_url <- "https://temuulene.github.io/mongolstats/mn/index.html"
  locations <- xml2::xml_text(xml2::xml_find_all(
    sitemap,
    "//*[local-name()='loc']"
  ))
  if (!mongolian_url %in% locations) {
    entry <- xml2::xml_add_child(xml2::xml_root(sitemap), "url")
    xml2::xml_add_child(entry, "loc", mongolian_url)
  }
  xml2::write_xml(sitemap, sitemap_path)
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
