# Shared typography for the package's teaching plots. In each fresh R session:
# source(system.file("examples", "plot-style.R", package = "mongolstats"), local = TRUE)
# analysis_plot_font()
# ggplot2::theme_set(analysis_plot_theme())

analysis_plot_font <- local({
  # Keep checkout paths usable if the working directory changes after sourcing.
  checkout_dirs <- vapply(
    c("inst/fonts", "../inst/fonts", "../../inst/fonts"),
    normalizePath, character(1),
    winslash = "/", mustWork = FALSE
  )
  function() {
    files <- c("SourceSans3-Regular.otf", "SourceSans3-Bold.otf")
    paths <- system.file("fonts", files, package = "mongolstats")
    if (length(paths) != 2L || !all(file.exists(paths))) {
      for (directory in checkout_dirs) {
        candidate <- file.path(directory, files)
        if (all(file.exists(candidate))) {
          paths <- candidate
          break
        }
      }
    }
    if (length(paths) != 2L || !all(file.exists(paths))) {
      stop("Bundled Source Sans 3 fonts are missing; reinstall mongolstats or load its source checkout.", call. = FALSE)
    }
    installed <- systemfonts::system_fonts()$family
    for (family in c("Source Sans 3", "sans")) {
      # systemfonts cannot override a family that is installed at OS level.
      if (!family %in% installed) {
        systemfonts::register_font(family, plain = paths[[1]], bold = paths[[2]])
      }
    }
    invisible("Source Sans 3")
  }
})

# svglite resolves generic families before consulting the systemfonts registry.
# Use this device for standalone plots, or pass the equivalent system_fonts
# argument to svglite via knitr's per-device dev.args list.
analysis_plot_svg <- function(..., system_fonts = list()) {
  system_fonts$sans <- analysis_plot_font()
  svglite::svglite(..., system_fonts = system_fonts)
}

analysis_plot_theme <- function(base_size = 11) {
  family <- analysis_plot_font()
  ink <- "#183442"
  muted <- "#536873"
  ggplot2::theme_minimal(base_size = base_size, base_family = family) +
    ggplot2::theme(
      text = ggplot2::element_text(colour = ink),
      plot.title = ggplot2::element_text(
        size = base_size * 1.2, face = "bold", hjust = 0,
        margin = ggplot2::margin(b = 7)
      ),
      plot.subtitle = ggplot2::element_text(
        size = base_size, colour = muted, hjust = 0, lineheight = 1.15,
        margin = ggplot2::margin(b = 12)
      ),
      plot.caption = ggplot2::element_text(
        size = base_size * 0.85, colour = muted, hjust = 0, lineheight = 1.15,
        margin = ggplot2::margin(t = 12)
      ),
      plot.title.position = "plot",
      plot.caption.position = "plot",
      plot.margin = ggplot2::margin(14, 16, 14, 14),
      panel.grid.major = ggplot2::element_line(colour = "#E5ECEF", linewidth = 0.3),
      panel.grid.minor = ggplot2::element_blank(),
      panel.spacing = grid::unit(1.2, "lines"),
      axis.text = ggplot2::element_text(colour = muted, size = base_size * 0.9),
      axis.title = ggplot2::element_text(colour = ink, size = base_size),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 9)),
      axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 9)),
      strip.text = ggplot2::element_text(
        face = "bold", size = base_size, colour = ink,
        margin = ggplot2::margin(t = 8, b = 8)
      ),
      strip.background = ggplot2::element_rect(fill = "#F3F6F7", colour = NA),
      legend.position = "bottom",
      legend.title.position = "top",
      legend.title = ggplot2::element_text(size = base_size * 0.9, colour = ink, hjust = 0),
      legend.text = ggplot2::element_text(size = base_size * 0.9, colour = muted),
      legend.key = ggplot2::element_blank(),
      legend.margin = ggplot2::margin(t = 6),
      plot.background = ggplot2::element_rect(fill = "white", colour = NA)
    )
}

# Keep map axes hidden while sharing typography and a roomy horizontal legend.
analysis_map_theme <- function(base_size = 11) {
  style <- analysis_plot_theme(base_size)
  elements <- c(
    "text", "plot.title", "plot.subtitle", "plot.caption", "plot.margin",
    "plot.title.position", "plot.caption.position", "plot.background",
    "legend.position", "legend.title.position", "legend.title", "legend.text", "legend.key", "legend.margin"
  )
  do.call(ggplot2::theme, lapply(stats::setNames(elements, elements), function(key) style[[key]]))
}
