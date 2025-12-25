# Recursively list available PXWeb tables under NSO
# Returns tibble with columns: px_path, px_file, tbl_id, tbl_eng_nm, tbl_nm, strt_prd, end_prd
nso_px_tables <- function() {
  # BFS traversal to avoid deep recursion limits
  queue <- list(character())
  out <- list()
  while (length(queue)) {
    paths <- queue[[1]]
    queue <- queue[-1]
    kids <- tryCatch(
      .px_list_cached(paths, lang = .px_lang()),
      error = function(e) NULL
    )
    if (is.null(kids) || !length(kids)) {
      next
    }
    # folders have type 'l', tables have type 't'
    is_table <- kids$type == "t"
    tables <- kids[is_table, , drop = FALSE]
    if (nrow(tables)) {
      for (i in seq_len(nrow(tables))) {
        px_file <- tables$id[i]
        meta_en <- tryCatch(
          .px_meta_cached(paths, px_file, lang = "en"),
          error = function(e) NULL
        )
        meta_mn <- tryCatch(
          .px_meta_cached(paths, px_file, lang = "mn"),
          error = function(e) NULL
        )
        title_en <- if (!is.null(meta_en)) meta_en$title else NA_character_
        title_mn <- if (!is.null(meta_mn)) meta_mn$title else NA_character_
        # derive period range from a time-like variable when possible
        rng <- tryCatch(
          {
            vars <- meta_en$variables
            if (length(vars)) {
              time_idx <- which(vapply(
                vars,
                function(v) {
                  isTRUE(v$time) || grepl("year|time", tolower(v$text %||% ""))
                },
                logical(1)
              ))
              if (!length(time_idx)) {
                time_idx <- which(vapply(
                  vars,
                  function(v) {
                    length(v$values) &&
                      all(grepl("^20[0-9]{2}$", .px_chr(v$valueTexts) %||% ""))
                  },
                  logical(1)
                ))
              }
              if (length(time_idx)) {
                vt <- .px_chr(vars[[time_idx[1]]]$valueTexts %||% character())
                if (length(vt)) {
                  c(vt[1], vt[length(vt)])
                } else {
                  c(NA_character_, NA_character_)
                }
              } else {
                c(NA_character_, NA_character_)
              }
            } else {
              c(NA_character_, NA_character_)
            }
          },
          error = function(e) c(NA_character_, NA_character_)
        )
        out[[length(out) + 1]] <- tibble::tibble(
          px_path = paste(paths, collapse = "/"),
          px_file = px_file,
          tbl_id = sub("\\.px$", "", px_file),
          tbl_eng_nm = title_en %||% NA_character_,
          tbl_nm = title_mn %||% NA_character_,
          strt_prd = rng[1],
          end_prd = rng[2]
        )
      }
    }
    # enqueue child folders
    folders <- kids[!is_table, , drop = FALSE]
    if (nrow(folders)) {
      for (i in seq_len(nrow(folders))) {
        queue[[length(queue) + 1]] <- c(paths, folders$id[i])
      }
    }
  }
  dplyr::bind_rows(out)
}

# Build/refresh PXWeb table index and memoize in package env
.mongolstats_px_env <- new.env(parent = emptyenv())
.px_index_embedded <- function() {
  # Try to load prebuilt index shipped with the package
  path <- system.file("extdata", "px_index.json", package = "mongolstats")
  if (!nzchar(path) || !file.exists(path)) {
    # also allow dev path
    path <- file.path("inst", "extdata", "px_index.json")
  }
  if (file.exists(path)) {
    df <- tryCatch(
      {
        jsonlite::fromJSON(path, simplifyVector = TRUE)
      },
      error = function(e) NULL
    )
    if (is.data.frame(df)) {
      return(tibble::as_tibble(df))
    }
  }
  tibble::tibble()
}
.px_index <- function(refresh = FALSE) {
  if (isTRUE(refresh) || is.null(.mongolstats_px_env$idx)) {
    # prefer embedded index to avoid cold-start crawl
    idx <- .px_index_embedded()
    if (!nrow(idx)) {
      idx <- tryCatch(nso_px_tables(), error = function(e) tibble::tibble())
    }
    .mongolstats_px_env$idx <- idx
  }
  .mongolstats_px_env$idx
}

#' Rebuild PXWeb index and optionally write to a file
#'
#' Crawls the PXWeb API to rebuild the table index. If `path` is provided,
#' the index is written to that file; otherwise only the in-memory index is
#' refreshed.
#'
#' @param path Output path for JSON. If `NULL` (default), no file is written.
#'   For package development, use `"inst/extdata/px_index.json"`.
#' @param write Whether to write JSON to `path`. Defaults to `TRUE` if `path`

#'   is provided, `FALSE` otherwise.
#' @return A tibble containing the rebuilt table index.
#' @export
nso_rebuild_px_index <- function(
  path = NULL,
  write = !is.null(path)
) {
  idx <- nso_px_tables()
  if (isTRUE(write) && !is.null(path)) {
    dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
    jsonlite::write_json(
      idx,
      path,
      dataframe = "rows",
      auto_unbox = TRUE,
      pretty = FALSE
    )
  }
  # refresh in-memory cache
  .mongolstats_px_env$idx <- tibble::as_tibble(idx)
  .mongolstats_px_env$idx
}
