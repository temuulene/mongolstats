#' Get variable metadata for a PXWeb table (both languages when available)
#' Returns tibble with columns: field, itm_id, scr_eng, scr_mn, px_path, px_file
#' @keywords internal
#' @noRd
nso_px_variables <- function(tbl_id) {
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) {
    tbl_id
  } else {
    paste0(tbl_id, ".px")
  }
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) {
    stop("Table not found in PXWeb index: ", tbl_id)
  }
  paths <- if (nzchar(row$px_path[1])) {
    strsplit(row$px_path[1], "/", fixed = TRUE)[[1]]
  } else {
    character()
  }
  meta_en <- .px_meta_cached(paths, px_file, lang = "en")
  meta_mn <- tryCatch(
    .px_meta_cached(paths, px_file, lang = "mn"),
    error = function(e) NULL
  )
  ve <- meta_en$variables
  vm <- if (!is.null(meta_mn)) meta_mn$variables else NULL
  out <- purrr::imap_dfr(ve, function(v, i) {
    name <- .px_first_nonempty(v$text, v$code, paste0("V", i))
    tibble::tibble(
      field = name,
      itm_id = .px_chr(v$values %||% character()),
      scr_eng = .px_chr(v$valueTexts %||% character())
    )
  })
  if (!is.null(vm)) {
    out_mn <- purrr::imap_dfr(vm, function(v, i) {
      name <- .px_first_nonempty(v$text, v$code, paste0("V", i))
      tibble::tibble(
        field = name,
        itm_id = .px_chr(v$values %||% character()),
        scr_mn = .px_chr(v$valueTexts %||% character())
      )
    })
    out <- dplyr::left_join(out, out_mn, by = c("field", "itm_id"))
  } else {
    out$scr_mn <- NA_character_
  }
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
#' @export
nso_dims <- function(tbl_id) {
  stopifnot(is.character(tbl_id), length(tbl_id) == 1L)
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) {
    tbl_id
  } else {
    paste0(tbl_id, ".px")
  }
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) {
    stop("Table not found in PXWeb index: ", tbl_id)
  }
  paths <- if (nzchar(row$px_path[1])) {
    strsplit(row$px_path[1], "/", fixed = TRUE)[[1]]
  } else {
    character()
  }
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
#' @param labels One of "code", "en", "mn", or "both" to control returned label columns.
#' @return A tibble with at least `code`; may include `label_en` and/or `label_mn`.
#' @export
nso_dim_values <- function(
  tbl_id,
  dim,
  labels = c("code", "en", "mn", "both")
) {
  stopifnot(is.character(tbl_id), length(tbl_id) == 1L)
  stopifnot(is.character(dim), length(dim) == 1L)
  labels <- match.arg(labels)
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) {
    tbl_id
  } else {
    paste0(tbl_id, ".px")
  }
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) {
    stop("Table not found in PXWeb index: ", tbl_id)
  }
  paths <- if (nzchar(row$px_path[1])) {
    strsplit(row$px_path[1], "/", fixed = TRUE)[[1]]
  } else {
    character()
  }
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
    dims <- vapply(
      vars_en,
      function(v) .px_first_nonempty(v$text, v$code, ""),
      character(1)
    )
    stop(sprintf(
      "Dimension '%s' not found. Available: %s",
      dim,
      paste(dims, collapse = ", ")
    ))
  }
  if (length(idxs) > 1) {
    dims <- vapply(
      vars_en[idxs],
      function(v) .px_first_nonempty(v$text, v$code, ""),
      character(1)
    )
    stop(sprintf(
      "Dimension '%s' is ambiguous. Candidates: %s",
      dim,
      paste(dims, collapse = ", ")
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
#' @export
nso_table_meta <- function(tbl_id) {
  stopifnot(is.character(tbl_id), length(tbl_id) == 1L)
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) tbl_id else paste0(tbl_id, ".px")
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) {
    stop("Table not found in PXWeb index: ", tbl_id)
  }
  paths <- if (nzchar(row$px_path[1])) strsplit(row$px_path[1], "/", fixed = TRUE)[[1]] else character()
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
