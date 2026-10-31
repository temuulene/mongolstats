build_mongolian_site <- function(
  root = ".",
  destination = file.path(root, "docs", "mn")
) {
  root <- normalizePath(root, winslash = "/")
  destination <- fs::path_abs(destination)
  temporary <- withr::local_tempdir(pattern = "mongolstats-mn-")
  for (entry in c("DESCRIPTION", "NAMESPACE", "LICENSE", "R", "man")) {
    if (!file.copy(file.path(root, entry), temporary, recursive = TRUE)) {
      stop("Could not prepare Mongolian site source: ", entry)
    }
  }
  dir.create(file.path(temporary, "pkgdown"))
  file.copy(
    file.path(root, "pkgdown", "favicon"),
    file.path(temporary, "pkgdown"),
    recursive = TRUE
  )
  file.copy(
    file.path(root, "pkgdown", "mn", "_pkgdown.yml"),
    file.path(temporary, "_pkgdown.yml")
  )
  file.copy(
    file.path(root, "pkgdown", "mn", "index.Rmd"),
    file.path(temporary, "index.Rmd")
  )
  withr::local_options(list(mongolmaps.lang = "mn"))
  rmarkdown::render(
    file.path(temporary, "index.Rmd"),
    output_format = rmarkdown::github_document(html_preview = FALSE),
    envir = new.env(),
    quiet = TRUE
  )
  staged_site <- file.path(temporary, "site")
  override <- list(destination = staged_site)
  pkgdown::init_site(temporary, override = override)
  fs::dir_create(file.path(staged_site, "reference", "figures"))
  fs::dir_copy(
    file.path(temporary, "man", "figures"),
    file.path(staged_site, "reference", "figures"),
    overwrite = TRUE
  )
  pkgdown::build_home(temporary, override = override, preview = FALSE)

  path <- file.path(staged_site, "index.html")
  doc <- xml2::read_html(path)
  xml2::xml_set_attr(xml2::xml_find_first(doc, "//html"), "lang", "mn")
  links <- xml2::xml_find_all(doc, "//a[starts-with(@href, 'reference/')]")
  xml2::xml_set_attr(
    links,
    "href",
    paste0("../", xml2::xml_attr(links, "href"))
  )
  xml2::xml_set_attr(links, "hreflang", "en")
  labels <- c(
    "Skip to contents" = "Агуулга руу шилжих",
    "Toggle navigation" = "Цэсийг нээх"
  )
  for (label in names(labels)) {
    nodes <- xml2::xml_find_all(
      doc,
      paste0("//*[normalize-space(text())='", label, "']")
    )
    for (node in nodes) {
      if (length(xml2::xml_children(node)) == 0L) {
        xml2::xml_text(node) <- labels[[label]]
      }
    }
    attributes <- xml2::xml_find_all(
      doc,
      paste0("//*[@aria-label='", label, "']")
    )
    xml2::xml_set_attr(attributes, "aria-label", labels[[label]])
  }
  navigation <- xml2::xml_find_all(doc, "//nav[@aria-label='Site navigation']")
  xml2::xml_set_attr(navigation, "aria-label", "Үндсэн цэс")
  head <- xml2::xml_find_first(doc, "//head")
  xml2::xml_add_child(
    head,
    "link",
    rel = "alternate",
    hreflang = "en",
    href = "../index.html"
  )
  xml2::xml_add_child(
    head,
    "link",
    rel = "alternate",
    hreflang = "mn",
    href = "index.html"
  )
  xml2::write_html(doc, path)
  fs::dir_create(destination)
  fs::dir_copy(staged_site, destination, overwrite = TRUE)
  message("Mongolian landing page written to ", destination)
}

if (sys.nframe() == 0L) {
  build_mongolian_site()
}
