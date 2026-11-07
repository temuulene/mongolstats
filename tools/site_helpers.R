site_asset_path <- function(directory, page, reference) {
  base <- "https://temuulene.github.io/mongolstats/"
  reference <- sub("[?#].*$", "", reference)
  if (startsWith(reference, base)) {
    reference <- substring(reference, nchar(base) + 1L)
    page <- "index.html"
  } else if (grepl("^[[:alpha:]][[:alnum:]+.-]*:|^//", reference)) {
    return(NULL)
  }
  reference <- utils::URLdecode(reference)
  if (startsWith(reference, "/mongolstats/")) {
    reference <- substring(reference, nchar("/mongolstats/") + 1L)
    page <- "index.html"
  }
  if (!nzchar(reference)) {
    reference <- "index.html"
  }
  path <- fs::path_norm(file.path(directory, dirname(page), reference))
  root <- paste0(tolower(normalizePath(directory, winslash = "/")), "/")
  if (!startsWith(paste0(tolower(path), "/"), root)) {
    stop(
      "Local reference leaves the website: ",
      page,
      " -> ",
      reference,
      call. = FALSE
    )
  }
  if (dir.exists(path)) {
    path <- file.path(path, "index.html")
  }
  path
}

site_image_dimensions <- function(path) {
  if (grepl("[.]png$", path, ignore.case = TRUE)) {
    header <- readBin(path, "raw", n = 24L)
    signature <- as.raw(c(137, 80, 78, 71, 13, 10, 26, 10))
    if (length(header) != 24L || !identical(header[1:8], signature)) {
      stop("Invalid PNG image: ", basename(path), call. = FALSE)
    }
    return(c(
      width = sum(as.integer(header[17:20]) * 256^(3:0)),
      height = sum(as.integer(header[21:24]) * 256^(3:0))
    ))
  }
  if (grepl("[.]svg$", path, ignore.case = TRUE)) {
    image <- xml2::read_xml(path, options = "NONET")
    box <- as.numeric(strsplit(xml2::xml_attr(image, "viewBox"), "[ ,]+")[[1]])
    if (length(box) == 4L) {
      return(c(width = box[3], height = box[4]))
    }
    return(c(
      width = as.numeric(xml2::xml_attr(image, "width")),
      height = as.numeric(xml2::xml_attr(image, "height"))
    ))
  }
  stop("Unsupported plot image: ", basename(path), call. = FALSE)
}

check_site_figures <- function(directory, minimums) {
  directory <- normalizePath(directory, winslash = "/")
  counts <- lapply(names(minimums), function(page) {
    file <- file.path(directory, page)
    if (!file.exists(file)) {
      stop("Missing page: ", page, call. = FALSE)
    }
    doc <- xml2::read_html(file)
    sources <- unique(xml2::xml_attr(
      xml2::xml_find_all(doc, "//main//img"),
      "src"
    ))
    sources <- sources[!is.na(sources)]
    sources <- sources[
      !grepl(
        "logo|favicon|badge|apple-touch|social",
        basename(sources),
        ignore.case = TRUE
      )
    ]
    plots <- 0L
    for (source in sources) {
      path <- site_asset_path(directory, page, source)
      if (is.null(path)) {
        next
      }
      if (!file.exists(path)) {
        stop("Missing image in ", page, ": ", source, call. = FALSE)
      }
      dimensions <- site_image_dimensions(path)
      if (
        anyNA(dimensions) ||
          dimensions["width"] < 200 ||
          dimensions["height"] < 120
      ) {
        stop("Plot is too small in ", page, ": ", source, call. = FALSE)
      }
      plots <- plots + 1L
    }
    if (plots < minimums[[page]]) {
      stop(
        page,
        " has ",
        plots,
        " plots; expected at least ",
        minimums[[page]],
        call. = FALSE
      )
    }
    data.frame(page = page, plots = plots, minimum = minimums[[page]])
  })
  do.call(rbind, counts)
}

check_english_home <- function(path) {
  doc <- xml2::read_html(path)
  xml2::xml_remove(xml2::xml_find_all(
    doc,
    "//script|//style|//pre|//code|//*[contains(@class, 'language-switch')]"
  ))
  main <- xml2::xml_find_first(doc, "//main")
  if (grepl("\\p{Cyrillic}", xml2::xml_text(main), perl = TRUE)) {
    stop(
      "English home page contains Mongolian prose outside its language switch",
      call. = FALSE
    )
  }
  TRUE
}

