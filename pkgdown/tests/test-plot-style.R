plot_style_env <- function(root) {
  env <- new.env(parent = globalenv())
  sys.source(file.path(root, "inst", "examples", "plot-style.R"), envir = env)
  env
}

testthat::test_that("visible article setup loads the shared plotting helpers", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  files <- c("getting-started", "discovery", "mapping", "environmental-surveillance", "ub-health-environment", "articles/mortality-analysis")
  old <- knitr::opts_chunk$get()
  old_theme <- ggplot2::theme_get()
  on.exit({
    knitr::opts_chunk$restore(old)
    ggplot2::theme_set(old_theme)
  }, add = TRUE)
  withr::local_options()
  withr::local_envvar(c(IN_PKGDOWN = "true", NOT_CRAN = "", `_R_CHECK_PACKAGE_NAME_` = ""))
  for (article in files) {
    lines <- readLines(file.path(root, "vignettes", paste0(article, ".Rmd")), encoding = "UTF-8")
    starts <- grep("^```\\{r (not-cran-check|setup|load-packages)[,}]", lines)
    text <- unlist(lapply(starts, function(start) {
      end <- which(lines == "```" & seq_along(lines) > start)[[1]]
      c(lines[seq.int(start, end)], "")
    }))
    env <- new.env(parent = globalenv())
    knitr::opts_chunk$set(eval = TRUE, error = FALSE, message = FALSE)
    knitr::knit(text = text, envir = env, quiet = TRUE)
    testthat::expect_type(env$analysis_map_theme, "closure")
    if (is.function(env$analysis_plot_theme)) {
      testthat::expect_identical(env$analysis_plot_theme()$text$family, "Source Sans 3")
    }
  }
})

testthat::test_that("bundled plot fonts contain Mongolian Cyrillic in both weights", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  for (weight in c("Regular", "Bold")) {
    path <- file.path(root, "inst", "fonts", paste0("SourceSans3-", weight, ".otf"))
    glyphs <- systemfonts::glyph_info(strsplit("\u04e8\u04ae\u04e9\u04af\u0439", "")[[1]], path = path)
    testthat::expect_gt(min(glyphs$index), 0L)
    testthat::expect_equal(systemfonts::font_info(path = path)$family, "Source Sans 3")
  }
})

testthat::test_that("shared plot theme has readable typography and clear hierarchy", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  withr::local_dir(root)
  env <- plot_style_env(root)
  theme <- env$analysis_plot_theme(base_size = 12)
  testthat::expect_s3_class(theme, "theme")
  testthat::expect_equal(theme$text$family, "Source Sans 3")
  testthat::expect_equal(theme$text$size, 12)
  testthat::expect_equal(theme$text$colour, "#183442")
  testthat::expect_equal(theme$plot.title$face, "bold")
  testthat::expect_equal(theme$plot.subtitle$colour, "#536873")
  testthat::expect_equal(theme$plot.title$hjust, 0)
  testthat::expect_equal(theme$plot.subtitle$hjust, 0)
  testthat::expect_equal(theme$plot.caption$hjust, 0)
  testthat::expect_equal(theme$legend.position, "bottom")
  testthat::expect_s3_class(theme$panel.grid.minor, "element_blank")
  testthat::expect_equal(theme$strip.text$face, "bold")
  testthat::expect_gte(min(as.numeric(theme$plot.margin)), 10)
})

testthat::test_that("fresh source and pkgload sessions render the bundled font for sans", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  result <- callr::r(function(root) {
    pkgload::load_all(root, quiet = TRUE)
    env <- new.env(parent = globalenv())
    helper <- system.file("examples", "plot-style.R", package = "mongolstats", mustWork = TRUE)
    sys.source(helper, envir = env)
    setwd(tempdir())
    family <- env$analysis_plot_font()
    env$analysis_plot_font()
    file <- tempfile(fileext = ".svg")
    env$analysis_plot_svg(file, width = 4, height = 3)
    p <- ggplot2::ggplot(data.frame(x = 1, y = 2), ggplot2::aes(x, y)) +
      ggplot2::geom_point() +
      ggplot2::labs(title = "\u04e8\u04ae\u04e9\u04af\u0439 2026") +
      env$analysis_plot_theme() +
      ggplot2::theme(text = ggplot2::element_text(family = "sans"))
    print(p)
    grDevices::dev.off()
    list(
      family = family,
      plain = systemfonts::match_fonts("sans")$path,
      bold = systemfonts::match_fonts("sans", weight = "bold")$path,
      svg = paste(readLines(file, encoding = "UTF-8"), collapse = "\n")
    )
  }, args = list(root = root))
  testthat::expect_equal(result$family, "Source Sans 3")
  testthat::expect_equal(basename(result$plain), "SourceSans3-Regular.otf")
  testthat::expect_equal(basename(result$bold), "SourceSans3-Bold.otf")
  testthat::expect_match(result$svg, "font-family: .Source Sans 3.")
  testthat::expect_match(result$svg, "\u04e8\u04ae\u04e9\u04af\u0439 2026", fixed = TRUE)
})

