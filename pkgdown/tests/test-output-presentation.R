presentation_helpers <- function() {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env()
  sys.source(file.path(root, "tools", "site_helpers.R"), envir = env)
  env
}

testthat::test_that("rendered prose tables require display labels in either language", {
  site <- withr::local_tempdir()
  dir.create(file.path(site, "mn"))
  for (page in c("article.html", "mn/article.html")) {
    writeLines(paste0(
      "<html><body><main><table><thead><tr>",
      "<th>Station</th><th>n_valid_years</th>",
      "</tr></thead></table></main></body></html>"
    ), file.path(site, page))
  }
  result <- tryCatch(presentation_helpers()$check_site_presentation(site), error = identity)
  testthat::expect_s3_class(result, "error")
  testthat::expect_match(conditionMessage(result), "article.html", fixed = TRUE)
  testthat::expect_match(conditionMessage(result), "mn/article.html", fixed = TRUE)
  testthat::expect_match(conditionMessage(result), "n_valid_years", fixed = TRUE)
})

testthat::test_that("accidental long console dumps fail site validation", {
  site <- withr::local_tempdir()
  writeLines(paste0(
    "<html><body><main><pre><code>",
    paste(rep('#&gt; [1] "2024-01-01"', 60), collapse = "\n"),
    "</code></pre></main></body></html>"
  ), file.path(site, "article.html"))
  result <- tryCatch(presentation_helpers()$check_site_presentation(site), error = identity)
  testthat::expect_s3_class(result, "error")
  testthat::expect_match(conditionMessage(result), "console output", fixed = TRUE)
})

testthat::test_that("code identifiers and concise teaching output remain allowed", {
  site <- withr::local_tempdir()
  writeLines(paste0(
    "<html><body><main><pre><code>analysis_month_dates(dust$Month_en)\n",
    '#&gt; [1] "2024-01-01"\n',
    "</code></pre><table><thead><tr><th>Usable years</th>",
    "<th>Station code</th></tr></thead></table></main></body></html>"
  ), file.path(site, "article.html"))
  testthat::expect_identical(presentation_helpers()$check_site_presentation(site), 1L)
})

testthat::test_that("English prose cannot silently retain duplicate Mongolian text", {
  site <- withr::local_tempdir()
  writeLines(paste0(
    "<html><body><main><p>English guide.</p>",
    "<p>Монгол тайлбар.</p></main></body></html>"
  ), file.path(site, "article.html"), useBytes = TRUE)
  result <- tryCatch(presentation_helpers()$check_site_presentation(site), error = identity)
  testthat::expect_s3_class(result, "error")
  testthat::expect_match(conditionMessage(result), "Mongolian prose", fixed = TRUE)
})

testthat::test_that("translated labels must fit the plot canvas at natural width", {
  site <- withr::local_tempdir()
  writeLines(c(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><g class="svglite">',
    '<text x="90" y="30" style="font-size: 20px; font-family: &quot;Source Sans 3&quot;;">Мэдээлэл</text>',
    "</g></svg>"
  ), file.path(site, "plot.svg"), useBytes = TRUE)
  result <- tryCatch(presentation_helpers()$check_plot_label_bounds(site), error = identity)
  testthat::expect_s3_class(result, "error")
  testthat::expect_match(conditionMessage(result), "plot.svg", fixed = TRUE)
  testthat::expect_match(conditionMessage(result), "Мэдээлэл", fixed = TRUE)
})

testthat::test_that("natural-width labels within the canvas pass", {
  site <- withr::local_tempdir()
  writeLines(c(
    '<svg xmlns="http://www.w3.org/2000/svg" class="svglite" viewBox="0 0 200 100">',
    '<text x="10" y="30" style="font-size: 12px; font-family: &quot;Source Sans 3&quot;;">PM2.5</text>',
    "</svg>"
  ), file.path(site, "plot.svg"))
  testthat::expect_identical(
    presentation_helpers()$check_plot_label_bounds(site),
    list(plots = 1L, labels_measured = 1L, transformed_labels = 0L)
  )
})

testthat::test_that("rotated axis labels that cross the top canvas edge fail", {
  site <- withr::local_tempdir()
  writeLines(c(
    '<svg xmlns="http://www.w3.org/2000/svg" class="svglite" viewBox="0 0 100 100">',
    '<text transform="translate(50,10) rotate(-90)"',
    'style="font-size: 14px; font-family: &quot;Source Sans 3&quot;;">Vertical label</text>',
    "</svg>"
  ), file.path(site, "rotated.svg"))
  result <- tryCatch(presentation_helpers()$check_plot_label_bounds(site), error = identity)
  testthat::expect_s3_class(result, "error")
  testthat::expect_match(conditionMessage(result), "rotated.svg", fixed = TRUE)
  testthat::expect_match(conditionMessage(result), "Vertical label", fixed = TRUE)
})

