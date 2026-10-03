# Name normalization and joins

.check_name_col <- function(data, name_col, call = rlang::caller_env()) {
  if (!is.character(name_col) || length(name_col) != 1L) {
    cli_abort(
      "{.arg name_col} must be a single character string.",
      call = call
    )
  }
  if (!name_col %in% names(data)) {
    cli_abort(
      c(
        "Column {.val {name_col}} not found in {.arg data}.",
        "i" = "Available columns: {.val {names(data)}}."
      ),
      call = call
    )
  }
}

# Warn about data names that matched no boundary: left-joining onto the
# boundaries drops those rows, which otherwise goes unnoticed until a
# polygon renders grey on a map.
.warn_unmatched_names <- function(unmatched, hint) {
  if (!length(unmatched)) {
    return(invisible())
  }
  cli_warn(
    c(
      "{length(unmatched)} name{?s} in {.arg data} matched no boundary and {?was/were} dropped: {.val {unmatched}}.",
      "i" = hint
    ),
    class = "mongolstats_unmatched_names"
  )
}

.normalize_str <- function(x) {
  x <- stringi::stri_trans_general(x, "Latin-ASCII")
  x <- stringr::str_to_lower(x)
  x <- stringr::str_replace_all(x, "[^a-z0-9]+", " ")
  x <- stringr::str_squish(x)
  x
}

#' Add normalized name columns to boundaries
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `mn_boundaries_normalize()` was deprecated in mongolstats 0.3.0 together
#' with [mn_boundaries()]. To match place names in any spelling, use
#' [mongolmaps::mn_match()].
#'
#' Adds a `name_std` column to an `sf` boundary object by transliterating,
#' lowercasing, and stripping special characters from place names.
#'
#' @param g sf object from `mn_boundaries()`.
#' @param name_col Column with English names (default 'shapeName').
#' @return An `sf` object with an additional `name_std` column.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet() && rlang::is_installed("sf")
#' aimags <- mn_boundaries_normalize(mn_boundaries("ADM1"))
#' # ->
#' if (rlang::is_installed("mongolmaps")) {
#'   mongolmaps::mn_match(c("Khuvsgul", "Hovsgol"), to = "name_en")
#' }
#' @export
mn_boundaries_normalize <- function(g, name_col = "shapeName") {
  lifecycle::deprecate_soft("0.3.0", "mn_boundaries_normalize()", "mongolmaps::mn_match()")
  if (!name_col %in% names(g)) {
    return(g)
  }
  g$name_std <- .normalize_str(g[[name_col]])
  g
}

#' Join data to boundaries by (normalized) names
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `mn_join_by_name()` was deprecated in mongolstats 0.3.0. Use
#' [mongolmaps::mn_join()], which joins by NSO code or by name in any
#' spelling, drops national and regional totals, and takes Ulaanbaatar's
#' figures from region code `"5"` when a table leaves code `"511"` empty.
#'
#' Performs an exact join between a data frame and geoBoundaries polygons
#' using normalized place names.
#'
#' @param data Data frame with a name column.
#' @param name_col Column in `data` that contains names to join on.
#' @param level Boundary level, passed to `mn_boundaries()` if `boundaries` not provided.
#' @param boundaries Optional pre-fetched boundaries.
#' @return An `sf` object with joined data. Data rows whose name matches no
#'   boundary are dropped with a warning (class
#'   `mongolstats_unmatched_names`) naming them.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet() && rlang::is_installed("sf")
#' pop_data <- data.frame(aimag = c("Ulaanbaatar", "Darkhan-Uul"), pop = c(1500000, 100000))
#' sf_joined <- mn_join_by_name(pop_data, "aimag", level = "ADM1")
#' # ->
#' if (rlang::is_installed("mongolmaps")) {
#'   sf_joined <- mongolmaps::mn_join(pop_data, by = "aimag", level = "aimag")
#' }
#' @export
mn_join_by_name <- function(data, name_col, level = "ADM1", boundaries = NULL) {
  lifecycle::deprecate_soft("0.3.0", "mn_join_by_name()", "mongolmaps::mn_join()")
  .check_name_col(data, name_col)
  if (is.null(boundaries)) {
    boundaries <- mn_boundaries(level)
  }
  boundaries <- mn_boundaries_normalize(boundaries)
  d <- data
  d$name_std <- .normalize_str(d[[name_col]])
  unmatched <- !is.na(d$name_std) & !d$name_std %in% boundaries$name_std
  .warn_unmatched_names(
    unique(d[[name_col]][unmatched]),
    "Check the spelling, or use {.fn mn_fuzzy_join_by_name}."
  )
  dplyr::left_join(boundaries, d, by = "name_std")
}

