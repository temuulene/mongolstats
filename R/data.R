# Data retrieval endpoints

#' Fetch statistical data for a table
#'
#' Wrapper around POST api/Data that returns tidy results as a tibble.
#'
#' @param tbl_id Table identifier (e.g., "DT_NSO_2600_004V1").
#' @param period Character vector of periods (e.g., "201701", "2016"). Optional.
#' @param code,code1,code2 Optional character vectors of classification codes.
#' @param labels How to handle code labels: "none" (default, no labels), "en" (English labels only), "mn" (Mongolian labels only), or "both" (both English and Mongolian labels).
#' @return tibble with columns including `tbl_id`, `period`, `code*`, `scr_*` labels,
#'   and numeric `value`.
#' @export
nso_data <- function(tbl_id, period = NULL, code = NULL, code1 = NULL, code2 = NULL,
                     labels = c("none", "en", "mn", "both")) {
  if (missing(labels)) {
    labels <- getOption("mongolstats.default_labels", "none")
  } else {
    labels <- match.arg(labels)
  }
  stopifnot(is.character(tbl_id), length(tbl_id) == 1L)

  body <- .compact(list(
    tbl_id = unname(tbl_id),
    Period = if (!is.null(period)) as.character(period) else NULL,
    CODE = if (!is.null(code)) as.character(code) else NULL,
    CODE1 = if (!is.null(code1)) as.character(code1) else NULL,
    CODE2 = if (!is.null(code2)) as.character(code2) else NULL
  ))

  res <- .nso_post("api/Data", body = body, query = list(type = "json"))

  dat <- res$DataList
  out <- .as_tibble_df(dat)
  if (nrow(out) == 0) return(out)

  # Standardize column names without requiring tidyselect pronouns
  if ("TBL_ID" %in% names(out)) out <- dplyr::rename(out, tbl_id = TBL_ID)
  if ("Indicator_RN" %in% names(out)) out <- dplyr::rename(out, tbl_id = Indicator_RN)
  if ("Period" %in% names(out)) out <- dplyr::rename(out, period = Period)
  if ("CODE" %in% names(out)) out <- dplyr::rename(out, code = CODE)
  if ("CODE1" %in% names(out)) out <- dplyr::rename(out, code1 = CODE1)
  if ("CODE2" %in% names(out)) out <- dplyr::rename(out, code2 = CODE2)
  if ("SCR_MN" %in% names(out)) out <- dplyr::rename(out, scr_mn = SCR_MN)
  if ("SCR_ENG" %in% names(out)) out <- dplyr::rename(out, scr_eng = SCR_ENG)
  if ("SCR_MN1" %in% names(out)) out <- dplyr::rename(out, scr_mn1 = SCR_MN1)
  if ("SCR_ENG1" %in% names(out)) out <- dplyr::rename(out, scr_eng1 = SCR_ENG1)
  if ("SCR_MN2" %in% names(out)) out <- dplyr::rename(out, scr_mn2 = SCR_MN2)
  if ("SCR_ENG2" %in% names(out)) out <- dplyr::rename(out, scr_eng2 = SCR_ENG2)
  if ("DTVAL_CO" %in% names(out)) out <- dplyr::rename(out, value = DTVAL_CO)
  if ("value" %in% names(out)) out$value <- suppressWarnings(as.numeric(out$value))
  # Ensure code columns are character vectors, not list-cols
  if ("code" %in% names(out)) out$code <- .ms_to_chr(out$code, nrow(out))
  if ("code1" %in% names(out)) out$code1 <- .ms_to_chr(out$code1, nrow(out))
  if ("code2" %in% names(out)) out$code2 <- .ms_to_chr(out$code2, nrow(out))

  if (!identical(labels, "none")) {
    out <- .apply_labels_single(out, tbl_id, labels)
  }

  out
}

