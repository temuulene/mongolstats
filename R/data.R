# Data retrieval via PXWeb

# Map codes to labels using table metadata in en/mn
.px_add_labels <- function(df, tbl_id, which = c("none", "en", "mn", "both")) {
  which <- match.arg(which)
  if (identical(which, "none")) {
    return(df)
  }
  idx <- .px_index()
  px_file <- if (grepl("\\.px$", tbl_id, ignore.case = TRUE)) {
    tbl_id
  } else {
    paste0(tbl_id, ".px")
  }
  row <- idx[idx$px_file == px_file, , drop = FALSE]
  if (!nrow(row)) {
    return(df)
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
  meta_mn <- if (which %in% c("mn", "both")) {
    tryCatch(.px_meta_cached(paths, px_file, lang = "mn"), error = function(e) {
      NULL
    })
  } else {
    NULL
  }
  add_lab <- function(d, vmeta, suffix) {
    if (is.null(vmeta)) {
      return(d)
    }
    for (v in vmeta$variables) {
      col <- .px_first_nonempty(v$text, v$code)
      if (is.null(col) || !nzchar(col) || !col %in% names(d)) {
        next
      }
      map <- tibble::tibble(
        code = .px_chr(v$values),
        lbl = .px_chr(v$valueTexts)
      )
      names(map) <- c(col, paste0(col, suffix))
      d <- dplyr::left_join(d, map, by = col)
    }
    d
  }
  if (which %in% c("en", "both")) {
    df <- add_lab(df, meta_en, "_en")
  }
  if (which %in% c("mn", "both")) {
    df <- add_lab(df, meta_mn, "_mn")
  }
  df
}

#' Fetch statistical data for a table (PXWeb)
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_0300_001V2").
#' @param selections Named list mapping variable labels (e.g., Year, Sex) to desired codes or labels.
#' @param labels Label handling: "none" (codes only), "en", "mn", or "both".
#' @param value_name Name of the numeric value column in the result (default: "value").
#' @param include_raw If TRUE, attach the raw PX payload as attribute `px_raw`.
#' @return A tibble with one column per dimension and a numeric value column.
#' @examples
#' \dontrun{
#' # Fetch population data for 2024
#' pop <- nso_data(
#'   tbl_id = "DT_NSO_0300_001V2",
#'   selections = list(Sex = "Total", Age = "Total", Year = "2024"),
#'   labels = "en"
#' )
#'
#' # Fetch multiple years
#' pop_trend <- nso_data(
#'   tbl_id = "DT_NSO_0300_001V2",
#'   selections = list(
#'     Sex = "Total",
#'     Age = "Total",
#'     Year = c("2020", "2021", "2022", "2023", "2024")
#'   )
#' )
#' }
#' @export
nso_data <- function(
  tbl_id,
  selections,
  labels = c("none", "en", "mn", "both"),
  value_name = getOption("mongolstats.value_name", "value"),
  include_raw = getOption("mongolstats.attach_raw", FALSE)
) {
  if (missing(labels)) {
    labels <- getOption("mongolstats.default_labels", "none")
  }
  labels <- match.arg(labels)
  stopifnot(is.character(tbl_id), length(tbl_id) == 1L)
  stopifnot(is.list(selections))
  out <- nso_px_data(
    tbl_id,
    selections = selections,
    lang = .px_lang(),
    include_raw = include_raw,
    value_name = value_name
  )
  .px_add_labels(out, tbl_id, which = labels)
}

#' Fetch multiple tables and bind (PXWeb)
#' @param requests A list of records, each with `tbl_id` and `selections` (named list)
#' @param labels Label handling as in `nso_data()`
#' @param parallel If TRUE, use future.apply to fetch tables in parallel.
#' @param value_name Name of the numeric value column in the result (default: "value").
#' @export
nso_package <- function(
  requests,
  labels = c("none", "en", "mn", "both"),
  parallel = getOption("mongolstats.parallel", FALSE),
  value_name = getOption("mongolstats.value_name", "value")
) {
  if (missing(labels)) {
    labels <- getOption("mongolstats.default_labels", "none")
  }
  labels <- match.arg(labels)
  if (is.data.frame(requests)) {
    # expect columns: tbl_id (character), selections (list-column)
    if (!("tbl_id" %in% names(requests) && "selections" %in% names(requests))) {
      stop(
        "For PXWeb, provide a data frame with columns tbl_id and selections (list-column)"
      )
    }
    reqs <- purrr::pmap(requests[, c("tbl_id", "selections")], list)
  } else if (is.list(requests)) {
    reqs <- requests
  } else {
    stop(
      "`requests` must be a list of records or a data frame with tbl_id + selections"
    )
  }
  worker <- function(r) {
    tbl <- r$tbl_id
    sel <- r$selections
    df <- tryCatch(
      nso_px_data(
        tbl,
        selections = sel,
        lang = .px_lang(),
        include_raw = FALSE,
        value_name = value_name
      ),
      error = function(e) tibble::tibble()
    )
    if (nrow(df)) {
      df$tbl_id <- tbl
    }
    .px_add_labels(df, tbl, which = labels)
  }
  if (isTRUE(parallel) && requireNamespace("future.apply", quietly = TRUE)) {
    parts <- future.apply::future_lapply(reqs, worker, future.seed = TRUE)
    out <- dplyr::bind_rows(parts)
  } else {
    if (
      length(reqs) > 1 &&
        .nso_progress() &&
        interactive() &&
        requireNamespace("cli", quietly = TRUE)
    ) {
      cli::cli_progress_bar(name = "Fetching tables", total = length(reqs))
      parts <- vector("list", length(reqs))
      for (i in seq_along(reqs)) {
        parts[[i]] <- worker(reqs[[i]])
        cli::cli_progress_update()
      }
      cli::cli_progress_done()
      out <- dplyr::bind_rows(parts)
    } else {
      out <- purrr::map_dfr(reqs, worker)
    }
  }
  out
}