check_site_links <- function(directory) {
  directory <- normalizePath(directory, winslash = "/")
  pages <- list.files(directory, "[.]html$", recursive = TRUE)
  for (page in pages) {
    doc <- xml2::read_html(file.path(directory, page))
    nodes <- xml2::xml_find_all(doc, "//*[@href or @src]")
    references <- unique(c(
      xml2::xml_attr(nodes, "href"),
      xml2::xml_attr(nodes, "src")
    ))
    references <- references[
      !is.na(references) & nzchar(references) & !startsWith(references, "#")
    ]
    for (reference in references) {
      path <- site_asset_path(directory, page, reference)
      if (!is.null(path) && !file.exists(path)) {
        stop("Broken local reference in ", page, ": ", reference, call. = FALSE)
      }
    }
  }
  length(pages)
}

check_plot_label_bounds <- function(directory) {
  number_pattern <- "[-+]?(?:[0-9]+(?:[.][0-9]*)?|[.][0-9]+)(?:[eE][-+]?[0-9]+)?"
  number <- function(value, default = NULL) {
    if (is.na(value) || !nzchar(value)) {
      if (!is.null(default)) return(default)
      stop("Missing SVG font size.", call. = FALSE)
    }
    if (!grepl(paste0("^", number_pattern, "(?:px)?$"), value, perl = TRUE)) {
      stop("Unsupported SVG coordinate or size: ", value, call. = FALSE)
    }
    as.numeric(sub("px$", "", value))
  }
  property <- function(node, name, default = "") {
    ancestors <- xml2::xml_find_all(node, "ancestor-or-self::*")
    for (ancestor in rev(as.list(ancestors))) {
      style <- xml2::xml_attr(ancestor, "style")
      if (!is.na(style)) {
        declarations <- strsplit(style, ";", fixed = TRUE)[[1]]
        keys <- trimws(sub(":.*", "", declarations))
        matches <- which(keys == name)
        if (length(matches)) {
          value <- trimws(sub("^[^:]*:", "", declarations[[tail(matches, 1L)]]))
          if (value != "inherit") return(value)
        }
      }
      value <- xml2::xml_attr(ancestor, name)
      if (!is.na(value) && value != "inherit") return(value)
    }
    default
  }
  affine <- function(value) {
    result <- diag(3)
    if (is.na(value) || !nzchar(trimws(value))) return(result)
    pattern <- "[A-Za-z]+[[:space:]]*\\([^()]*\\)"
    pieces <- regmatches(value, gregexpr(pattern, value, perl = TRUE))[[1]]
    remaining <- gsub("[[:space:],]", "", gsub(pattern, "", value, perl = TRUE))
    if (!length(pieces) || nzchar(remaining)) {
      stop("Unsupported SVG transform: ", value, call. = FALSE)
    }
    for (piece in pieces) {
      name <- trimws(sub("\\(.*", "", piece))
      arguments <- sub("^[^(]*\\(([^()]*)\\)$", "\\1", piece)
      values <- regmatches(arguments, gregexpr(number_pattern, arguments, perl = TRUE))[[1]]
      remainder <- gsub("[[:space:],]", "", gsub(number_pattern, "", arguments, perl = TRUE))
      values <- as.numeric(values)
      if (nzchar(remainder) || !length(values) || any(!is.finite(values))) {
        stop("Unsupported SVG transform: ", piece, call. = FALSE)
      }
      transform <- diag(3)
      if (name == "translate" && length(values) %in% 1:2) {
        transform[1:2, 3] <- c(values[[1]], if (length(values) == 2L) values[[2]] else 0)
      } else if (name == "scale" && length(values) %in% 1:2) {
        diag(transform) <- c(values[[1]], tail(values, 1L), 1)
      } else if (name == "rotate" && length(values) %in% c(1L, 3L)) {
        angle <- values[[1]] * pi / 180
        transform[1:2, 1:2] <- matrix(c(cos(angle), sin(angle), -sin(angle), cos(angle)), 2)
        if (length(values) == 3L) {
          pivot <- values[2:3]
          transform[1:2, 3] <- pivot - transform[1:2, 1:2] %*% pivot
        }
      } else if (name == "matrix" && length(values) == 6L) {
        transform <- matrix(c(values[1:2], 0, values[3:4], 0, values[5:6], 1), 3)
      } else {
        stop("Unsupported SVG transform: ", piece, call. = FALSE)
      }
      # SVG transform lists act on column vectors from right to left.
      result <- result %*% transform
    }
    result
  }
  measure <- function(node) {
    family <- gsub("^['\"]|['\"]$", "", property(node, "font-family"))
    if (family != "Source Sans 3") {
      stop("Unexpected SVG font family: ", if (nzchar(family)) family else "<missing>", call. = FALSE)
    }
    weight <- property(node, "font-weight", "normal")
    if (!weight %in% c("normal", "400", "bold", "700") || property(node, "font-style", "normal") != "normal") {
      stop("Unsupported SVG font weight or style: ", weight, call. = FALSE)
    }
    if (length(xml2::xml_children(node)) || !is.na(xml2::xml_attr(node, "rotate")) ||
          property(node, "writing-mode", "horizontal-tb") != "horizontal-tb" ||
          !property(node, "dominant-baseline", "auto") %in% c("auto", "alphabetic")) {
      stop("Unsupported SVG text layout.", call. = FALSE)
    }
    size <- number(property(node, "font-size"))
    if (size <= 0) stop("SVG font size must be positive.", call. = FALSE)
    face <- if (weight %in% c("bold", "700")) "Bold" else "Regular"
    font <- system.file("fonts", paste0("SourceSans3-", face, ".otf"), package = "mongolstats", mustWork = TRUE)
    text <- xml2::xml_text(node)
    glyphs <- systemfonts::glyph_info(strsplit(text, "", fixed = TRUE)[[1]], path = font, size = size, res = 72)
    if (any(glyphs$index == 0L)) stop("SVG label contains a glyph missing from its font.", call. = FALSE)
    width <- as.numeric(systemfonts::string_width(text, path = font, size = size, res = 72))
    x <- number(xml2::xml_attr(node, "x"), 0) + number(xml2::xml_attr(node, "dx"), 0)
    y <- number(xml2::xml_attr(node, "y"), 0) + number(xml2::xml_attr(node, "dy"), 0)
    anchor <- property(node, "text-anchor", "start")
    if (!anchor %in% c("start", "middle", "end")) stop("Unsupported SVG text anchor: ", anchor, call. = FALSE)
    left <- x - switch(anchor, middle = width / 2, end = width, 0)
    # Include glyph overhangs as well as natural advance width. Vertical bounds
    # follow the actual label's ascenders/descenders, not an arbitrary line box.
    advances <- c(0, head(cumsum(glyphs$x_advance), -1L))
    right <- left + max(width, advances + glyphs$x_bearing + glyphs$width)
    left <- left + min(0, advances + glyphs$x_bearing)
    top <- y - max(0, glyphs$y_bearing)
    bottom <- y + max(0, glyphs$height - glyphs$y_bearing)
    corners <- rbind(c(left, top, 1), c(right, top, 1), c(left, bottom, 1), c(right, bottom, 1))
    transform <- diag(3)
    transformed <- FALSE
    for (ancestor in xml2::xml_find_all(node, "ancestor-or-self::*")) {
      style <- xml2::xml_attr(ancestor, "style")
      if (!is.na(style) && grepl("(^|;)[[:space:]]*transform[[:space:]]*:", style)) {
        stop("Unsupported CSS SVG transform.", call. = FALSE)
      }
      value <- xml2::xml_attr(ancestor, "transform")
      if (!is.na(value) && nzchar(trimws(value))) {
        transform <- transform %*% affine(value)
        transformed <- TRUE
      }
    }
    list(corners = t(transform %*% t(corners)), transformed = transformed)
  }
  files <- list.files(directory, "[.]svg$", recursive = TRUE)
  problems <- character()
  plots <- 0L
  labels_measured <- 0L
  transformed_labels <- 0L
  for (file in files) {
    doc <- xml2::read_xml(file.path(directory, file))
    plot_groups <- xml2::xml_find_all(
      xml2::xml_root(doc),
      "descendant-or-self::*[contains(concat(' ', normalize-space(@class), ' '), ' svglite ')]"
    )
    if (!length(plot_groups)) next
    plots <- plots + 1L
    box <- as.numeric(strsplit(trimws(xml2::xml_attr(xml2::xml_root(doc), "viewBox")), "[[:space:],]+")[[1]])
    if (length(box) != 4L || any(!is.finite(box)) || any(box[3:4] <= 0)) {
      stop("Invalid SVG viewBox in ", file, call. = FALSE)
    }
    for (node in xml2::xml_find_all(doc, "//*[local-name()='text']")) {
      if (!nzchar(xml2::xml_text(node))) next
      bounds <- tryCatch(measure(node), error = identity)
      if (inherits(bounds, "error")) {
        problems <- c(problems, paste0(file, ": ", conditionMessage(bounds), ": ", xml2::xml_text(node)))
        next
      }
      labels_measured <- labels_measured + 1L
      transformed_labels <- transformed_labels + as.integer(bounds$transformed)
      corners <- bounds$corners
      if (any(!is.finite(corners)) ||
            min(corners[, 1]) < box[[1]] - 0.5 || max(corners[, 1]) > box[[1]] + box[[3]] + 0.5 ||
            min(corners[, 2]) < box[[2]] - 0.5 || max(corners[, 2]) > box[[2]] + box[[4]] + 0.5) {
        limits <- c(range(corners[, 1]), range(corners[, 2]), box[1:2], box[1:2] + box[3:4])
        problems <- c(problems, paste0(
          file, ": label extends beyond the plot canvas: ", xml2::xml_text(node),
          sprintf(
            " [x %.2f..%.2f, y %.2f..%.2f; canvas %.2f,%.2f to %.2f,%.2f]",
            limits[[1]], limits[[2]], limits[[3]], limits[[4]], limits[[5]], limits[[6]], limits[[7]], limits[[8]]
          )
        ))
      }
    }
  }
  if (length(problems)) stop(paste(problems, collapse = "\n"), call. = FALSE)
  list(plots = plots, labels_measured = labels_measured, transformed_labels = transformed_labels)
}

