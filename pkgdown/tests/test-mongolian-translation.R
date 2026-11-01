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
    '<text x="5" y="70">42.5</text>', "</svg>"
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
  testthat::expect_lt(as.numeric(xml2::xml_attr(text[[2]], "textLength")), 46)
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
