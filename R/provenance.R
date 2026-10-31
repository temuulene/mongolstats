.nso_metadata_values <- function(x, field) {
  if (!is.list(x)) {
    return(character())
  }
  own <- x[[field]]
  own <- if (is.atomic(own)) as.character(own) else character()
  nested <- unlist(
    lapply(
      x[vapply(x, is.list, logical(1))],
      .nso_metadata_values,
      field = field
    ),
    use.names = FALSE
  )
  out <- c(own, nested)
  unique(out[!is.na(out) & nzchar(out)])
}

.nso_manifest <- function(records = list(), failures = list()) {
  structure(
    list(schema_version = 1L, records = records, failures = failures),
    class = c("nso_manifest", "list")
  )
}

.nso_bind_results <- function(parts, failures = list()) {
  out <- dplyr::bind_rows(parts)
  records <- unlist(
    lapply(parts, function(part) nso_provenance(part)$records),
    recursive = FALSE
  )
  attr(out, "nso_provenance") <- .nso_manifest(records, failures)
  status <- purrr::map_dfr(parts, function(part) {
    values <- nso_value_status(part)
    if (nrow(values)) {
      values$tbl_id <- rep(unique(part$tbl_id)[1], nrow(values))
    }
    values
  })
  attr(out, "nso_value_status") <- status
  out
}

.nso_fetch_failure <- function(
  error,
  tbl_id,
  selections,
  data = NULL,
  stage = "data"
) {
  previous <- nso_provenance(error)$failures
  failure <- if (length(previous)) {
    previous[[1]]
  } else {
    list(
      backend = "pxweb",
      source_id = tbl_id,
      selections = selections,
      retrieved_at = format(Sys.time(), "%Y-%m-%dT%H:%M:%OS3Z", tz = "UTC")
    )
  }
  failure$message <- conditionMessage(error)
  failure$stage <- stage
  if (!is.null(data)) {
    failure$completed_records <- nso_provenance(data)$records
    failure$completed_status <- nso_value_status(data)
  }
  failure
}

.nso_batch_context <- function(part, request, index) {
  if (inherits(part, "mongolstats_failed_fetch")) {
    part$failure <- part$failure %||%
      list(
        backend = "pxweb",
        source_id = part$tbl_id,
        message = part$message,
        selections = request$selections
      )
    part$failure$request_index <- index
    if (length(part$failure$completed_records)) {
      part$failure$completed_records <- lapply(
        part$failure$completed_records,
        function(record) {
          record$request_index <- index
          record
        }
      )
    }
    return(part)
  }
  manifest <- nso_provenance(part)
  manifest$records <- lapply(manifest$records, function(record) {
    record$request_index <- index
    record
  })
  attr(part, "nso_provenance") <- manifest
  status <- nso_value_status(part)
  if (nrow(status)) {
    status$request_index <- rep(index, nrow(status))
  }
  attr(part, "nso_value_status") <- status
  part
}

.nso_attach_provenance <- function(
  data,
  backend,
  source_id,
  url,
  selections = list(),
  metadata = list(),
  comments = list(),
  retrieved_at = Sys.time(),
  language = NULL,
  failures = list()
) {
  record <- list(
    backend = backend,
    source_id = source_id,
    url = url,
    language = language,
    selections = selections,
    retrieved_at = format(retrieved_at, "%Y-%m-%dT%H:%M:%OS3Z", tz = "UTC"),
    source = .nso_metadata_values(metadata, "source"),
    source_updated = .nso_metadata_values(metadata, "updated"),
    title = .nso_metadata_values(metadata, "label"),
    unit_raw = unique(c(
      .nso_metadata_values(metadata, "unit"),
      .nso_metadata_values(metadata, "measure_type")
    )),
    metadata = metadata,
    comments = comments,
    metadata_hash = digest::digest(metadata, algo = "sha256"),
    result_rows = nrow(data),
    requests = list()
  )
  attr(data, "nso_provenance") <- .nso_manifest(list(record), failures)
  data
}