check_site_presentation <- function(directory, max_output_lines = 50L) {
  pages <- list.files(directory, "[.]html$", recursive = TRUE)
  problems <- character()
  for (page in pages) {
    doc <- xml2::read_html(file.path(directory, page))
    headers <- trimws(xml2::xml_text(xml2::xml_find_all(doc, "//main//th")))
    identifiers <- headers[grepl("^[A-Za-z][A-Za-z0-9.]*_[A-Za-z0-9_.]+$", headers)]
    if (length(identifiers)) {
      problems <- c(problems, paste0(
        page, ": table headers need display labels: ",
        paste(unique(identifiers), collapse = ", ")
      ))
    }
    for (block in xml2::xml_text(xml2::xml_find_all(doc, "//main//pre"))) {
      lines <- strsplit(block, "\n", fixed = TRUE)[[1]]
      output <- sum(grepl("^#>", lines))
      if (output > max_output_lines) {
        problems <- c(problems, paste0(
          page, ": console output has ", output,
          " lines; show a concise preview or a summary (limit ", max_output_lines, ")."
        ))
      }
    }
    if (!startsWith(page, "mn/")) {
      prose <- xml2::xml_find_first(doc, "//main")
      xml2::xml_remove(xml2::xml_find_all(prose, paste0(
        ".//pre|.//code|.//script|.//style|",
        ".//*[contains(concat(' ', @class, ' '), ' language-switch ')]"
      )))
      if (grepl("\\p{Cyrillic}", xml2::xml_text(prose), perl = TRUE)) {
        problems <- c(problems, paste0(page, ": English page contains Mongolian prose."))
      }
    }
  }
  if (length(problems)) {
    stop(paste(c("Documentation presentation problems:", problems), collapse = "\n"), call. = FALSE)
  }
  length(pages)
}

