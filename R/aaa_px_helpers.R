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

# Map user selections onto PXWeb value codes for every table dimension.
#
# Single source of truth for selection handling, used by nso_px_data() and
# .px_build_body(). Behaviour:
#   - Dimension names match case-insensitively against the display name
#     (variable text, falling back to code) or the variable code.
#   - Values that are valid codes pass through unchanged; remaining values
#     are mapped from labels to codes element-wise, so codes and labels can
#     be mixed in one vector. Codes take priority over labels.
#   - Dimensions not selected get all their codes (PXWeb "select all").
#
# Errors (class "mongolstats_selection_error"):
#   - a selection name that matches no dimension in the table
#   - a selection name that matches more than one dimension
#   - a value that is neither a valid code nor a valid label
#
# @param vars `variables` element of PXWeb table metadata.
# @param selections Named list of user selections (validated upstream by
#   check_selections()).
# @return Named list keyed by variable code; each element is a character
#   vector of resolved value codes.
.px_map_selections <- function(vars, selections, call = rlang::caller_env()) {
  dim_display <- vapply(
    vars,
    function(v) .px_first_nonempty(v$text, v$code, "") %||% "",
    character(1)
  )
  dim_codes <- vapply(
    vars,
    function(v) as.character(v$code %||% ""),
    character(1)
  )
  sel_names <- tolower(names(selections))

  # Match each selection name to exactly one dimension
  sel_to_dim <- integer(length(sel_names))
  for (i in seq_along(sel_names)) {
    hits <- which(
      tolower(dim_display) == sel_names[i] | tolower(dim_codes) == sel_names[i]
    )
    if (length(hits) > 1L) {
      cands <- unique(dim_display[hits]) # nolint object_usage_linter. Used in cli_abort() below.
      cli_abort(
        c(
          "Selection {.val {names(selections)[i]}} matches more than one dimension.",
          "i" = "Candidates: {.val {cands}}."
        ),
        class = "mongolstats_selection_error",
        call = call
      )
    }
    sel_to_dim[i] <- if (length(hits)) hits else NA_integer_
  }
  if (anyNA(sel_to_dim)) {
    unknown <- names(selections)[is.na(sel_to_dim)] # nolint object_usage_linter. Used in cli_abort() below.
    cli_abort(
      c(
        "Unknown dimension{?s} in {.arg selections}: {.val {unknown}}.",
        "i" = "Available dimensions: {.val {dim_display}}.",
        "i" = "See {.fn nso_dims} for dimension names and codes."
      ),
      class = "mongolstats_selection_error",
      call = call
    )
  }
  if (anyDuplicated(sel_to_dim)) {
    clash <- names(selections)[sel_to_dim %in% sel_to_dim[duplicated(sel_to_dim)]] # nolint object_usage_linter. Used in cli_abort() below.
    cli_abort(
      "Selections {.val {clash}} target the same dimension.",
      class = "mongolstats_selection_error",
      call = call
    )
  }

  out <- stats::setNames(vector("list", length(vars)), dim_codes)
  for (j in seq_along(vars)) {
    v <- vars[[j]]
    vv <- .px_chr(v$values)
    vt <- .px_chr(v$valueTexts)
    i <- match(j, sel_to_dim)
    if (is.na(i)) {
      # Not selected: all explicit codes for this dimension
      out[[j]] <- as.character(vv)
      next
    }
    vals <- as.character(selections[[i]])
    if (!length(vals) || anyNA(vals)) {
      cli_abort(
        "Selection for {.field {dim_display[j]}} must be a non-empty vector without {.val NA}.",
        class = "mongolstats_selection_error",
        call = call
      )
    }
    # Element-wise: keep valid codes as-is, map labels to codes.
    # Only trust labels when they align 1:1 with codes.
    mapped <- vals
    is_code <- if (length(vv)) vals %in% vv else rep(TRUE, length(vals))
    if (length(vt) && length(vt) == length(vv)) {
      needs_map <- !is_code
      mapped[needs_map] <- vv[match(vals[needs_map], vt)]
      dup_labs <- intersect(vals[needs_map], vt[duplicated(vt)])
      if (length(dup_labs)) {
        cli_warn(c(
          "Some labels in {.field {dim_display[j]}} are not unique: {.val {dup_labs}}.",
          "i" = "The first matching code was used. Prefer codes for this dimension."
        ))
      }
    }
    if (length(vv) && !all(mapped %in% vv)) {
      bad <- unique(vals[is.na(mapped) | !mapped %in% vv]) # nolint object_usage_linter. Used in cli_abort() below.
      cli_abort(
        c(
          "Invalid selection for {.field {dim_display[j]}}:",
          "x" = "Unknown value{?s}: {.val {bad}}.",
          "i" = "Available codes: {.val {utils::head(vv, 5)}}.",
          if (length(vt)) c("i" = "Available labels: {.val {utils::head(vt, 5)}}.")
        ),
        class = "mongolstats_selection_error",
        call = call
      )
    }
    out[[j]] <- as.character(mapped)
  }
  out
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
  if (nrow(row) > 1) {
    # The catalogue cross-lists some tables in several folders; that is
    # harmless. Only warn when the id names genuinely different tables.
    if (length(unique(row$tbl_eng_nm)) > 1) {
      cli_warn(
        c(
          "Table id {.val {tbl_id}} matches {nrow(row)} different tables in
           the PXWeb catalogue.",
          "i" = "Using the first match, in folder {.val {row$px_path[1]}}:
                 {row$tbl_eng_nm[1]}.",
          "i" = "Ignored match{?es} in folder{?s}: {.val {row$px_path[-1]}}."
        ),
        class = "mongolstats_ambiguous_table"
      )
    }
    row <- row[1, , drop = FALSE]
  }
  paths <- if (nzchar(row$px_path[1])) {
    strsplit(row$px_path[1], "/", fixed = TRUE)[[1]]
  } else {
    character()
  }
  list(px_file = px_file, row = row, paths = paths)
}
