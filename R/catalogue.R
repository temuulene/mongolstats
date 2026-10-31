#' Inspect the freshness and coverage of the table catalogue
#'
#' Reports index coverage and distinct table counts separately from cross-listed
#' catalogue entries. A bundled index with an unknown build time is identified
#' explicitly. Live keyword searches describe a search window rather than a
#' complete catalogue rebuild.
#'
#' @return A one-row tibble with service identity, `entries`, distinct `tables`,
#'   `coverage`, `indexed_at`, and the source of the index.
#' @examples
#' # Inspect the bundled or session catalogue without a network request.
#' nso_catalogue_status()
#' @export
nso_catalogue_status <- function() {
  idx <- .px_index()
  meta <- attr(idx, "catalogue", exact = TRUE) %||% list()
  tibble::tibble(
    backend = "pxweb",
    base_url = .px_base_url(),
    database = .px_db(),
    entries = nrow(idx),
    tables = if ("tbl_id" %in% names(idx)) {
      dplyr::n_distinct(idx$tbl_id)
    } else {
      0L
    },
    coverage = meta$coverage %||% "unknown",
    indexed_at = meta$indexed_at %||% NA_character_,
    origin = meta$origin %||% "bundled_or_session"
  )
}

.nso_live_search <- function(query) {
  if (.nso_offline()) {
    cli_abort(
      "Live catalogue search is unavailable in offline mode.",
      class = "mongolstats_offline_error"
    )
  }
  hits <- .px_search_remote(query)
  if (!is.data.frame(hits) || !all(c("id", "path", "title") %in% names(hits))) {
    cli_abort(
      "PXWeb search returned an unexpected catalogue response.",
      class = "mongolstats_invalid_response"
    )
  }
  paths <- vapply(
    hits$path,
    function(path) paste(.px_split_path(path), collapse = "/"),
    character(1)
  )
  out <- tibble::tibble(
    px_path = paths,
    px_file = as.character(hits$id),
    tbl_id = sub("\\.px$", "", hits$id, ignore.case = TRUE),
    tbl_eng_nm = if (.px_lang() == "en") {
      as.character(hits$title)
    } else {
      rep(NA_character_, nrow(hits))
    },
    tbl_nm = if (.px_lang() == "mn") {
      as.character(hits$title)
    } else {
      rep(NA_character_, nrow(hits))
    },
    strt_prd = rep(NA_character_, nrow(hits)),
    end_prd = rep(NA_character_, nrow(hits)),
    updated = if ("published" %in% names(hits)) {
      as.character(hits$published)
    } else {
      rep(NA_character_, nrow(hits))
    },
    list_id = paths
  )
  attr(out, "catalogue") <- list(
    coverage = "search_window",
    origin = "live_search",
    indexed_at = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  )
  out
}
