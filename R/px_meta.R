#' Get variable metadata for a PXWeb table (both languages when available)
#' Returns tibble with columns: field, itm_id, scr_eng, scr_mn, px_path, px_file
#' @keywords internal
#' @noRd
nso_px_variables <- function(tbl_id) {
  resolved <- .px_resolve_table(tbl_id)
  px_file <- resolved$px_file
  row <- resolved$row
  paths <- resolved$paths
  meta_en <- .px_meta_cached(paths, px_file, lang = "en")
  meta_mn <- tryCatch(
    .px_meta_cached(paths, px_file, lang = "mn"),
    error = function(e) NULL
  )
  # One row per dimension value. `dim_code` is the join key across
  # languages: display names differ ("Sex" vs its Mongolian name) while the
  # dimension code is shared.
  value_rows <- function(vars, label_col) {
    out <- purrr::imap_dfr(vars, function(v, i) {
      tibble::tibble(
        dim_code = as.character(v$code %||% paste0("V", i)),
        field = .px_first_nonempty(v$text, v$code, paste0("V", i)),
        itm_id = .px_chr(v$values %||% character()),
        label = .px_chr(v$valueTexts %||% character())
      )
    })
    names(out)[names(out) == "label"] <- label_col
    out
  }
  out <- value_rows(meta_en$variables, "scr_eng")
  if (nrow(out) && length(meta_mn$variables)) {
    out_mn <- value_rows(meta_mn$variables, "scr_mn")
    out_mn$field <- NULL
    out <- dplyr::left_join(out, out_mn, by = c("dim_code", "itm_id"))
  } else {
    out$scr_mn <- NA_character_
  }
  out$dim_code <- NULL
  out$px_path <- row$px_path[1]
  out$px_file <- row$px_file[1]
  out
}

#' List dimensions for a PXWeb table
#'
#' Returns one row per dimension with basic metadata.
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_0300_001V2").
#' @return A tibble with columns: `dim` (display name), `code` (dimension code),
#'   `is_time` (logical), and `n_values` (number of values for the dimension).
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' dims <- nso_dims("DT_NSO_0300_001V2")
#' dims
#' @export
nso_dims <- function(tbl_id) {
  check_tbl_id(tbl_id)
  resolved <- .px_resolve_table(tbl_id)
  px_file <- resolved$px_file
  paths <- resolved$paths
  meta_en <- tryCatch(
    .px_meta_cached(paths, px_file, lang = "en"),
    error = function(e) NULL
  )
  if (is.null(meta_en) || is.null(meta_en$variables)) {
    return(tibble::tibble())
  }
  vars <- meta_en$variables
  tibble::tibble(
    dim = vapply(
      vars,
      function(v) .px_first_nonempty(v$text, v$code, ""),
      character(1)
    ),
    code = vapply(vars, function(v) as.character(v$code), character(1)),
    is_time = vapply(vars, function(v) isTRUE(v$time), logical(1)),
    n_values = vapply(
      vars,
      function(v) length(.px_chr(v$values %||% character())),
      integer(1)
    )
  )
}

