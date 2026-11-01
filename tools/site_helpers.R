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
  list(
    html_pages = pages, translated_pages = translated_pages,
    figures = figures, broken_local_references = 0L
  )
}
