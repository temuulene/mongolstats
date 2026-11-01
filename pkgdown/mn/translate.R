# Translations apply to one rendered analysis, preserving its numbers and code.
mn_normalise <- function(x) trimws(gsub("[[:space:]]+", " ", x))

mn_technical <- function(x) {
  x <- gsub("\\{[0-9]+\\}", "", x)
  x <- gsub("[A-Za-z][A-Za-z0-9_.]*_[A-Za-z0-9_.]+", "", x)
  x <- gsub(
    paste0("(?i)\\b(", paste(c(
      "mongolstats", "mongolmaps", "pkgdown", "R", "CRAN", "GitHub",
      "PXWeb", "API", "NSO", "MIT", "GDP", "JSON", "CSV", "RDS",
      "UTF-8", "HTML", "HTTP", "HTTPS", "TRUE", "FALSE", "NULL", "NA",
      "GPL", "BSD", "sf", "dplyr", "ggplot2", "httr2", "knitr",
      "rmarkdown", "lubridate", "testthat", "rlang", "purrr", "tidyr",
      "tibble", "curl", "scales", "en", "mn", "English"
    ), collapse = "|"), ")\\b"), "", x,
    perl = TRUE
  )
  !grepl("[A-Za-z]{2,}", x) ||
    grepl("^(https?://|[[:alnum:]._%+-]+@[[:alnum:].-]+)", x) ||
    grepl("^[A-Za-z][A-Za-z0-9_.]*[_][A-Za-z0-9_.]+$", x) ||
    grepl("^[a-f0-9]{12,}$", x)
}

mn_template <- function(node, plain = FALSE) {
  values <- character()
  bind <- function(x) {
    values <<- c(values, x)
    paste0("{", length(values), "}")
  }
  text <- function(x) {
    x <- gsub("[[:space:]]+", " ", x)
    found <- gregexpr("(?<![A-Za-z_])[+-]?[0-9]+(?:[.,:/-][0-9]+)*(?:%|–[0-9]+)?", x, perl = TRUE)
    hits <- regmatches(x, found)[[1]]
    if (length(hits)) regmatches(x, found) <- list(vapply(hits, bind, ""))
    x
  }
  pack <- function(n) {
    if (xml2::xml_type(n) == "text") {
      return(text(xml2::xml_text(n)))
    }
    name <- xml2::xml_name(n)
    if (name %in% c("code", "img", "svg", "math", "br", "wbr") ||
      grepl("(^| )math( |$)", xml2::xml_attr(n, "class") %||% "") ||
      (name == "a" && grepl("\\(\\)$|_", xml2::xml_text(n)))) {
      return(bind(as.character(n)))
    }
    raw <- as.character(n)
    opening <- substr(raw, 1L, regexpr(">", raw, fixed = TRUE)[[1]])
    paste0(
      bind(opening), paste0(vapply(xml2::xml_contents(n), pack, ""), collapse = ""),
      bind(paste0("</", name, ">"))
    )
  }
  source <- if (plain) {
    text(node)
  } else if (xml2::xml_type(node) == "text") {
    text(xml2::xml_text(node))
  } else {
    paste0(vapply(xml2::xml_contents(node), pack, ""), collapse = "")
  }
  list(source = mn_normalise(source), values = values)
}

`%||%` <- function(x, y) if (length(x) && !is.na(x)) x else y

mn_unbind <- function(target, template, html = FALSE) {
  tokens <- function(x) sort(regmatches(x, gregexpr("\\{[0-9]+\\}", x))[[1]])
  if (!identical(tokens(target), tokens(template$source))) {
    stop("Translation changes protected code, formatting or numbers: ", template$source)
  }
  if (html) {
    target <- gsub("&", "&amp;", target, fixed = TRUE)
    target <- gsub("<", "&lt;", target, fixed = TRUE)
    target <- gsub(">", "&gt;", target, fixed = TRUE)
  }
  for (i in rev(seq_along(template$values))) {
    target <- gsub(paste0("{", i, "}"), template$values[[i]], target, fixed = TRUE)
  }
  target
}

mn_catalogue <- function(root) {
  path <- file.path(root, "pkgdown", "mn", "translations.jsonl")
  records <- if (file.exists(path)) lapply(readLines(path, encoding = "UTF-8", warn = FALSE), jsonlite::fromJSON) else list()
  values <- stats::setNames(records, vapply(records, function(x) x$id, ""))
  if (anyDuplicated(names(values))) stop("Duplicate Mongolian translation keys")
  entries <- new.env(parent = emptyenv())
  missing <- new.env(parent = emptyenv())
  translate <- function(template, page, kind, html = FALSE) {
    source <- template$source
    if (!nzchar(source) || mn_technical(source)) {
      return(NULL)
    }
    id <- substr(digest::digest(source, algo = "sha256", serialize = FALSE), 1L, 20L)
    entries[[id]] <- list(id = id, source = source, page = page, kind = kind)
    entry <- values[[id]]
    if (is.null(entry) || !identical(entry$source, source) || !nzchar(entry$target %||% "")) {
      missing[[id]] <- entries[[id]]
      return(NULL)
    }
    mn_unbind(entry$target, template, html)
  }
  list(translate = translate, entries = entries, missing = missing)
}

