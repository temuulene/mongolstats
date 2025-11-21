# Name normalization and joins

.normalize_str <- function(x) {
  x <- stringi::stri_trans_general(x, "Latin-ASCII")
  x <- stringr::str_to_lower(x)
  x <- stringr::str_replace_all(x, "[^a-z0-9]+", " ")
  x <- stringr::str_squish(x)
  x
}

#' Add normalized name columns to boundaries
#' @param g sf object from `mn_boundaries()`
#' @param name_col Column with English names (default 'shapeName').
#' @return sf with `name_std` column added.
#' @export
mn_boundaries_normalize <- function(g, name_col = "shapeName") {
  if (!name_col %in% names(g)) {
    return(g)
  }
  g$name_std <- .normalize_str(g[[name_col]])
  g
}

#' Join data to boundaries by (normalized) names
#' @param data Data frame with a name column.
#' @param name_col Column in `data` that contains names to join on.
#' @param level Boundary level, passed to `mn_boundaries()` if `boundaries` not provided.
#' @param boundaries Optional pre-fetched boundaries.
#' @return sf with joined data.
#' @export
mn_join_by_name <- function(data, name_col, level = "ADM1", boundaries = NULL) {
  if (is.null(boundaries)) {
    boundaries <- mn_boundaries(level)
  }
  boundaries <- mn_boundaries_normalize(boundaries)
  d <- data
  d$name_std <- .normalize_str(d[[name_col]])
  dplyr::left_join(boundaries, d, by = "name_std")
}

#' Fuzzy join data to boundaries by name
#' @param data Data frame with a name column.
#' @param name_col Column in `data` containing names.
#' @param level Boundary level.
#' @param boundaries Optional pre-fetched boundaries.
#' @param max_distance Maximum string distance for a match (default 2).
#' @param method Distance method passed to `stringdist::stringdist`.
#' @return sf with best fuzzy matches joined.
#' @export
mn_fuzzy_join_by_name <- function(
  data,
  name_col,
  level = "ADM1",
  boundaries = NULL,
  max_distance = 2,
  method = c("osa", "lv", "jw", "dl")
) {
  method <- match.arg(method)
  if (is.null(boundaries)) {
    boundaries <- mn_boundaries(level)
  }
  boundaries <- mn_boundaries_normalize(boundaries)
  d <- data
  d$name_std <- .normalize_str(d[[name_col]])
  # Compute pairwise distances and pick best match per data row
  keys_g <- unique(boundaries$name_std)
  keys_d <- unique(d$name_std)
  if (!length(keys_d) || !length(keys_g)) {
    return(dplyr::left_join(boundaries, d, by = "name_std"))
  }
  mat <- utils::adist(keys_d, keys_g, partial = FALSE, ignore.case = TRUE)
  # Prefer 'method' via stringdist if available for better control
  if (requireNamespace("stringdist", quietly = TRUE)) {
    mat <- stringdist::stringdistmatrix(keys_d, keys_g, method = method)
  }
  best_idx <- apply(mat, 1, which.min)
  best_dst <- mapply(function(i, r) mat[r, i], best_idx, seq_along(best_idx))
  map_df <- tibble::tibble(
    name_std = keys_d,
    match_std = keys_g[best_idx],
    dist = as.numeric(best_dst)
  )
  map_df <- map_df[
    map_df$dist <= max_distance | map_df$name_std == map_df$match_std,
    ,
    drop = FALSE
  ]
  d2 <- dplyr::left_join(d, map_df, by = "name_std")
  d2$name_std <- d2$match_std
  d2$match_std <- NULL
  dplyr::left_join(boundaries, d2, by = "name_std")
}

#' Boundary keys/crosswalk helper
#' @param level Boundary level.
#' @return tibble with key columns from GeoBoundaries and normalized names.
#' @export
mn_boundary_keys <- function(level = "ADM1") {
  g <- mn_boundaries(level)
  g <- mn_boundaries_normalize(g)
  tibble::tibble(
    shapeID = g$shapeID %||% NA_character_,
    shapeName = g$shapeName %||% NA_character_,
    shapeISO = g$shapeISO %||% NA_character_,
    name_std = g$name_std %||% NA_character_
  )
}
