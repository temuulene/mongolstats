translation_helpers <- function() {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env(parent = globalenv())
  sys.source(file.path(root, "pkgdown", "mn", "translate.R"), envir = env)
  env
}

testthat::test_that("translation templates retain prose and protect numeric values and code", {
  env <- translation_helpers()
  doc <- xml2::read_html("<p>Counts in <code>nso_data()</code>\nremain 42, not zero.</p>")
  template <- env$mn_template(xml2::xml_find_first(doc, "//p"))
  testthat::expect_identical(template$source, "Counts in {1} remain {2}, not zero.")
  restored <- env$mn_unbind("{2} counts remain in {1}.", template, html = TRUE)
  testthat::expect_match(restored, "42 counts remain in <code>nso_data()</code>.", fixed = TRUE)
  testthat::expect_error(env$mn_unbind("A different value", template), "protected")
})

testthat::test_that("SVG badge titles and accessible labels are translated", {
  env <- translation_helpers()
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  path <- file.path(withr::local_tempdir(), "badge.svg")
  file.copy(file.path(root, "man", "figures", "lifecycle-experimental.svg"), path)
  catalogue <- env$mn_catalogue(root)
  env$mn_translate_svg(path, "badge.svg", catalogue)
  doc <- xml2::read_xml(path)
  testthat::expect_identical(xml2::xml_text(xml2::xml_find_first(doc, "//*[local-name()='title']")), "төлөв: туршилтын")
  testthat::expect_identical(xml2::xml_attr(xml2::xml_root(doc), "aria-label"), "төлөв: туршилтын")
  node <- xml2::xml_find_all(doc, "//*[local-name()='text']")[[2]]
  testthat::expect_true(is.na(xml2::xml_attr(node, "textLength")))
  testthat::expect_true(is.na(xml2::xml_attr(node, "lengthAdjust")))
})

testthat::test_that("lifecycle badge cells fit natural translated text and its shadows", {
  env <- translation_helpers()
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  sources <- list.files(file.path(root, "man", "figures"), "^lifecycle-.*[.]svg$", full.names = TRUE)
  testthat::expect_gte(length(sources), 4L)
  catalogue <- env$mn_catalogue(root)
  path <- file.path(withr::local_tempdir(), "not-a-lifecycle-filename.svg")
  for (source in sources) {
    before <- xml2::read_xml(source)
    old_width <- as.numeric(xml2::xml_attr(before, "width"))
    xml2::xml_set_attr(before, "viewBox", paste(0, 0, old_width, 20))
    # Exercise title-only and aria-label-only recognition, independently of filename.
    if (grepl("stable", source, fixed = TRUE)) {
      xml2::xml_set_attr(before, "aria-label", NULL)
    } else {
      xml2::xml_remove(xml2::xml_find_all(before, "//*[local-name()='title']"))
    }
    xml2::write_xml(before, path)
    suppressMessages(env$mn_translate_svg(path, "badge.svg", catalogue))
    after <- xml2::read_xml(path)
    backgrounds <- xml2::xml_find_all(after, "//*[local-name()='g'][@clip-path]/*[local-name()='rect']")
    cells <- as.numeric(xml2::xml_attr(backgrounds[1:2], "width"))
    total <- as.numeric(xml2::xml_attr(after, "width"))
    testthat::expect_equal(total, sum(cells), info = basename(source))
    testthat::expect_gte(total, old_width)
    testthat::expect_equal(as.numeric(xml2::xml_attr(backgrounds[[2]], "x")), cells[[1]])
    testthat::expect_equal(as.numeric(xml2::xml_attr(backgrounds[[3]], "width")), total)
    clip <- xml2::xml_find_first(after, "//*[local-name()='clipPath']/*[local-name()='rect']")
    testthat::expect_equal(as.numeric(xml2::xml_attr(clip, "width")), total)
    testthat::expect_equal(xml2::xml_attr(clip, "rx"), "3")
    testthat::expect_equal(xml2::xml_attr(after, "viewBox"), paste(0, 0, total, 20))
    text <- xml2::xml_find_all(after, "//*[local-name()='text']")
    natural <- systemfonts::string_width(xml2::xml_text(text), family = "Verdana", size = 110, res = 72) * 0.1
    centres <- as.numeric(xml2::xml_attr(text, "x")) * 0.1
    cell <- match(centres, sort(unique(centres)))
    left <- c(0, cells[[1]])[cell]
    right <- c(cells[[1]], total)[cell]
    testthat::expect_true(all(centres - natural / 2 >= left + 4), info = basename(source))
    testthat::expect_true(all(centres + natural / 2 <= right - 4), info = basename(source))
    testthat::expect_true(all(is.na(xml2::xml_attr(text, "textLength"))))
    testthat::expect_true(all(is.na(xml2::xml_attr(text, "lengthAdjust"))))
    original_text <- xml2::xml_find_all(before, "//*[local-name()='text']")
    for (attribute in c("y", "transform", "fill", "fill-opacity", "aria-hidden")) {
      testthat::expect_identical(xml2::xml_attr(text, attribute), xml2::xml_attr(original_text, attribute))
    }
    gradient <- "//*[local-name()='linearGradient']"
    testthat::expect_identical(
      as.character(xml2::xml_find_first(after, gradient)),
      as.character(xml2::xml_find_first(before, gradient))
    )
    testthat::expect_equal(xml2::xml_attr(backgrounds[[3]], "fill"), "url(#s)")
    testthat::expect_equal(xml2::xml_attr(xml2::xml_parent(backgrounds[[1]]), "clip-path"), "url(#r)")
  }
})