#' Fuzzy join data to boundaries by name
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `mn_fuzzy_join_by_name()` was deprecated in mongolstats 0.3.0. Use
#' [mongolmaps::mn_join()], which knows the common spellings of every aimag
#' and soum and reports each fuzzy match it makes.
#'
#' Performs a fuzzy string-distance join between a data frame and
#' geoBoundaries polygons.
#'
#' @param data Data frame with a name column.
#' @param name_col Column in `data` containing names.
#' @param level Boundary level.
#' @param boundaries Optional pre-fetched boundaries.
#' @param max_distance Maximum string distance for a match (default 2). For
#'   the edit distances (`"osa"`, `"lv"`, `"dl"`) this counts character
#'   edits. Jaro-Winkler (`"jw"`) distances lie between 0 and 1, so use a
#'   small value such as `0.2`; values of 1 or more would accept every pair
#'   and are rejected.
#' @param method Distance method passed to `stringdist::stringdist`. Ignored
#'   (base Levenshtein distance is used) when the stringdist package is not
#'   installed.
#' @return sf with best fuzzy matches joined. Data rows with no boundary
#'   within `max_distance` are dropped with a warning (class
#'   `mongolstats_unmatched_names`) naming them; rows with a missing name
#'   are dropped silently.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet() && rlang::is_installed("sf")
#' pop_data <- data.frame(aimag = c("Ulanbatar", "Darhan"), pop = c(1500000, 100000))
#' sf_joined <- mn_fuzzy_join_by_name(pop_data, "aimag", level = "ADM1")
#' # ->
#' if (rlang::is_installed("mongolmaps")) {
#'   sf_joined <- mongolmaps::mn_join(pop_data, by = "aimag", level = "aimag")
#' }
#' @export
mn_fuzzy_join_by_name <- function(
  data,
  name_col,
  level = "ADM1",
  boundaries = NULL,
  max_distance = 2,
  method = c("osa", "lv", "jw", "dl")
) {
  lifecycle::deprecate_soft("0.3.0", "mn_fuzzy_join_by_name()", "mongolmaps::mn_join()")
  method <- match.arg(method)
  .check_name_col(data, name_col)
  bad_distance <- !is.numeric(max_distance) || length(max_distance) != 1L ||
    is.na(max_distance) || max_distance < 0
  if (bad_distance) {
    cli_abort("{.arg max_distance} must be a single non-negative number.")
  }
  if (method == "jw" && max_distance >= 1) {
    cli_abort(c(
      "{.arg max_distance} must be below 1 for {.code method = \"jw\"}.",
      "i" = "Jaro-Winkler distances lie between 0 and 1, so {.val {max_distance}} would match every name.",
      "i" = "Try {.code max_distance = 0.2}."
    ))
  }
  if (is.null(boundaries)) {
    boundaries <- mn_boundaries(level)
  }
  boundaries <- mn_boundaries_normalize(boundaries)
  d <- data
  d$name_std <- .normalize_str(d[[name_col]])
  # Compute pairwise distances and pick best match per data row. Missing
  # names cannot match anything and would give an all-NA distance row.
  keys_g <- unique(boundaries$name_std[!is.na(boundaries$name_std)])
  keys_d <- unique(d$name_std[!is.na(d$name_std)])
  if (!length(keys_d) || !length(keys_g)) {
    return(dplyr::left_join(boundaries, d, by = "name_std"))
  }
  # Prefer 'method' via stringdist when available; otherwise fall back to
  # base adist (Levenshtein), in which case `method` is ignored.
  mat <- if (requireNamespace("stringdist", quietly = TRUE)) {
    stringdist::stringdistmatrix(keys_d, keys_g, method = method)
  } else {
    utils::adist(keys_d, keys_g, partial = FALSE, ignore.case = TRUE)
  }
  best_idx <- max.col(-mat, ties.method = "first")
  map_df <- tibble::tibble(
    name_std = keys_d,
    match_std = keys_g[best_idx],
    dist = as.numeric(mat[cbind(seq_along(keys_d), best_idx)])
  )
  map_df <- map_df[
    map_df$dist <= max_distance | map_df$name_std == map_df$match_std, ,
    drop = FALSE
  ]
  unmatched <- !is.na(d$name_std) & !d$name_std %in% map_df$name_std
  .warn_unmatched_names(
    unique(d[[name_col]][unmatched]),
    "Check the spelling, or increase {.arg max_distance}."
  )
  d2 <- dplyr::left_join(d, map_df, by = "name_std")
  d2$name_std <- d2$match_std
  d2$match_std <- NULL
  dplyr::left_join(boundaries, d2, by = "name_std")
}

#' Boundary keys/crosswalk helper
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `mn_boundary_keys()` was deprecated in mongolstats 0.3.0. Use
#' [mongolmaps::mn_codes()], which lists every administrative unit with its
#' NSO code, ISO 3166-2 code, P-code and names.
#'
#' Returns a lightweight tibble of key columns from the geoBoundaries data,
#' including normalized names, without the full geometry.
#'
#' @param level Boundary level.
#' @return A tibble with key columns from GeoBoundaries and normalized names.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet() && rlang::is_installed("sf")
#' keys <- mn_boundary_keys("ADM1")
#' # ->
#' if (rlang::is_installed("mongolmaps")) {
#'   keys <- mongolmaps::mn_codes("aimag")
#' }
#' @export
mn_boundary_keys <- function(level = "ADM1") {
  lifecycle::deprecate_soft("0.3.0", "mn_boundary_keys()", "mongolmaps::mn_codes()")
  g <- mn_boundaries(level)
  g <- mn_boundaries_normalize(g)
  tibble::tibble(
    shapeID = g$shapeID %||% NA_character_,
    shapeName = g$shapeName %||% NA_character_,
    shapeISO = g$shapeISO %||% NA_character_,
    name_std = g$name_std %||% NA_character_
  )
}
