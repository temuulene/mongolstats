library(ggplot2)
library(sf)
library(mongolstats)
library(dplyr)

# 1. Get Mongolia Map and Normalize
map <- mn_boundaries(level = "ADM0")
bbox <- st_bbox(map)

# Calculate center and scale
x_range <- bbox["xmax"] - bbox["xmin"]
y_range <- bbox["ymax"] - bbox["ymin"]
center_x <- bbox["xmin"] + x_range / 2
center_y <- bbox["ymin"] + y_range / 2
scale_factor <- max(x_range, y_range)

# Shift and Scale function
normalize_geometry <- function(geom) {
    (geom - c(center_x, center_y)) / scale_factor * 1.8 # Scale to fit nicely in hex (approx width 2)
}

st_geometry(map) <- normalize_geometry(st_geometry(map))

# 2. Create Hexagon Data
# Hexagon points (flat topped)
angles <- seq(30, 390, length.out = 7) * pi / 180
hex_df <- tibble::tibble(
    x = cos(angles),
    y = sin(angles)
)

# 3. Create the Plot
p <- ggplot() +
    # Hexagon Background (White fill, Dark Blue border)
    geom_polygon(data = hex_df, aes(x, y), fill = "white", color = "#1A237E", linewidth = 1.5) +

    # Map (Teal/Green fill)
    geom_sf(data = map, fill = "#42b883", color = NA, alpha = 0.9) +

    # Text
    annotate("text",
        x = 0, y = -0.6, label = "mongolstats",
        color = "#1A237E", size = 8, fontface = "bold", family = "sans"
    ) +

    # Decoration: Simple trend line overlay
    annotate("segment", x = -0.5, y = -0.2, xend = -0.2, yend = 0.1, color = "white", linewidth = 1) +
    annotate("segment", x = -0.2, y = 0.1, xend = 0.1, yend = 0, color = "white", linewidth = 1) +
    annotate("segment", x = 0.1, y = 0, xend = 0.5, yend = 0.4, color = "white", linewidth = 1) +

    # Theme
    theme_void() +
    coord_sf(datum = NA) +
    theme(plot.margin = margin(0, 0, 0, 0))

# Save
ggsave("man/figures/logo.png", plot = p, width = 2, height = 2.3, dpi = 600, bg = "transparent")