#' Retrieve a data result's provenance manifest
#'
#' Provenance records the service, source identifier, resolved URL, selections,
#' retrieval time, source metadata, comments, and a metadata fingerprint.
#' A batch result contains one record per successful table and explicit failure
#' records with request indices. Fetch error conditions retain attempted queries
#' and completed response context; partial tables are never returned as complete.
#' Attributes can be discarded by transformations; save a sidecar with
#' [nso_write_manifest()] before modifying the original result.
#'
#' @param x A fetched result, fetch error condition, or a manifest from
#'   [nso_read_manifest()].
#' @return A list of class `nso_manifest` with `schema_version`, `records`, and
#'   `failures`. An unannotated result has empty records and failures.
#' @examples
#' # Provenance is not inferred for an ordinary data frame.
#' observations <- data.frame(value = c(12, 15))
#' manifest <- nso_provenance(observations)
#' manifest$records
#' manifest$failures
#' @export
nso_provenance <- function(x) {
  if (inherits(x, "nso_manifest")) {
    return(x)
  }
  if (inherits(x, "condition") && inherits(x$nso_manifest, "nso_manifest")) {
    return(x$nso_manifest)
  }
  attr(x, "nso_provenance", exact = TRUE) %||% .nso_manifest()
}

#' Inspect table source information
#'
#' Fetching a table may supply source information unavailable in its dimension
#' codebook. Inspect a fetched result to see this information. Passing a PXWeb
#' table identifier retrieves its title and dimensions; it does not request
#' observations or infer missing source information.
#'
#' @param x A fetched result, a provenance manifest, or one PXWeb table ID.
#' @return A tibble with one row per provenance record: service, source ID,
#'   title, source statement, update time, unit, URL, retrieval time, and
#'   source metadata in a list-column. Fields absent upstream remain missing.
#' @examples
#' # An unannotated data frame has no source information to report.
#' observations <- data.frame(value = c(12, 15))
#' nso_table_info(observations)
#' nso_table_info(nso_provenance(observations))
#' @export
nso_table_info <- function(x) {
  if (is.character(x) && length(x) == 1L) {
    check_tbl_id(x)
    tm <- .px_table_meta(x)
    url <- .px_url(tm$paths, tm$px_file)
    meta <- tm$meta
    meta$label <- meta$title
    x <- .nso_attach_provenance(
      tibble::tibble(),
      "pxweb",
      x,
      url,
      metadata = meta,
      language = .px_lang()
    )
  }
  records <- nso_provenance(x)$records
  if (!length(records)) {
    return(tibble::tibble())
  }
  text <- function(value) {
    if (length(value)) paste(value, collapse = "\n") else NA_character_
  }
  purrr::map_dfr(records, function(r) {
    tibble::tibble(
      backend = r$backend,
      source_id = r$source_id,
      title = text(r$title),
      source = text(r$source),
      source_updated = text(r$source_updated),
      unit_raw = text(r$unit_raw),
      url = r$url,
      retrieved_at = r$retrieved_at,
      metadata = list(r$metadata)
    )
  })
}

#' Generate source citations for fetched statistics
#'
#' Citations describe the source rather than the software license. NSO public
#' statistics are subject to the source's terms of use and attribution rules;
#' other catalog records may have different access and reuse conditions.
#'
#' @param x A fetched result or provenance manifest.
#' @return A character vector of citations, one per source record.
#' @references <https://www.nso.mn/en/terms_of_use>
#' @examples
#' # No citation is invented for data without source records.
#' observations <- data.frame(value = c(12, 15))
#' nso_citation(observations)
#' @export
nso_citation <- function(x) {
  unique(vapply(
    nso_provenance(x)$records,
    function(r) {
      title <- if (length(r$title)) {
        paste(r$title, collapse = "; ")
      } else {
        r$source_id
      }
      updated <- if (length(r$source_updated)) {
        paste0("; source updated ", paste(r$source_updated, collapse = ", "))
      } else {
        ""
      }
      paste0(
        "National Statistics Office of Mongolia. ",
        title,
        " [",
        r$backend,
        ":",
        r$source_id,
        "]. ",
        r$url,
        " (retrieved ",
        substr(r$retrieved_at, 1L, 10L),
        updated,
        ")."
      )
    },
    character(1)
  ))
}

