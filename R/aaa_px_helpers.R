.px_strip_bom <- function(x) {
  if (is.character(x) && length(x) == 1L) {
    sub("^\uFEFF", "", x, useBytes = TRUE)
  } else {
    x
  }
}

.px_first_nonempty <- function(...) {
  args <- list(...)
  for (a in args) {
    if (is.null(a) || !length(a)) {
      next
    }
    val <- as.character(a)[1]
    if (!is.na(val) && nzchar(val)) {
      return(val)
    }
  }
  NULL
}

# Normalize possibly nested/listed character vectors from PXWeb metadata
.px_chr <- function(x) {
  as.character(unlist(x, use.names = FALSE))
}

# Resolve a tbl_id to its px_file, index row, and path segments.
# Returns a list with $px_file, $row (tibble), and $paths (character vector).
# Raises an error if the table is not found in the index.
.px_resolve_table <- function(tbl_id, idx = .px_index()) {
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) {
    tbl_id
  } else {
    paste0(tbl_id, ".px")
  }
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) {
    cli_abort("Table {.val {tbl_id}} not found in PXWeb index.")
  }
  paths <- if (nzchar(row$px_path[1])) {
    strsplit(row$px_path[1], "/", fixed = TRUE)[[1]]
  } else {
    character()
  }
  list(px_file = px_file, row = row, paths = paths)
}
