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