testthat::test_that("interior glyph overhang does not falsely clip a right-aligned label", {
  site <- withr::local_tempdir()
  writeLines(c(
    '<svg xmlns="http://www.w3.org/2000/svg" class="svglite" viewBox="0 0 100 100">',
    '<text x="100" y="50" text-anchor="end"',
    'style="font-size: 9.35px; font-family: &quot;Source Sans 3&quot;;">AVATAR Mg jff </text>',
    "</svg>"
  ), file.path(site, "aligned.svg"))
  testthat::expect_identical(
    presentation_helpers()$check_plot_label_bounds(site),
    list(plots = 1L, labels_measured = 1L, transformed_labels = 0L)
  )
})

testthat::test_that("glyph ascenders and descenders must fit vertically", {
  site <- withr::local_tempdir()
  for (edge in c("top", "bottom")) {
    y <- if (edge == "top") 1 else 99
    writeLines(c(
      '<svg xmlns="http://www.w3.org/2000/svg" class="svglite" viewBox="0 0 100 100">',
      paste0('<text x="20" y="', y, '" style="font-size: 20px; font-family: &quot;Source Sans 3&quot;;">Mg</text>'),
      "</svg>"
    ), file.path(site, paste0(edge, ".svg")))
  }
  result <- tryCatch(presentation_helpers()$check_plot_label_bounds(site), error = identity)
  testthat::expect_s3_class(result, "error")
  testthat::expect_match(conditionMessage(result), "top.svg", fixed = TRUE)
  testthat::expect_match(conditionMessage(result), "bottom.svg", fixed = TRUE)
})

testthat::test_that("common affine transforms compose with ancestors and rotation pivots", {
  site <- withr::local_tempdir()
  writeLines(c(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="10 20 100 100">',
    '<g class="svglite" style="font-family: &quot;Source Sans 3&quot;; font-size: 12px; font-weight: bold;">',
    '<g transform="translate(80,50)"><text transform="rotate(90)">Safe</text></g>',
    '<text transform="translate(80 50) rotate(90)">Safe</text>',
    '<text x="80" y="50" transform="rotate(90,80,50)">Safe</text>',
    '<text x="15" y="45" transform="matrix(1 .1 .1 1 5 10) scale(1.2,.8)" text-anchor="middle">Safe</text>',
    "</g></svg>"
  ), file.path(site, "transformed.svg"))
  testthat::expect_identical(
    presentation_helpers()$check_plot_label_bounds(site),
    list(plots = 1L, labels_measured = 4L, transformed_labels = 4L)
  )
})

testthat::test_that("scaled and ancestor-transformed labels cannot evade any canvas edge", {
  site <- withr::local_tempdir()
  transforms <- c(
    left = "translate(-20,50) scale(2)", right = "matrix(2 0 0 1 90 50)",
    top = "translate(50,-20)", bottom = "translate(50,110) rotate(90)"
  )
  for (edge in names(transforms)) {
    writeLines(c(
      '<svg xmlns="http://www.w3.org/2000/svg" class="svglite" viewBox="0 0 100 100">',
      paste0('<g transform="', transforms[[edge]], '">'),
      '<text style="font-size: 12px; font-family: &quot;Source Sans 3&quot;;">Mg</text>',
      "</g></svg>"
    ), file.path(site, paste0(edge, ".svg")))
  }
  result <- tryCatch(presentation_helpers()$check_plot_label_bounds(site), error = identity)
  testthat::expect_s3_class(result, "error")
  for (edge in names(transforms)) {
    testthat::expect_match(conditionMessage(result), paste0(edge, ".svg"), fixed = TRUE)
  }
})

testthat::test_that("unexpected plot fonts and unsupported transforms fail explicitly", {
  site <- withr::local_tempdir()
  writeLines(c(
    '<svg xmlns="http://www.w3.org/2000/svg" class="svglite" viewBox="0 0 100 100">',
    '<text x="20" y="30" style="font-size: 12px; font-family: Arial;">Wrong font</text>',
    '<g transform="skewX(10)"><text x="20" y="30"',
    'style="font-size: 12px; font-family: &quot;Source Sans 3&quot;;">Skewed</text></g>',
    "</svg>"
  ), file.path(site, "unsupported.svg"))
  result <- tryCatch(presentation_helpers()$check_plot_label_bounds(site), error = identity)
  testthat::expect_s3_class(result, "error")
  testthat::expect_match(conditionMessage(result), "Arial", fixed = TRUE)
  testthat::expect_match(conditionMessage(result), "skewX", fixed = TRUE)
})