testthat::test_that("old development URLs resolve within the selected language", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env(parent = globalenv())
  sys.source(file.path(root, "pkgdown", "build-mn.R"), envir = env)
  site <- withr::local_tempdir()
  dir.create(file.path(site, "reference"))
  writeLines("<html><body>Reference</body></html>", file.path(site, "reference", "example.html"))
  env$build_development_aliases(site)
  doc <- xml2::read_html(file.path(site, "dev", "reference", "example.html"))
  target <- xml2::xml_attr(xml2::xml_find_first(doc, "//main//a"), "href")
  testthat::expect_identical(target, "../../reference/example.html")
  testthat::expect_identical(
    as.character(fs::path_norm(file.path("mn", "dev", "reference", target))),
    "mn/reference/example.html"
  )
})

testthat::test_that("figure translation preserves numerical labels and plot geometry", {
  env <- translation_helpers()
  directory <- withr::local_tempdir()
  path <- file.path(directory, "plot.svg")
  writeLines(c(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 120">',
    '<circle cx="42" cy="70" r="3"/>',
    '<text x="10" y="15" textLength="70" style="font-size: 11px; font-family: sans;">Deaths per day</text>',
    '<text x="50" y="100" text-anchor="middle" textLength="16">Jan</text>',
    '<text x="100" y="100" text-anchor="middle" textLength="16">Feb</text>',
    '<text x="5" y="70" textLength="23" lengthAdjust="spacingAndGlyphs">42.5</text>', "</svg>"
  ), path)
  before <- xml2::read_xml(path)
  lookup <- c("Deaths per day" = "Өдрийн нас баралт", "Jan" = "I сар", "Feb" = "II сар")
  catalogue <- list(translate = function(template, ...) {
    if (template$source %in% names(lookup)) lookup[[template$source]] else NULL
  })
  env$mn_translate_svg(path, "plot.svg", catalogue)
  after <- xml2::read_xml(path)
  text <- xml2::xml_find_all(after, "//*[local-name()='text']")
  testthat::expect_identical(xml2::xml_text(text), c(unname(lookup), "42.5"))
  coordinates <- function(doc) {
    lapply(xml2::xml_find_all(doc, "//*[local-name()='text']"), function(node) {
      xml2::xml_attrs(node)[c("x", "y")]
    })
  }
  testthat::expect_identical(coordinates(before), coordinates(after))
  testthat::expect_identical(
    as.character(xml2::xml_find_first(before, "//*[local-name()='circle']")),
    as.character(xml2::xml_find_first(after, "//*[local-name()='circle']"))
  )
  testthat::expect_true(all(is.na(xml2::xml_attr(text[1:3], "textLength"))))
  testthat::expect_identical(
    as.character(xml2::xml_find_first(before, "//*[local-name()='text'][4]")),
    as.character(text[[4]])
  )
})