check_language_parity <- function(directory) {
  pages <- list.files(directory, "[.]html$", recursive = TRUE)
  english <- pages[!startsWith(pages, "mn/")]
  mongolian <- sub("^mn/", "", pages[startsWith(pages, "mn/")])
  if (!setequal(english, mongolian)) {
    describe <- function(label, missing) {
      if (length(missing)) paste0(label, ": ", paste(missing, collapse = ", "))
    }
    stop("English and Mongolian page coverage differs. ",
      paste(c(
        describe("No Mongolian copy", setdiff(english, mongolian)),
        describe("No English counterpart", file.path("mn", setdiff(mongolian, english)))
      ), collapse = "; "),
      call. = FALSE
    )
  }
  base <- "https://temuulene.github.io/mongolstats/"
  for (page in english) {
    en <- xml2::read_html(file.path(directory, page))
    mn <- xml2::read_html(file.path(directory, "mn", page))
    if (!identical(xml2::xml_attr(xml2::xml_find_first(mn, "//html"), "lang"), "mn")) {
      stop("Mongolian page does not declare lang=mn: ", page, call. = FALSE)
    }
    en_alternate <- xml2::xml_attr(xml2::xml_find_all(en, "//link[@hreflang='mn']"), "href")
    mn_alternate <- xml2::xml_attr(xml2::xml_find_all(mn, "//link[@hreflang='en']"), "href")
    if (!paste0(base, "mn/", page) %in% en_alternate || !paste0(base, page) %in% mn_alternate) {
      stop("Missing matching-page language links: ", page, call. = FALSE)
    }
    images <- function(doc) xml2::xml_attr(xml2::xml_find_all(doc, "//main//img"), "src")
    if (length(images(en)) != length(images(mn))) {
      stop("Figure coverage differs between languages: ", page, call. = FALSE)
    }
  }
  length(english)
}