#' List values for a table dimension
#'
#' Returns codes and optional labels for a specific dimension.
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_0300_001V2").
#' @param dim Dimension name or code (case-insensitive; exact match preferred).
#' @param labels One of "code", "en", "mn", or "both" to control returned
#'   label columns. "none" is accepted as an alias for "code".
#' @return A tibble with at least `code`; may include `label_en` and/or `label_mn`.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' values <- nso_dim_values("DT_NSO_0300_001V2", "Year")
#' head(values)
#' @export
nso_dim_values <- function(
  tbl_id,
  dim,
  labels = c("code", "en", "mn", "both")
) {
  check_tbl_id(tbl_id)
  if (!is.character(dim) || length(dim) != 1L) {
    cli_abort("{.arg dim} must be a single character string.")
  }
  # Accept the nso_data() vocabulary too: "none" is an alias for "code"
  if (identical(labels, "none")) labels <- "code"
  labels <- match.arg(labels)
  resolved <- .px_resolve_table(tbl_id)
  px_file <- resolved$px_file
  paths <- resolved$paths
  meta_en <- tryCatch(
    .px_meta_cached(paths, px_file, lang = "en"),
    error = function(e) NULL
  )
  if (is.null(meta_en) || is.null(meta_en$variables)) {
    return(tibble::tibble())
  }
  vars_en <- meta_en$variables
  # Locate the requested dimension (prefer exact code/text match, then unique partial match)
  needle <- tolower(dim)
  eq_code <- which(vapply(
    vars_en,
    function(v) tolower(as.character(v$code %||% "")) == needle,
    logical(1)
  ))
  eq_text <- which(vapply(
    vars_en,
    function(v) tolower(.px_first_nonempty(v$text, v$code, "")) == needle,
    logical(1)
  ))
  idxs <- unique(c(eq_code, eq_text))
  if (!length(idxs)) {
    pm <- which(vapply(
      vars_en,
      function(v) {
        grepl(
          needle,
          tolower(.px_first_nonempty(v$text, v$code, "")),
          fixed = TRUE
        )
      },
      logical(1)
    ))
    idxs <- unique(pm)
  }
  if (!length(idxs)) {
    # helpful error listing available dimensions
    dims <- vapply( # nolint object_usage_linter. Used in cli_abort() below.
      vars_en,
      function(v) .px_first_nonempty(v$text, v$code, ""),
      character(1)
    )
    cli_abort(c(
      "Dimension {.val {dim}} not found in table {.val {tbl_id}}.",
      "i" = "Available dimensions: {.val {dims}}."
    ))
  }
  if (length(idxs) > 1) {
    dims <- vapply( # nolint object_usage_linter. Used in cli_abort() below.
      vars_en[idxs],
      function(v) .px_first_nonempty(v$text, v$code, ""),
      character(1)
    )
    cli_abort(c(
      "Dimension {.val {dim}} is ambiguous in table {.val {tbl_id}}.",
      "i" = "Candidates: {.val {dims}}."
    ))
  }
  v_en <- vars_en[[idxs[1]]]
  codes <- .px_chr(v_en$values %||% character())
  labs_en <- .px_chr(v_en$valueTexts %||% character())
  out <- tibble::tibble(code = codes)
  if (labels %in% c("en", "both")) {
    out$label_en <- if (length(labs_en) == length(codes)) {
      labs_en
    } else {
      NA_character_
    }
  }
  if (labels %in% c("mn", "both")) {
    meta_mn <- tryCatch(
      .px_meta_cached(paths, px_file, lang = "mn"),
      error = function(e) NULL
    )
    if (!is.null(meta_mn) && length(meta_mn$variables)) {
      vars_mn <- meta_mn$variables
      # match by dimension code to be robust across languages
      vidx_mn <- purrr::detect_index(vars_mn, function(v) {
        identical(as.character(v$code), as.character(v_en$code))
      })
      if (vidx_mn) {
        v_mn <- vars_mn[[vidx_mn]]
        codes_mn <- .px_chr(v_mn$values %||% character())
        labs_mn <- .px_chr(v_mn$valueTexts %||% character())
        map_mn <- tibble::tibble(code = codes_mn, label_mn = labs_mn)
        out <- dplyr::left_join(out, map_mn, by = "code")
      } else {
        out$label_mn <- NA_character_
      }
    } else {
      out$label_mn <- NA_character_
    }
  }
  out
}

#' Table metadata as per-dimension codebooks
#'
#' Returns a tibble with one row per dimension and a `codes` list-column,
#' where each element is a tibble of codes and labels (`code`, `label_en`,
#' `label_mn`). Useful for manual query assembly and for inspecting available
#' categories per dimension.
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_0300_001V2").
#' @return A tibble with columns: `dim` (display name), `code` (dimension code),
#'   `is_time` (logical), `n_values` (integer), and `codes` (list of tibbles).
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' meta <- nso_table_meta("DT_NSO_0300_001V2")
#' meta
#' @export
nso_table_meta <- function(tbl_id) {
  check_tbl_id(tbl_id)
  resolved <- .px_resolve_table(tbl_id)
  px_file <- resolved$px_file
  paths <- resolved$paths
  meta_en <- tryCatch(.px_meta_cached(paths, px_file, lang = "en"), error = function(e) NULL)
  meta_mn <- tryCatch(.px_meta_cached(paths, px_file, lang = "mn"), error = function(e) NULL)
  if (is.null(meta_en) || is.null(meta_en$variables)) {
    return(tibble::tibble())
  }
  vars_en <- meta_en$variables
  vars_mn <- if (!is.null(meta_mn)) meta_mn$variables else NULL
  # Build per-dimension codebooks
  out <- purrr::imap_dfr(vars_en, function(v_en, i) {
    dim_name <- .px_first_nonempty(v_en$text, v_en$code, paste0("V", i))
    codes <- .px_chr(v_en$values %||% character())
    labs_en <- .px_chr(v_en$valueTexts %||% character())
    df_codes <- tibble::tibble(code = codes)
    if (length(labs_en) == length(codes)) {
      df_codes$label_en <- labs_en
    } else {
      df_codes$label_en <- NA_character_
    }
    # Attach Mongolian labels by matching on dimension code when available
    if (!is.null(vars_mn)) {
      j <- purrr::detect_index(vars_mn, function(v) identical(as.character(v$code), as.character(v_en$code)))
      if (j) {
        v_mn <- vars_mn[[j]]
        codes_mn <- .px_chr(v_mn$values %||% character())
        labs_mn <- .px_chr(v_mn$valueTexts %||% character())
        map_mn <- tibble::tibble(code = codes_mn, label_mn = labs_mn)
        df_codes <- dplyr::left_join(df_codes, map_mn, by = "code")
      } else {
        df_codes$label_mn <- NA_character_
      }
    }
    tibble::tibble(
      dim = dim_name,
      code = as.character(v_en$code),
      is_time = isTRUE(v_en$time),
      n_values = length(codes),
      codes = list(df_codes)
    )
  })
  out
}