testthat::test_that("long and rotated Cyrillic labels retain natural glyph widths", {
  env <- translation_helpers()
  path <- file.path(withr::local_tempdir(), "long-labels.svg")
  writeLines(c(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 120">',
    '<path d="M20 90 L180 20"/><circle cx="42" cy="70" r="3"/>',
    '<text x="10" y="15" style="font-size: 12px; font-family: sans; font-weight: bold;"',
    ' textLength="20" lengthAdjust="spacingAndGlyphs">Long title</text>',
    '<text transform="translate(15,100) rotate(-90)" style="font-size: 12px; font-family: sans; font-style: italic;"',
    ' textLength="16" lengthAdjust="spacingAndGlyphs">Rotated label</text>',
    "</svg>"
  ), path)
  before <- xml2::read_xml(path)
  lookup <- c(
    "Long title" = "Насны бүтцээр стандартчилсан өвчлөлийн түвшин",
    "Rotated label" = "Нэг мянган оршин суугч тутамд бүртгэгдсэн нас баралт"
  )
  catalogue <- list(translate = function(template, ...) lookup[[template$source]])
  suppressMessages(env$mn_translate_svg(path, "long-labels.svg", catalogue))
  after <- xml2::read_xml(path)
  text <- xml2::xml_find_all(after, "//*[local-name()='text']")
  natural <- systemfonts::string_width(
    unname(lookup),
    family = "sans", size = 12, res = 72,
    weight = c("bold", "normal"), italic = c(FALSE, TRUE)
  )
  testthat::expect_true(all(natural > c(20, 16)))
  testthat::expect_identical(xml2::xml_text(text), unname(lookup))
  # Without either length attribute, SVG renders the natural font advance.
  testthat::expect_true(all(is.na(xml2::xml_attr(text, "textLength"))))
  testthat::expect_true(all(is.na(xml2::xml_attr(text, "lengthAdjust"))))
  for (node in xml2::xml_find_all(before, "//*[local-name()='text']")) {
    xml2::xml_set_attr(node, "textLength", NULL)
    xml2::xml_set_attr(node, "lengthAdjust", NULL)
  }
  attributes <- function(doc) {
    lapply(xml2::xml_find_all(doc, ".//*"), xml2::xml_attrs)
  }
  testthat::expect_identical(attributes(after), attributes(before))
  testthat::expect_identical(xml2::xml_attrs(after), xml2::xml_attrs(before))
})

testthat::test_that("layout measurements respect inherited and inline font faces", {
  env <- translation_helpers()
  path <- file.path(withr::local_tempdir(), "font-faces.svg")
  writeLines(c(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 120">',
    '<g font-family="sans" font-size="12" font-weight="700" font-style="italic">',
    '<text x="10" y="15" textLength="20">Inherited face</text>',
    '<text x="10" y="35" textLength="20" style="font-weight: normal; font-style: normal;">Inline face</text>',
    "</g></svg>"
  ), path)
  measured <- list()
  testthat::local_mocked_bindings(
    string_width = function(strings, family, size, res, weight = "normal", italic = FALSE, ...) {
      measured[[length(measured) + 1L]] <<- list(family = family, size = size, weight = weight, italic = italic)
      300
    },
    .package = "systemfonts"
  )
  catalogue <- list(translate = function(template, ...) "Өвчлөлийн түвшин")
  suppressMessages(env$mn_translate_svg(path, "font-faces.svg", catalogue))
  testthat::expect_identical(measured, list(
    list(family = "sans", size = 12, weight = 700, italic = TRUE),
    list(family = "sans", size = 12, weight = "normal", italic = FALSE)
  ))
})

testthat::test_that("language parity requires every page and matching alternate links", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env(parent = globalenv())
  sys.source(file.path(root, "tools", "site_helpers.R"), envir = env)
  site <- withr::local_tempdir()
  dir.create(file.path(site, "mn"))
  base <- "https://temuulene.github.io/mongolstats/"
  write_page <- function(path, lang, alternate_lang, alternate_url) {
    writeLines(paste0(
      '<html lang="', lang, '"><head><link rel="alternate" hreflang="',
      alternate_lang, '" href="', alternate_url,
      '"></head><body><main><h1>Example</h1></main></body></html>'
    ), path)
  }
  write_page(file.path(site, "index.html"), "en", "mn", paste0(base, "mn/index.html"))
  testthat::expect_error(env$check_language_parity(site), "coverage differs")
  write_page(file.path(site, "mn", "index.html"), "mn", "en", paste0(base, "index.html"))
  testthat::expect_identical(env$check_language_parity(site), 1L)
  write_page(file.path(site, "mn", "index.html"), "en", "en", paste0(base, "index.html"))
  testthat::expect_error(env$check_language_parity(site), "lang=mn")
  write_page(file.path(site, "mn", "index.html"), "mn", "en", paste0(base, "wrong.html"))
  testthat::expect_error(env$check_language_parity(site), "matching-page")
})

