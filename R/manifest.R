.nso_manifest_scalar <- function(x) {
  is.character(x) && length(x) == 1L && !is.na(x) && nzchar(x)
}

.nso_manifest_object <- function(x) {
  is.list(x) &&
    !is.null(names(x)) &&
    !anyNA(names(x)) &&
    all(nzchar(names(x))) &&
    !anyDuplicated(names(x))
}

.nso_manifest_array <- function(x) is.list(x) && is.null(names(x))

.nso_manifest_text <- function(x) {
  (is.character(x) && !anyNA(x)) ||
    (.nso_manifest_array(x) && all(vapply(x, .nso_manifest_scalar, logical(1))))
}

.nso_manifest_count <- function(x, minimum = 0) {
  is.numeric(x) &&
    length(x) == 1L &&
    is.finite(x) &&
    x >= minimum &&
    x == floor(x)
}

.nso_manifest_time <- function(x) {
  if (
    !.nso_manifest_scalar(x) ||
      !grepl(
        "^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\\.[0-9]+)?Z$",
        x
      )
  ) {
    return(FALSE)
  }
  date <- as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")
  !is.na(date) &&
    format(date, "%Y-%m-%dT%H:%M:%S", tz = "UTC") == substr(x, 1L, 19L)
}

.nso_manifest_url <- function(x) {
  if (!.nso_manifest_scalar(x)) {
    return(FALSE)
  }
  parsed <- tryCatch(httr2::url_parse(x), error = function(e) NULL)
  !is.null(parsed) &&
    (parsed$scheme %||% "") %in% c("http", "https") &&
    nzchar(parsed$hostname %||% "") &&
    !nzchar(parsed$username %||% "") &&
    !nzchar(parsed$password %||% "")
}

.nso_manifest_status <- function(x) {
  if (is.data.frame(x)) {
    if (!nrow(x)) {
      return(TRUE)
    }
    return(
      all(c("value_raw", "value_status") %in% names(x)) &&
        is.character(x$value_raw) &&
        all(x$value_status %in% c("observed", "missing", "symbol"))
    )
  }
  .nso_manifest_array(x) &&
    all(vapply(
      x,
      function(row) {
        if (!.nso_manifest_object(row)) {
          return(FALSE)
        }
        raw <- row$value_raw
        valid_raw <- is.null(raw) || (is.character(raw) && length(raw) == 1L)
        all(c("value_raw", "value_status") %in% names(row)) &&
          valid_raw &&
          .nso_manifest_scalar(row$value_status) &&
          row$value_status %in% c("observed", "missing", "symbol")
      },
      logical(1)
    ))
}

.nso_manifest_entry <- function(x, kind = "record") {
  if (!.nso_manifest_object(x)) {
    return(FALSE)
  }
  required <- switch(
    kind,
    record = c("backend", "source_id", "url", "retrieved_at"),
    response = c(
      "url",
      "retrieved_at",
      "request",
      "result_rows",
      "metadata",
      "chunk_index"
    ),
    failure = "message"
  )
  if (!all(required %in% names(x))) {
    return(FALSE)
  }
  if (
    kind == "failure" &&
      !all(c("backend", "source_id") %in% names(x)) &&
      !"service" %in% names(x)
  ) {
    return(FALSE)
  }
  scalar <- intersect(
    c("backend", "source_id", "message", "service", "stage"),
    names(x)
  )
  if (!all(vapply(x[scalar], .nso_manifest_scalar, logical(1)))) {
    return(FALSE)
  }
  if ("url" %in% names(x) && !.nso_manifest_url(x$url)) {
    return(FALSE)
  }
  if ("retrieved_at" %in% names(x) && !.nso_manifest_time(x$retrieved_at)) {
    return(FALSE)
  }
  text <- intersect(
    c("source", "source_updated", "title", "unit_raw", "periods"),
    names(x)
  )
  if (!all(vapply(x[text], .nso_manifest_text, logical(1)))) {
    return(FALSE)
  }
  if (!is.null(x$language) && !.nso_manifest_scalar(x$language)) {
    return(FALSE)
  }
  if (!is.null(x$metadata_hash)) {
    if (!.nso_manifest_scalar(x$metadata_hash)) {
      return(FALSE)
    }
    if (!grepl("^[0-9a-f]{64}$", x$metadata_hash)) return(FALSE)
  }
  objects <- intersect(
    c("selections", "resolved_selections", "request", "metadata"),
    names(x)
  )
  if (!all(vapply(x[objects], is.list, logical(1)))) {
    return(FALSE)
  }
  if ("result_rows" %in% names(x) && !.nso_manifest_count(x$result_rows)) {
    return(FALSE)
  }
  indices <- intersect(c("request_index", "chunk_index"), names(x))
  if (!all(vapply(x[indices], .nso_manifest_count, logical(1), minimum = 1))) {
    return(FALSE)
  }
  if (!is.null(x$requests)) {
    if (!.nso_manifest_array(x$requests)) {
      return(FALSE)
    }
    if (!all(vapply(x$requests, .nso_manifest_object, logical(1)))) {
      return(FALSE)
    }
  }
  if (
    !is.null(x$responses) && !.nso_manifest_entries(x$responses, "response")
  ) {
    return(FALSE)
  }
  if (
    !is.null(x$completed_records) &&
      !.nso_manifest_entries(x$completed_records, "record")
  ) {
    return(FALSE)
  }
  is.null(x$completed_status) || .nso_manifest_status(x$completed_status)
}

.nso_manifest_entries <- function(x, kind) {
  .nso_manifest_array(x) &&
    all(vapply(x, .nso_manifest_entry, logical(1), kind = kind))
}

.nso_normalize_manifest_entry <- function(x) {
  text <- intersect(
    c("source", "source_updated", "title", "unit_raw", "periods"),
    names(x)
  )
  for (field in text) {
    x[[field]] <- as.character(unlist(x[[field]], use.names = FALSE))
  }
  if (length(x$completed_records)) {
    x$completed_records <- lapply(
      x$completed_records,
      .nso_normalize_manifest_entry
    )
  }
  if (!is.null(x$completed_status) && !is.data.frame(x$completed_status)) {
    x$completed_status <- dplyr::bind_rows(x$completed_status)
    if (
      nrow(x$completed_status) && !"value_raw" %in% names(x$completed_status)
    ) {
      x$completed_status$value_raw <- rep(
        NA_character_,
        nrow(x$completed_status)
      )
    }
  }
  x
}

.nso_validate_manifest <- function(x) {
  valid <- .nso_manifest_object(x) &&
    identical(x$schema_version, 1L) &&
    all(c("records", "failures") %in% names(x)) &&
    .nso_manifest_entries(x$records, "record") &&
    .nso_manifest_entries(x$failures, "failure")
  if (!valid) {
    cli_abort(
      "Unsupported or malformed provenance manifest.",
      class = "mongolstats_manifest_error"
    )
  }
  .nso_manifest(
    lapply(x$records, .nso_normalize_manifest_entry),
    lapply(x$failures, .nso_normalize_manifest_entry)
  )
}
