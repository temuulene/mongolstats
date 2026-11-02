# Translations apply to one rendered analysis, preserving its numbers and code.
mn_normalise <- function(x) trimws(gsub("[[:space:]]+", " ", x))

mn_technical <- function(x) {
  x <- gsub("\\{[0-9]+\\}", "", x)
  x <- sub("^# *", "", x)
  if (grepl("^(https?://|[[:alnum:]._%+-]+@[[:alnum:].-]+)", x)) {
    return(TRUE)
  }
  x <- gsub("(PM|SO|NO)[0-9.₂₅]*", "", x)
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
  # One pass keeps backslashes and brace text inside protected values literal.
  found <- gregexpr("\\{[0-9]+\\}", target)
  tokens <- regmatches(target, found)[[1]]
  regmatches(target, found) <- list(vapply(tokens, function(token) {
    template$values[[as.integer(substr(token, 2L, nchar(token) - 1L))]]
  }, "", USE.NAMES = FALSE))
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
    if (!grepl("\\p{Cyrillic}", entry$target, perl = TRUE) && !mn_technical(entry$target)) {
      stop("Mongolian translation is still English: ", source)
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
  inline <- c(
    "a", "em", "strong", "code", "span", "small", "sup", "sub", "br", "wbr",
    "img", "svg", "math", "b", "i", "s", "kbd", "abbr", "time"
  )
  skip <- c("script", "style", "pre", "code", "svg", "math", "noscript")
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
    if (name == "pre" && identical(page, "LICENSE-text.html")) {
      value <- catalogue$translate(mn_template(xml2::xml_text(node), plain = TRUE), page, "license")
      if (!is.null(value)) xml2::xml_text(node) <- value
      return(invisible(NULL))
    }
    if (name %in% skip || xml2::xml_type(node) != "element") {
      return(invisible(NULL))
    }
    # Argument names are R identifiers; other terms, such as article titles, are prose.
    if (name == "dt" && startsWith(xml2::xml_attr(node, "id") %||% "", "arg-")) {
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
    xml2::xml_set_attr(xml2::xml_find_all(doc, "//meta[@property='og:title' or @name='twitter:title']"), "content", heading)
    description <- mn_normalise(xml2::xml_text(xml2::xml_find_first(doc, "//main//p")))
    if (!is.na(description)) {
      meta <- "//meta[@name='description' or @property='og:description' or @name='twitter:description']"
      xml2::xml_set_attr(xml2::xml_find_all(doc, meta), "content", description)
    }
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
    if (grepl("^# *\\\\", xml2::xml_text(node))) next
    value <- catalogue$translate(mn_template(xml2::xml_text(node), plain = TRUE), page, "comment")
    if (!is.null(value)) xml2::xml_text(node) <- value
  }
  doc
}

mn_translate_svg <- function(path, page, catalogue) {
  doc <- xml2::read_xml(path, options = "NONET")
  lifecycle_badge <- any(startsWith(mn_normalise(c(
    xml2::xml_attr(doc, "aria-label"),
    xml2::xml_text(xml2::xml_find_all(doc, "/*/*[local-name()='title']"))
  )), "lifecycle: "), na.rm = TRUE)
  metadata <- function(source) {
    if (startsWith(source, "lifecycle: ")) {
      prefix <- catalogue$translate(mn_template("lifecycle", plain = TRUE), page, "figure")
      state <- catalogue$translate(mn_template(sub("^lifecycle: *", "", source), plain = TRUE), page, "figure")
      if (!is.null(prefix) && !is.null(state)) {
        return(paste0(prefix, ": ", state))
      }
      return(NULL)
    }
    catalogue$translate(mn_template(source, plain = TRUE), page, "svg-accessibility")
  }
  for (node in xml2::xml_find_all(doc, "//*[local-name()='title' or local-name()='desc']")) {
    value <- metadata(xml2::xml_text(node))
    if (!is.null(value)) xml2::xml_text(node) <- value
  }
  for (node in xml2::xml_find_all(doc, "//*[@aria-label]")) {
    value <- metadata(xml2::xml_attr(node, "aria-label"))
    if (!is.null(value)) xml2::xml_set_attr(node, "aria-label", value)
  }
  nodes <- xml2::xml_find_all(doc, "//*[local-name()='text']")
  x <- suppressWarnings(as.numeric(xml2::xml_attr(nodes, "x")))
  y <- suppressWarnings(as.numeric(xml2::xml_attr(nodes, "y")))
  box <- as.numeric(strsplit(xml2::xml_attr(doc, "viewBox") %||% "", "[ ,]+")[[1]])
  canvas <- if (length(box) == 4L) box[[3]] else 504
  natural_widths <- rep(NA_real_, length(nodes))
  backgrounds <- xml2::xml_find_all(doc, "//*[local-name()='g'][@clip-path]/*[local-name()='rect']")
  badge_scales <- suppressWarnings(as.numeric(sub(
    "^scale\\(\\s*([0-9.]+)\\s*\\)$", "\\1", xml2::xml_attr(nodes, "transform")
  )))
  badge_layout <- lifecycle_badge && length(backgrounds) == 3L &&
    length(unique(x)) == 2L && all(is.finite(x)) &&
    all(is.finite(badge_scales) & badge_scales > 0)
  for (i in seq_along(nodes)) {
    node <- nodes[[i]]
    original <- xml2::xml_text(node)
    value <- catalogue$translate(mn_template(original, plain = TRUE), page, "figure")
    if (is.null(value)) next
    xml2::xml_text(node) <- value
    property <- function(name, default) {
      for (current in rev(xml2::xml_find_all(node, "ancestor-or-self::*"))) {
        style <- xml2::xml_attr(current, "style") %||% ""
        match <- regmatches(style, regexec(paste0("(?:^|;)\\s*", name, "\\s*:\\s*([^;]+)"), style, perl = TRUE))[[1]]
        value <- if (length(match)) trimws(match[[2]]) else xml2::xml_attr(current, name)
        if (!is.na(value) && value != "inherit") {
          return(value)
        }
      }
      default
    }
    size <- property("font-size", "11")
    font <- suppressWarnings(as.numeric(sub("(px|pt)$", "", size)))
    if (grepl("pt$", size)) font <- font * 96 / 72
    if (!is.finite(font)) font <- 11
    family <- trimws(gsub("['\"]", "", strsplit(property("font-family", "sans"), ",", fixed = TRUE)[[1]][[1]]))
    weight <- property("font-weight", "normal")
    if (grepl("^[0-9]+$", weight)) weight <- as.numeric(weight)
    italic <- property("font-style", "normal") %in% c("italic", "oblique")
    measure <- function(text) {
      as.numeric(systemfonts::string_width(
        text,
        family = family, size = font, res = 72, weight = weight, italic = italic
      ))
    }
    width <- suppressWarnings(as.numeric(sub("px$", "", xml2::xml_attr(node, "textLength"))))
    if (!is.finite(width)) width <- measure(original)
    if (!is.finite(width) || width <= 0) width <- max(1, nchar(original)) * font * 0.52
    available <- width
    if (is.finite(x[[i]]) && is.finite(y[[i]]) && is.na(xml2::xml_attr(node, "transform"))) {
      peers <- x[is.finite(x) & is.finite(y) & abs(y - y[[i]]) < 0.25 & seq_along(x) != i]
      previous <- max(c(4, peers[peers < x[[i]]]))
      following <- min(c(canvas - 4, peers[peers > x[[i]]]))
      anchor <- xml2::xml_attr(node, "text-anchor") %||% "start"
      available <- switch(anchor,
        middle = min(following - x[[i]], x[[i]] - previous) * 0.92,
        end = x[[i]] - previous - 6,
        following - x[[i]] - 6
      )
    }
    # Preserve natural glyph widths, including on rotated labels and badges.
    # Untranslated numbers, marks and all coordinates retain their original data.
    natural <- measure(value)
    if (!is.finite(natural) || natural <= 0) natural <- nchar(value) * font * 0.52
    natural_widths[[i]] <- natural
    xml2::xml_set_attr(node, "textLength", NULL)
    xml2::xml_set_attr(node, "lengthAdjust", NULL)
    # The old slot is a layout-review hint, not a constraint on translated text.
    if (!badge_layout && natural > max(width, available) + 0.5) {
      message("I18N_LAYOUT ", jsonlite::toJSON(list(
        page = page, text = value, natural_width = round(natural, 2),
        estimated_slot = round(max(width, available), 2),
        transformed = !is.na(xml2::xml_attr(node, "transform"))
      ), auto_unbox = TRUE))
    }
  }
  if (badge_layout && all(is.finite(natural_widths))) {
    # These two-cell lifecycle badges are UI, not quantitative plot geometry.
    # Text and shadow coordinates use scale(.1); backgrounds use root units.
    cell <- match(x, sort(unique(x)))
    cells <- vapply(1:2, function(i) {
      ceiling(max(natural_widths[cell == i] * badge_scales[cell == i])) + 12
    }, 0)
    cells <- pmax(cells, as.numeric(xml2::xml_attr(backgrounds[1:2], "width")))
    total <- sum(cells)
    xml2::xml_set_attr(doc, "width", as.character(total))
    if (length(box) == 4L) {
      box[[3]] <- total
      xml2::xml_set_attr(doc, "viewBox", paste(box, collapse = " "))
    }
    xml2::xml_set_attr(backgrounds[[1]], "width", as.character(cells[[1]]))
    xml2::xml_set_attr(backgrounds[[2]], "x", as.character(cells[[1]]))
    xml2::xml_set_attr(backgrounds[[2]], "width", as.character(cells[[2]]))
    xml2::xml_set_attr(backgrounds[[3]], "width", as.character(total))
    clips <- xml2::xml_find_all(doc, "//*[local-name()='clipPath']/*[local-name()='rect']")
    xml2::xml_set_attr(clips, "width", as.character(total))
    centres <- c(cells[[1]] / 2, cells[[1]] + cells[[2]] / 2)
    xml2::xml_set_attr(nodes, "x", as.character(centres[cell] / badge_scales))
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
