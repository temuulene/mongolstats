testthat::test_that("rebuilding the mirror keeps language links and sitemaps valid", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env(parent = globalenv())
  sys.source(file.path(root, "pkgdown", "build-mn.R"), envir = env)
  site <- withr::local_tempdir()
  dir.create(file.path(site, "reference"))
  for (page in c("index.html", "reference/nso_data.html")) {
    switch <- if (startsWith(page, "reference/")) "../mn/index.html" else "mn/index.html"
    writeLines(paste0(
      '<html lang="en"><head><title>mongolstats</title></head><body><nav><a href="',
      switch, '">Монгол</a></nav><main><h1>mongolstats</h1></main></body></html>'
    ), file.path(site, page), useBytes = TRUE)
  }
  base <- "https://temuulene.github.io/mongolstats/"
  writeLines(paste0(
    '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">',
    "<url><loc>", base, "index.html</loc></url>",
    "<url><loc>", base, "reference/nso_data.html</loc></url></urlset>"
  ), file.path(site, "sitemap.xml"))
  writeLines("", file.path(site, "pkgdown.js"))
  for (i in 1:2) env$build_mongolian_site(root, file.path(site, "mn"))
  mn <- xml2::read_html(file.path(site, "mn", "reference", "nso_data.html"))
  testthat::expect_identical(
    xml2::xml_attr(xml2::xml_find_first(mn, "//nav/a"), "href"),
    "../../reference/nso_data.html"
  )
  sitemap <- xml2::read_xml(file.path(site, "mn", "sitemap.xml"))
  locations <- xml2::xml_text(xml2::xml_find_all(sitemap, "//*[local-name()='loc']"))
  testthat::expect_setequal(locations, paste0(base, "mn/", c("index.html", "reference/nso_data.html")))
})
