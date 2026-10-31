.px_status_parts <- function(parts, vars, columns) {
  .px_label_time(
    dplyr::bind_rows(lapply(parts, nso_value_status)),
    vars,
    columns
  )
}

.px_response_context <- function(raw, request, index, fallback_url) {
  list(
    chunk_index = index,
    url = attr(raw, "response_url") %||% fallback_url,
    retrieved_at = attr(raw, "retrieved_at") %||%
      format(Sys.time(), "%Y-%m-%dT%H:%M:%OS3Z", tz = "UTC"),
    request = request,
    result_rows = length(raw$data),
    metadata = raw$metadata %||% list(),
    comments = raw$comments %||% list()
  )
}

.px_data_record <- function(
  tm,
  selections,
  resolved_sel,
  chunks,
  raws,
  responses,
  lang,
  rows
) {
  vars <- tm$meta$variables
  metadata <- lapply(raws, function(raw) raw$metadata %||% list())
  comments <- unlist(
    lapply(raws, function(raw) raw$comments %||% list()),
    recursive = FALSE
  )
  url <- if (length(responses)) {
    responses[[length(responses)]]$url
  } else {
    .px_url(tm$paths, tm$px_file, lang = lang)
  }
  df <- .nso_attach_provenance(
    tibble::tibble(.rows = rows),
    "pxweb",
    sub("\\.px$", "", tm$px_file, ignore.case = TRUE),
    url,
    selections = selections,
    metadata = metadata,
    comments = comments,
    language = lang
  )
  record <- nso_provenance(df)$records[[1]]
  record$title <- unique(c(tm$meta$title, record$title))
  record$requests <- lapply(chunks, function(chunk) .px_query_body(vars, chunk))
  record$responses <- responses
  record$resolved_selections <- stats::setNames(
    lapply(vars, function(v) {
      code <- resolved_sel[[as.character(v$code)]]
      list(
        code = code,
        label = .px_chr(v$valueTexts)[match(code, .px_chr(v$values))]
      )
    }),
    vapply(vars, function(v) as.character(v$code), character(1))
  )
  tv <- .px_time_var(vars)
  record$periods <- if (tv) {
    record$resolved_selections[[tv]]$label
  } else {
    character()
  }
  record
}