check_site <- function(directory = "docs") {
  minimums <- c(
    "index.html" = 2L,
    "mn/index.html" = 2L,
    "articles/getting-started.html" = 3L,
    "articles/discovery.html" = 3L,
    "articles/mapping.html" = 5L,
    "articles/environmental-surveillance.html" = 7L,
    "articles/ub-health-environment.html" = 7L,
    "articles/mortality-analysis.html" = 9L
  )
  translated <- minimums[!startsWith(names(minimums), "mn/")]
  names(translated) <- paste0("mn/", names(translated))
  minimums <- c(minimums, translated[!names(translated) %in% names(minimums)])
  figures <- check_site_figures(directory, minimums)
  check_english_home(file.path(directory, "index.html"))
  mongolian <- xml2::read_html(file.path(directory, "mn", "index.html"))
  if (
    !identical(
      xml2::xml_attr(xml2::xml_find_first(mongolian, "//html"), "lang"),
      "mn"
    )
  ) {
    stop("The Mongolian landing page must declare lang=mn", call. = FALSE)
  }
  if (
    !any(
      xml2::xml_attr(xml2::xml_find_all(mongolian, "//a"), "href") ==
        "../index.html",
      na.rm = TRUE
    )
  ) {
    stop(
      "The Mongolian landing page needs an English language link",
      call. = FALSE
    )
  }
  home <- xml2::read_html(file.path(directory, "index.html"))
  if (
    !any(
      grepl(
        "mn/(index[.]html)?$",
        xml2::xml_attr(xml2::xml_find_all(home, "//a"), "href")
      ),
      na.rm = TRUE
    )
  ) {
    stop(
      "The English landing page needs a Mongolian language link",
      call. = FALSE
    )
  }
  sitemap <- xml2::read_xml(file.path(directory, "sitemap.xml"))
  if (
    !any(grepl(
      "/mn/index[.]html$",
      xml2::xml_text(xml2::xml_find_all(sitemap, "//*[local-name()='loc']"))
    ))
  ) {
    stop("The sitemap must include the Mongolian landing page", call. = FALSE)
  }
  pages <- check_site_links(directory)
  translated_pages <- check_language_parity(directory)
  check_site_presentation(directory)
  plot_typography <- check_plot_label_bounds(directory)
  list(
    html_pages = pages, translated_pages = translated_pages,
    plot_files_checked = plot_typography$plots, plot_typography = plot_typography,
    figures = figures, broken_local_references = 0L
  )
}