#' Save or reload a provenance sidecar
#'
#' JSON sidecars preserve source identity and query context separately from
#' CSV exports or transformed tibbles. Save [nso_value_status()] separately for
#' successful results when source symbols matter. Failed fetch manifests retain
#' status from completed chunks when available. Both reading and writing validate
#' the manifest schema. Reading accepts local files; replacement writes preserve
#' the previous file if installing the new file fails.
#'
#' @param x A fetched result, fetch error condition, or provenance manifest.
#' @param path JSON file path.
#' @param overwrite Whether to replace an existing file. Defaults to `FALSE`.
#' @return `nso_write_manifest()` returns `path` invisibly;
#'   `nso_read_manifest()` returns an `nso_manifest`.
#' @examples
#' # An unannotated table produces an empty provenance manifest.
#' observations <- data.frame(value = c(12, 15))
#' path <- tempfile(fileext = ".json")
#' nso_write_manifest(observations, path)
#' saved <- nso_read_manifest(path)
#' identical(saved, nso_provenance(observations))
#' unlink(path)
#' @export
nso_write_manifest <- function(x, path, overwrite = FALSE) {
  .nso_manifest_path(path)
  if (!is.logical(overwrite) || length(overwrite) != 1L || is.na(overwrite)) {
    cli_abort("{.arg overwrite} must be {.code TRUE} or {.code FALSE}.")
  }
  if (file.exists(path) && !overwrite) {
    cli_abort("File {.path {path}} already exists.")
  }
  manifest <- .nso_validate_manifest(nso_provenance(x))
  temporary <- tempfile(".nso-manifest-", tmpdir = dirname(path))
  on.exit(unlink(temporary), add = TRUE)
  tryCatch(
    {
      jsonlite::write_json(
        unclass(manifest),
        temporary,
        auto_unbox = TRUE,
        null = "null",
        pretty = TRUE,
        digits = NA
      )
      .nso_replace_manifest(temporary, path, overwrite)
    },
    error = function(e) {
      cli_abort(
        "Cannot write provenance manifest.",
        class = "mongolstats_manifest_error",
        parent = e
      )
    }
  )
  invisible(path)
}

#' @rdname nso_write_manifest
#' @export
nso_read_manifest <- function(path) {
  .nso_manifest_path(path)
  raw <- tryCatch(
    {
      if (!file.exists(path)) {
        stop("The manifest file does not exist.")
      }
      jsonlite::parse_json(
        paste(
          readLines(path, warn = FALSE, encoding = "UTF-8"),
          collapse = "\n"
        ),
        simplifyVector = FALSE
      )
    },
    error = function(e) {
      cli_abort(
        "Cannot read provenance manifest.",
        class = "mongolstats_manifest_error",
        parent = e
      )
    }
  )
  .nso_validate_manifest(raw)
}

.nso_replace_manifest <- function(temporary, path, overwrite) {
  backup <- NULL
  if (file.exists(path)) {
    if (!overwrite) {
      stop("The output file already exists.")
    }
    backup <- tempfile(".nso-manifest-backup-", tmpdir = dirname(path))
    if (!file.rename(path, backup)) {
      stop("Cannot preserve the previous manifest.")
    }
    # Restore the previous file if installing the replacement fails.
    on.exit(
      {
        if (!file.exists(path)) {
          file.rename(backup, path)
        }
        if (file.exists(path)) unlink(backup)
      },
      add = TRUE
    )
  }
  if (!file.rename(temporary, path)) stop("Cannot install the manifest.")
}

.nso_manifest_path <- function(path) {
  if (
    !is.character(path) || length(path) != 1L || is.na(path) || !nzchar(path)
  ) {
    cli_abort("{.arg path} must be a single non-empty file path.")
  }
}
