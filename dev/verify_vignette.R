tryCatch({
  rmarkdown::render("vignettes/ub-health-environment.Rmd", output_format = "html_document")
  print("Vignette rendered successfully!")
}, error = function(e) {
  print(paste("Error rendering vignette:", e$message))
  quit(status = 1)
})
