# Label helpers -----------------------------------------------------------

#' @keywords internal
#' @noRd
.apply_labels_single <- function(df, tbl_id, labels) {
  cb <- tryCatch(nso_itms_detail(tbl_id), error = function(e) NULL)
  if (is.null(cb) || nrow(cb) == 0) {
    return(df)
  }
  add_lab <- function(d, field, code_col) {
    if (!code_col %in% names(d)) {
      return(d)
    }
    map <- cb[cb$field == field, c("itm_id", "scr_eng", "scr_mn")]
    if (nrow(map) == 0) {
      return(d)
    }
    names(map) <- c(code_col, paste0(code_col, "_en"), paste0(code_col, "_mn"))
    dplyr::left_join(d, map, by = code_col)
  }
  df <- add_lab(df, "CODE", "code")
  df <- add_lab(df, "CODE1", "code1")
  df <- add_lab(df, "CODE2", "code2")
  if (labels == "en") {
    df <- df[, setdiff(names(df), grep("_mn$", names(df), value = TRUE))]
  }
  if (labels == "mn") {
    df <- df[, setdiff(names(df), grep("_en$", names(df), value = TRUE))]
  }
  df
}

#' @keywords internal
#' @noRd
.apply_labels_multi <- function(df, labels) {
  split <- split(df, df$tbl_id)
  out <- lapply(names(split), function(id) {
    .apply_labels_single(split[[id]], id, labels)
  })
  dplyr::bind_rows(out)
}
