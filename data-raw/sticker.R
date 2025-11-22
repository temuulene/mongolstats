library(hexSticker)
library(showtext)

# Load Google Font
font_add_google("Roboto", "roboto")
showtext_auto()

# Generate Sticker using the user-provided image
# The image is saved in data-raw/source_image.png
sticker(
    subplot = "data-raw/source_image.png",
    package = "mongolstats",
    p_size = 20,
    p_y = 0.6, # Adjust text position (move up slightly)
    s_x = 1,
    s_y = 0.85, # Move image down to make room for text
    s_width = 0.5, # Resize image to fit inside hex
    h_fill = "white",
    h_color = "#1A237E", # Dark Blue border
    p_color = "#1A237E", # Dark Blue text
    p_family = "roboto",
    url = "temuulene.github.io/mongolstats",
    u_size = 4.5,
    u_color = "#1A237E",
    filename = "man/figures/logo.png",
    dpi = 300 # High DPI for crispness
)