testthat::test_that("language parity names pages missing in either language", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env(parent = globalenv())
  sys.source(file.path(root, "tools", "site_helpers.R"), envir = env)
  site <- withr::local_tempdir()
  dir.create(file.path(site, "mn", "articles"), recursive = TRUE)
  writeLines("<html></html>", file.path(site, "index.html"))
  writeLines("<html></html>", file.path(site, "news.html"))
  writeLines("<html></html>", file.path(site, "mn", "index.html"))
  writeLines("<html></html>", file.path(site, "mn", "articles", "extra.html"))
  parity_error <- function() {
    tryCatch(
      {
        env$check_language_parity(site)
        ""
      },
      error = conditionMessage
    )
  }
  message <- parity_error()
  testthat::expect_match(message, "coverage differs", fixed = TRUE)
  testthat::expect_match(message, "No Mongolian copy: news.html", fixed = TRUE)
  testthat::expect_match(
    message, "No English counterpart: mn/articles/extra.html",
    fixed = TRUE
  )
  unlink(file.path(site, "news.html"))
  message <- parity_error()
  testthat::expect_false(grepl("No Mongolian copy", message, fixed = TRUE))
  testthat::expect_match(
    message, "No English counterpart: mn/articles/extra.html",
    fixed = TRUE
  )
  unlink(file.path(site, "mn", "articles", "extra.html"))
  writeLines("<html></html>", file.path(site, "news.html"))
  message <- parity_error()
  testthat::expect_match(message, "No Mongolian copy: news.html", fixed = TRUE)
  testthat::expect_false(grepl("No English counterpart", message, fixed = TRUE))
})

testthat::test_that("ordinary linked labels need translation", {
  env <- translation_helpers()
  doc <- xml2::read_html('<li><a href="reference/index.html">Reference</a></li>')
  template <- env$mn_template(xml2::xml_find_first(doc, "//li"))
  testthat::expect_match(template$source, "Reference", fixed = TRUE)
  testthat::expect_false(env$mn_technical(template$source))
  testthat::expect_true(env$mn_technical("nso_data"))
})

testthat::test_that("missing translations stop publication instead of falling back to English", {
  env <- translation_helpers()
  directory <- withr::local_tempdir()
  catalogue <- env$mn_catalogue(directory)
  doc <- xml2::read_html("<html><head><title>Example</title></head><body><p>New narrative text.</p></body></html>")
  env$mn_translate_document(doc, "article.html", catalogue)
  testthat::expect_error(
    suppressMessages(env$mn_write_catalogue(catalogue, file.path(directory, "source.json"))),
    "untranslated documentation"
  )
  testthat::expect_true(file.exists(file.path(directory, "source.json")))
})

testthat::test_that("article-list titles are translated while argument names stay intact", {
  env <- translation_helpers()
  doc <- xml2::read_html(paste0(
    "<html><body><dl>",
    '<dt><a href="mapping.html">Spatial Epidemiology with mongolstats</a></dt>',
    '<dt id="arg-labels">labels</dt>',
    "</dl></body></html>"
  ))
  seen <- character()
  catalogue <- list(translate = function(template, ...) {
    seen <<- c(seen, template$source)
    if (identical(template$source, "{1}Spatial Epidemiology with mongolstats{2}")) {
      env$mn_unbind("{1}mongolstats ашигласан орон зайн эпидемиологи{2}", template, html = TRUE)
    }
  })
  env$mn_translate_document(doc, "articles/index.html", catalogue)
  terms <- xml2::xml_text(xml2::xml_find_all(doc, "//dt"))
  testthat::expect_identical(terms, c("mongolstats ашигласан орон зайн эпидемиологи", "labels"))
  testthat::expect_false("labels" %in% seen)
  testthat::expect_identical(
    xml2::xml_attr(xml2::xml_find_first(doc, "//dt/a"), "href"), "mapping.html"
  )
})

testthat::test_that("protected code keeps backslashes and brace text literally", {
  env <- translation_helpers()
  doc <- xml2::read_html('<p>Match <code>grepl("\\d{2}", x)</code> or <code>[0-9]{1}</code>.</p>')
  template <- env$mn_template(xml2::xml_find_first(doc, "//p"))
  testthat::expect_identical(template$source, "Match {1} or {2}.")
  restored <- env$mn_unbind("{2} эсвэл {1}-ийг тааруулна.", template, html = TRUE)
  testthat::expect_identical(
    restored,
    '<code>[0-9]{1}</code> эсвэл <code>grepl("\\d{2}", x)</code>-ийг тааруулна.'
  )
})