testthat::test_that("plot SVGs embed original fonts without changing data or geometry", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  withr::local_dir(root)
  env <- plot_style_env(root)
  sys.source(file.path(root, "tools", "plot_fonts.R"), envir = env)
  directory <- withr::local_tempdir()
  path <- file.path(directory, "plot.svg")
  svglite::svglite(path, width = 4, height = 3)
  p <- ggplot2::ggplot(data.frame(x = 1:3, y = c(2, 5, 4)), ggplot2::aes(x, y)) +
    ggplot2::geom_line() +
    ggplot2::geom_point() +
    ggplot2::labs(title = "\u04e8\u04ae\u04e9\u04af\u0439", caption = "1,234.50 \u2014 2026") +
    env$analysis_plot_theme()
  print(p)
  grDevices::dev.off()
  original <- readBin(path, "raw", n = file.info(path)$size)
  before <- xml2::read_xml(original)
  testthat::expect_identical(env$embed_plot_fonts(directory, root = root), path)
  first <- readBin(path, "raw", n = file.info(path)$size)
  after <- xml2::read_xml(first)
  styles <- xml2::xml_find_all(after, ".//*[local-name()='style'][@id='mongolstats-plot-fonts']")
  testthat::expect_length(styles, 1L)
  css <- xml2::xml_text(styles)
  testthat::expect_match(css, "font-family: 'Source Sans 3'", fixed = TRUE)
  testthat::expect_match(css, "font-weight: 400", fixed = TRUE)
  testthat::expect_match(css, "font-weight: 700", fixed = TRUE)
  uris <- regmatches(css, gregexpr("data:font/woff2;base64,[A-Za-z0-9+/=]+", css))[[1]]
  testthat::expect_length(uris, 2L)
  for (i in seq_along(uris)) {
    name <- paste0("SourceSans3-", c("Regular", "Bold")[[i]], ".otf.woff2")
    font <- file.path(root, "pkgdown", "fonts", name)
    testthat::expect_identical(
      jsonlite::base64_dec(sub("data:font/woff2;base64,", "", uris[[i]], fixed = TRUE)),
      readBin(font, "raw", n = file.info(font)$size)
    )
  }
  xml2::xml_remove(styles)
  testthat::expect_identical(as.character(after), as.character(before))
  # Insertion must leave every original byte intact, including SVG coordinates.
  stripped <- sub(
    "(?s)\n<style id=\"mongolstats-plot-fonts\".*?</style>\n", "", rawToChar(first),
    perl = TRUE
  )
  testthat::expect_identical(charToRaw(stripped), original)
  testthat::expect_length(env$embed_plot_fonts(directory, root = root), 0L)
  testthat::expect_identical(readBin(path, "raw", n = file.info(path)$size), first)
})

testthat::test_that("font embedding leaves badges logos and text-free SVGs untouched", {
  root <- normalizePath(testthat::test_path("..", ".."), winslash = "/")
  env <- new.env(parent = globalenv())
  sys.source(file.path(root, "tools", "plot_fonts.R"), envir = env)
  directory <- withr::local_tempdir()
  samples <- list(
    badge = '<svg xmlns="http://www.w3.org/2000/svg"><text>passing</text></svg>',
    logo = '<svg xmlns="http://www.w3.org/2000/svg"><path d="M0 0 L1 1"/></svg>',
    empty = '<svg xmlns="http://www.w3.org/2000/svg" class="svglite"><rect width="2" height="2"/></svg>'
  )
  for (name in names(samples)) {
    writeLines(samples[[name]], file.path(directory, paste0(name, ".svg")), useBytes = TRUE)
  }
  testthat::expect_length(env$embed_plot_fonts(directory, root = root), 0L)
  for (name in names(samples)) {
    testthat::expect_equal(
      readLines(file.path(directory, paste0(name, ".svg"))),
      samples[[name]]
    )
  }
})
