build_mongolian_site <- function(
  root = ".",
  destination = file.path(root, "docs", "mn"),
  english = dirname(destination)
) {
  root <- normalizePath(root, winslash = "/")
  english <- normalizePath(english, winslash = "/")
  destination <- fs::path_abs(destination)
  env <- new.env(parent = environment())
  sys.source(file.path(root, "pkgdown", "mn", "translate.R"), envir = env)
  catalogue <- env$mn_catalogue(root)
  temporary <- withr::local_tempdir(pattern = "mongolstats-mn-")
  for (entry in list.files(english, full.names = TRUE, all.files = TRUE, no.. = TRUE)) {
    if (basename(entry) != "mn") {
      if (dir.exists(entry)) {
        fs::dir_copy(entry, file.path(temporary, basename(entry)))
      } else {
        fs::file_copy(entry, temporary)
      }
    }
  }
  pages <- list.files(temporary, "[.]html$", recursive = TRUE)
  base <- "https://temuulene.github.io/mongolstats/"
  for (page in pages) {
    path <- file.path(temporary, page)
    doc <- xml2::read_html(path)
    if (identical(page, "articles/data-provenance.html")) {
      original_mongolian <- xml2::xml_find_all(doc, "//main//p")
      original_mongolian <- original_mongolian[grepl("\\p{Cyrillic}", xml2::xml_text(original_mongolian), perl = TRUE)]
      xml2::xml_remove(original_mongolian)
    }
    xml2::xml_remove(xml2::xml_find_all(doc, "//*[contains(concat(' ', @class, ' '), ' language-switch ')]"))
    doc <- env$mn_translate_document(doc, page, catalogue)
    xml2::xml_set_attr(xml2::xml_find_first(doc, "//html"), "lang", "mn")
    for (attribute in c("href", "src", "content")) {
      nodes <- xml2::xml_find_all(doc, paste0("//*[@", attribute, "]"))
      values <- xml2::xml_attr(nodes, attribute)
      same_site <- startsWith(values, base) & !startsWith(values, paste0(base, "mn/"))
      values[same_site] <- paste0(base, "mn/", substring(values[same_site], nchar(base) + 1L))
      root_relative <- startsWith(values, "/mongolstats/") & !startsWith(values, "/mongolstats/mn/")
      values[root_relative] <- sub("^/mongolstats/", "/mongolstats/mn/", values[root_relative])
      xml2::xml_set_attr(nodes, attribute, values)
    }
    switch <- xml2::xml_find_all(doc, "//nav//a[contains(@href, 'mn/index.html')]")
    for (node in switch) {
      xml2::xml_text(node) <- "English"
      xml2::xml_set_attr(node, "href", fs::path_rel(file.path("..", page), dirname(page)))
      xml2::xml_set_attr(node, "hreflang", "en")
      xml2::xml_set_attr(node, "lang", "en")
      xml2::xml_set_attr(node, "aria-label", "Read this page in English")
    }
    xml2::xml_remove(xml2::xml_find_all(doc, "//link[@rel='alternate' and @hreflang]"))
    head <- xml2::xml_find_first(doc, "//head")
    xml2::xml_add_child(head, "link", rel = "alternate", hreflang = "en", href = paste0(base, page))
    xml2::xml_add_child(head, "link", rel = "alternate", hreflang = "mn", href = paste0(base, "mn/", page))
    xml2::write_html(doc, path)
  }
  for (page in list.files(temporary, "[.]svg$", recursive = TRUE)) {
    env$mn_translate_svg(file.path(temporary, page), page, catalogue)
  }
  script <- file.path(temporary, "pkgdown.js")
  javascript <- paste(readLines(script, encoding = "UTF-8", warn = FALSE), collapse = "\n")
  for (source in c("Copy to clipboard", "Copied!", "Press Ctrl+C or Command+C to copy", "No results found.", "Sorry")) {
    value <- catalogue$translate(env$mn_template(source, plain = TRUE), "pkgdown.js", "interface")
    if (!is.null(value)) javascript <- gsub(source, value, javascript, fixed = TRUE)
  }
  writeLines(javascript, script, useBytes = TRUE)
  env$mn_write_catalogue(catalogue, file.path(english, "translation-source.json"))
  search <- lapply(pages, function(page) {
    doc <- xml2::read_html(file.path(temporary, page))
    xml2::xml_remove(xml2::xml_find_all(doc, "//pre|//script|//style|//code"))
    title <- xml2::xml_text(xml2::xml_find_first(doc, "//h1"))
    list(
      path = paste0(base, "mn/", page), id = "", dir = "",
      previous_headings = "", what = title, title = title,
      text = env$mn_normalise(xml2::xml_text(xml2::xml_find_first(doc, "//main"))), code = ""
    )
  })
  jsonlite::write_json(search, file.path(temporary, "search.json"), auto_unbox = TRUE)
  sitemap <- xml2::read_xml(file.path(temporary, "sitemap.xml"))
  for (node in xml2::xml_find_all(sitemap, "//*[local-name()='loc']")) {
    xml2::xml_text(node) <- sub(base, paste0(base, "mn/"), xml2::xml_text(node), fixed = TRUE)
  }
  xml2::write_xml(sitemap, file.path(temporary, "sitemap.xml"))
  fs::dir_create(destination)
  fs::dir_copy(temporary, destination, overwrite = TRUE)
  english_sitemap <- xml2::read_xml(file.path(english, "sitemap.xml"))
  existing <- xml2::xml_text(xml2::xml_find_all(english_sitemap, "//*[local-name()='loc']"))
  for (page in pages) {
    url <- paste0(base, "mn/", page)
    if (!url %in% existing) {
      entry <- xml2::xml_add_child(xml2::xml_root(english_sitemap), "url")
      xml2::xml_add_child(entry, "loc", url)
    }
  }
  xml2::write_xml(english_sitemap, file.path(english, "sitemap.xml"))
  for (page in pages) {
    path <- file.path(english, page)
    doc <- xml2::read_html(path)
    switch <- xml2::xml_find_all(doc, "//nav//a[contains(@href, 'mn/index.html')]")
    xml2::xml_set_attr(switch, "href", fs::path_rel(file.path("mn", page), dirname(page)))
    xml2::xml_set_attr(switch, "hreflang", "mn")
    xml2::xml_set_attr(switch, "lang", "mn")
    xml2::xml_remove(xml2::xml_find_all(doc, "//link[@rel='alternate' and @hreflang]"))
    head <- xml2::xml_find_first(doc, "//head")
    xml2::xml_add_child(head, "link", rel = "alternate", hreflang = "en", href = paste0(base, page))
    xml2::xml_add_child(head, "link", rel = "alternate", hreflang = "mn", href = paste0(base, "mn/", page))
    xml2::write_html(doc, path)
  }
  message("Mongolian site: ", length(pages), " translated pages")
  invisible(pages)
}

if (sys.nframe() == 0L) build_mongolian_site()
