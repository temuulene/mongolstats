site_helpers <- function() {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env()
  sys.source(file.path(root, "tools", "site_helpers.R"), envir = env)
  env
}

testthat::test_that("a package logo cannot satisfy an article's figure requirement", {
  site <- withr::local_tempdir()
  writeLines(
    '<html><body><main><img src="logo.svg"></main></body></html>',
    file.path(site, "article.html")
  )
  result <- tryCatch(
    site_helpers()$check_site_figures(site, c(article.html = 1L)),
    error = identity
  )
  testthat::expect_s3_class(result, "error")
  testthat::expect_match(
    conditionMessage(result),
    "article.html has 0 plots; expected at least 1",
    fixed = TRUE
  )
})

testthat::test_that("a broken plot reference fails verification", {
  site <- withr::local_tempdir()
  writeLines(
    '<html><body><main><img src="plot.png"></main></body></html>',
    file.path(site, "article.html")
  )
  result <- tryCatch(
    site_helpers()$check_site_figures(site, c(article.html = 1L)),
    error = identity
  )
  testthat::expect_s3_class(result, "error")
  testthat::expect_match(
    conditionMessage(result),
    "Missing image in article.html: plot.png",
    fixed = TRUE
  )
})

testthat::test_that("a real rendered plot satisfies the figure requirement", {
  site <- withr::local_tempdir()
  grDevices::png(file.path(site, "plot.png"), width = 600, height = 400)
  graphics::plot(1:3)
  grDevices::dev.off()
  writeLines(
    '<html><body><main><img src="plot.png" alt="Three plotted points"></main></body></html>',
    file.path(site, "article.html")
  )
  result <- site_helpers()$check_site_figures(site, c(article.html = 1L))
  testthat::expect_equal(result$plots, 1L)
})

testthat::test_that("English home prose excludes the explicit language switch", {
  site <- withr::local_tempdir()
  writeLines(
    '<html><body><main><p class="language-switch">Монгол</p><h1>Statistics</h1></main></body></html>',
    file.path(site, "index.html")
  )
  testthat::expect_identical(
    site_helpers()$check_english_home(file.path(site, "index.html")),
    TRUE
  )
  writeLines(
    '<html><body><main><h1>Statistics</h1><p>Эх сурвалж</p></main></body></html>',
    file.path(site, "index.html")
  )
  result <- tryCatch(
    site_helpers()$check_english_home(file.path(site, "index.html")),
    error = identity
  )
  testthat::expect_s3_class(result, "error")
  testthat::expect_match(
    conditionMessage(result),
    "English home page contains Mongolian prose",
    fixed = TRUE
  )
})