mn_replace_html <- function(node, value) {
  fragment <- xml2::read_html(paste0("<html><body><div id='mn-fragment'>", value, "</div></body></html>"))
  contents <- xml2::xml_contents(xml2::xml_find_first(fragment, "//*[@id='mn-fragment']"))
  xml2::xml_remove(xml2::xml_contents(node))
  for (child in contents) xml2::xml_add_child(node, child, .copy = TRUE)
}

mn_translate_document <- function(doc, page, catalogue) {
  inline <- c("a", "em", "strong", "code", "span", "small", "sup", "sub", "br", "wbr", "img", "svg", "math", "b", "i", "s", "kbd", "abbr", "time")
  skip <- c("script", "style", "pre", "code", "svg", "math", "noscript", "dt")
  visit <- function(node) {
    if (inherits(node, "xml_missing")) {
      return(invisible(NULL))
    }
    if (xml2::xml_type(node) == "text") {
      translated <- catalogue$translate(mn_template(node), page, "text")
      if (!is.null(translated)) xml2::xml_text(node) <- translated
      return(invisible(NULL))
    }
    name <- xml2::xml_name(node)
    if (name %in% skip || xml2::xml_type(node) != "element") {
      return(invisible(NULL))
    }
    descendants <- xml2::xml_find_all(node, ".//*")
    if (all(xml2::xml_name(descendants) %in% inline)) {
      translated <- catalogue$translate(mn_template(node), page, "html", html = TRUE)
      if (!is.null(translated)) mn_replace_html(node, translated)
    } else {
      for (child in xml2::xml_contents(node)) visit(child)
    }
    invisible(NULL)
  }
  visit(xml2::xml_find_first(doc, "//body"))
  for (attribute in c("alt", "title", "aria-label", "placeholder")) {
    for (node in xml2::xml_find_all(doc, paste0("//*[@", attribute, "]"))) {
      value <- catalogue$translate(mn_template(xml2::xml_attr(node, attribute), plain = TRUE), page, attribute)
      if (!is.null(value)) xml2::xml_set_attr(node, attribute, value)
    }
  }
  heading <- xml2::xml_text(xml2::xml_find_first(doc, "//h1"))
  if (!is.na(heading)) {
    titles <- xml2::xml_find_all(doc, "//title")
    xml2::xml_text(titles) <- paste0(heading, " • mongolstats")
    xml2::xml_set_attr(xml2::xml_find_all(doc, "//meta[@property='og:title']"), "content", heading)
    description <- mn_normalise(xml2::xml_text(xml2::xml_find_first(doc, "//main//p")))
    if (!is.na(description)) xml2::xml_set_attr(xml2::xml_find_all(doc, "//meta[@name='description' or @property='og:description']"), "content", description)
  } else {
    for (node in xml2::xml_find_all(doc, "//title")) {
      value <- catalogue$translate(mn_template(xml2::xml_text(node), plain = TRUE), page, "title")
      if (!is.null(value)) xml2::xml_text(node) <- value
    }
  }
  # R identifiers, official selection labels and executable strings stay intact.
  for (node in xml2::xml_find_all(doc, "//pre//span[contains(concat(' ', @class, ' '), ' co ')]")) {
    if (grepl("^ *#>", xml2::xml_text(node))) next
    if (grepl("^# *[[:alnum:]_.]+\\(", xml2::xml_text(node))) next
    value <- catalogue$translate(mn_template(xml2::xml_text(node), plain = TRUE), page, "comment")
    if (!is.null(value)) xml2::xml_text(node) <- value
  }
  doc
}

mn_translate_svg <- function(path, page, catalogue) {
  doc <- xml2::read_xml(path, options = "NONET")
  for (node in xml2::xml_find_all(doc, "//*[local-name()='text']")) {
    original <- xml2::xml_text(node)
    value <- catalogue$translate(mn_template(original, plain = TRUE), page, "figure")
    if (is.null(value)) next
    xml2::xml_text(node) <- value
    # Keep longer translated labels inside the original layout. The coordinate
    # system, marks, scales and numerical values are never modified.
    length <- xml2::xml_attr(node, "textLength")
    if (!is.na(length)) xml2::xml_set_attr(node, "lengthAdjust", "spacingAndGlyphs")
    if (is.na(length)) {
      width <- suppressWarnings(as.numeric(xml2::xml_attr(node, "data-width")))
      if (!is.finite(width)) {
        font <- sub(".*font-size: *([0-9.]+)px.*", "\\1", xml2::xml_attr(node, "style"))
        font <- suppressWarnings(as.numeric(font))
        if (!is.finite(font)) font <- 11
        width <- nchar(original, type = "width") * font * 0.52
      }
      if (nchar(value, type = "width") > nchar(original, type = "width") * 1.15) {
        xml2::xml_set_attr(node, "textLength", as.character(width))
        xml2::xml_set_attr(node, "lengthAdjust", "spacingAndGlyphs")
      }
    }
  }
  xml2::write_xml(doc, path)
}

mn_write_catalogue <- function(catalogue, path) {
  entries <- as.list(catalogue$entries)
  entries <- entries[order(names(entries))]
  jsonlite::write_json(unname(entries), path, auto_unbox = TRUE, pretty = TRUE)
  missing <- as.list(catalogue$missing)
  if (length(missing)) {
    for (entry in missing) cat("I18N_SOURCE ", jsonlite::toJSON(entry, auto_unbox = TRUE), "\n", sep = "")
    stop(length(missing), " untranslated documentation segments; update pkgdown/mn/translations.jsonl", call. = FALSE)
  }
  invisible(length(entries))
}
