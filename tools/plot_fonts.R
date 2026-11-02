# Embed the original web fonts inside plot SVGs: external stylesheets and web
# fonts are unavailable when browsers display an SVG through an HTML <img>.
# Run after rendering and translation; coordinates and text remain untouched.
embed_plot_fonts <- function(destination, root = ".") {
  if (!dir.exists(destination)) {
    stop("Plot SVG directory does not exist: ", destination, call. = FALSE)
  }
  files <- list.files(destination, pattern = "[.]svg$", recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
  css <- NULL
  changed <- character()
  for (path in files) {
    original <- rawToChar(readBin(path, "raw", n = file.info(path)$size))
    # Avoid parsing unrelated assets, especially badges and the package logo.
    if (!grepl("svglite", original, fixed = TRUE)) next
    document <- xml2::read_xml(charToRaw(original))
    svg <- xml2::xml_root(document)
    plot_groups <- xml2::xml_find_all(
      svg, "descendant-or-self::*[contains(concat(' ', normalize-space(@class), ' '), ' svglite ')]"
    )
    if (!length(plot_groups) ||
          !length(xml2::xml_find_all(svg, ".//*[local-name()='text']"))) {
      next
    }
    if (length(xml2::xml_find_all(svg, ".//*[local-name()='style'][@id='mongolstats-plot-fonts']"))) next
    if (is.null(css)) {
      names <- paste0("SourceSans3-", c("Regular", "Bold"), ".otf.woff2")
      fonts <- file.path(root, "pkgdown", "fonts", names)
      if (!all(file.exists(fonts))) {
        stop("Bundled Source Sans 3 web fonts are missing under pkgdown/fonts.", call. = FALSE)
      }
      faces <- vapply(seq_along(fonts), function(i) {
        binary <- readBin(fonts[[i]], "raw", n = file.info(fonts[[i]])$size)
        encoded <- gsub("[\r\n]", "", jsonlite::base64_enc(binary))
        paste0(
          "@font-face { font-family: 'Source Sans 3'; font-style: normal; font-weight: ",
          c(400L, 700L)[[i]], "; src: url('data:font/woff2;base64,",
          encoded, "') format('woff2'); }"
        )
      }, character(1))
      license <- trimws(readLines(file.path(root, "pkgdown", "fonts", "LICENSE.md"), warn = FALSE), which = "right")
      css <- paste0(
        "\n<style id=\"mongolstats-plot-fonts\" type=\"text/css\"><![CDATA[\n",
        "/*\n", paste(license, collapse = "\n"), "\n*/\n",
        paste(faces, collapse = "\n"), "\n]]></style>\n"
      )
    }
    opening <- regexpr("<svg\\b[^>]*>", original, perl = TRUE)
    if (opening[[1]] < 0L) stop("Cannot locate plot SVG root: ", path, call. = FALSE)
    end <- opening[[1]] + attr(opening, "match.length")[[1]] - 1L
    # Insert rather than XML-serialize, preserving all original bytes exactly.
    embedded <- paste0(substr(original, 1L, end), css, substring(original, end + 1L))
    writeBin(charToRaw(embedded), path)
    changed <- c(changed, path)
  }
  invisible(changed)
}