#' Fetch multiple tables in one request
#'
#' Wrapper around POST api/Package that accepts a data frame or list of
#' requests and returns a bound tibble of results.
#'
#' @param requests A data frame with columns `tbl_id`, and optional `period`,
#'   `code`, `code1`, `code2`; or a list of such records.
#' @param labels How to handle code labels: "none" (default, no labels), "en" (English labels only), "mn" (Mongolian labels only), or "both" (both English and Mongolian labels).
#' @return tibble of combined results with an added `tbl_id` column.
#' @export
nso_package <- function(requests, labels = c("none", "en", "mn", "both")) {
  if (missing(labels)) {
    labels <- getOption("mongolstats.default_labels", "none")
  } else {
    labels <- match.arg(labels)
  }
  if (is.data.frame(requests)) {
    reqs <- purrr::pmap(
      requests[, intersect(names(requests), c("tbl_id", "period", "code", "code1", "code2")), drop = FALSE],
      function(tbl_id, period = NULL, code = NULL, code1 = NULL, code2 = NULL) {
        .compact(list(
          tbl_id = unname(tbl_id),
          PERIOD = if (!is.null(period)) as.character(period) else NULL,
          CODE = if (!is.null(code)) as.character(code) else NULL,
          CODE1 = if (!is.null(code1)) as.character(code1) else NULL,
          CODE2 = if (!is.null(code2)) as.character(code2) else NULL
        ))
      }
    )
  } else if (is.list(requests)) {
    reqs <- lapply(requests, function(r) {
      .compact(list(
        tbl_id = unname(r$tbl_id),
        PERIOD = if (!is.null(r$period)) as.character(r$period) else NULL,
        CODE = if (!is.null(r$code)) as.character(r$code) else NULL,
        CODE1 = if (!is.null(r$code1)) as.character(r$code1) else NULL,
        CODE2 = if (!is.null(r$code2)) as.character(r$code2) else NULL
      ))
    })
  } else {
    stop("`requests` must be a data.frame or list of records")
  }

  res <- .nso_post("api/Package", body = reqs, query = list(type = "json"))
  dat <- res$DataList
  out <- .as_tibble_df(dat)
  if (nrow(out) == 0) return(out)

  # Standardize names
  if ("TBL_ID" %in% names(out)) out <- dplyr::rename(out, tbl_id = TBL_ID)
  if ("Indicator_RN" %in% names(out)) out <- dplyr::rename(out, tbl_id = Indicator_RN)
  if ("PERIOD" %in% names(out)) out <- dplyr::rename(out, period = PERIOD)
  if ("CODE" %in% names(out)) out <- dplyr::rename(out, code = CODE)
  if ("CODE1" %in% names(out)) out <- dplyr::rename(out, code1 = CODE1)
  if ("CODE2" %in% names(out)) out <- dplyr::rename(out, code2 = CODE2)
  if ("SCR_MN" %in% names(out)) out <- dplyr::rename(out, scr_mn = SCR_MN)
  if ("SCR_ENG" %in% names(out)) out <- dplyr::rename(out, scr_eng = SCR_ENG)
  if ("SCR_MN1" %in% names(out)) out <- dplyr::rename(out, scr_mn1 = SCR_MN1)
  if ("SCR_ENG1" %in% names(out)) out <- dplyr::rename(out, scr_eng1 = SCR_ENG1)
  if ("SCR_MN2" %in% names(out)) out <- dplyr::rename(out, scr_mn2 = SCR_MN2)
  if ("SCR_ENG2" %in% names(out)) out <- dplyr::rename(out, scr_eng2 = SCR_ENG2)
  if ("DTVAL_CO" %in% names(out)) out <- dplyr::rename(out, value = DTVAL_CO)
  if ("value" %in% names(out)) out$value <- suppressWarnings(as.numeric(out$value))
  # Ensure code columns are character vectors
  if ("code" %in% names(out)) out$code <- .ms_to_chr(out$code, nrow(out))
  if ("code1" %in% names(out)) out$code1 <- .ms_to_chr(out$code1, nrow(out))
  if ("code2" %in% names(out)) out$code2 <- .ms_to_chr(out$code2, nrow(out))

  if (!identical(labels, "none") && "tbl_id" %in% names(out)) {
    out <- .apply_labels_multi(out, labels)
  }

  out
}
