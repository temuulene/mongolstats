tryCatch(
    {
        pkgload::load_all()
        message("Rebuilding PXWeb index... this may take a while...")
        # We use the function we just refactored
        idx <- nso_rebuild_px_index(write = TRUE)
        message(sprintf("Index built successfully with %d tables.", nrow(idx)))
    },
    error = function(e) {
        message("Failed to rebuild index: ", e$message)
        quit(status = 1)
    }
)
