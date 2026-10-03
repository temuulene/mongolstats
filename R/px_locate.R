# Finding tables that are not where the embedded index says --------------
#
# NSO reorganises its catalogue from time to time, moving tables between
# folders. A table whose folder changed after the embedded index was built
# returns HTTP 400 for its old metadata URL. These helpers find the table's
# current folder in the live catalogue and update the in-memory index, so
# lookups keep working until the next index rebuild.

# Resolve a table and fetch its metadata, relocating the table once if its
# indexed folder no longer holds it. Returns a list with `meta`, `px_file`,
# `paths`, and `row` (as .px_resolve_table()).
.px_table_meta <- function(tbl_id, lang = .px_lang(), call = rlang::caller_env()) {
  resolved <- .px_resolve_table(tbl_id, call = call)
  meta <- tryCatch(
    .px_meta_cached(resolved$paths, resolved$px_file, lang = lang),
    mongolstats_http_error = function(e) e
  )
  if (inherits(meta, "error")) {
    if (!isTRUE(meta$status %in% c(400L, 404L))) {
      stop(meta)
    }
    moved <- .px_relocate_table(resolved)
    if (is.null(moved)) {
      cli_abort(
        c(
          "Table {.val {tbl_id}} is no longer in folder {.val {resolved$row$px_path[1]}}
           and was not found elsewhere in the NSO catalogue.",
          "i" = "It may have been withdrawn. Search for a replacement with {.fn nso_search}."
        ),
        class = "mongolstats_http_error",
        status = meta$status,
        parent = meta,
        call = call
      )
    }
    if (identical(moved$paths, resolved$paths)) {
      # Still listed in its folder: the request failed for another reason
      stop(meta)
    }
    resolved <- moved
    meta <- .px_meta_cached(resolved$paths, resolved$px_file, lang = lang)
  }
  c(list(meta = meta), resolved)
}

# Find the current folder of an indexed table that moved. Tries the PXWeb
# search API first (cheap, but its own index can lag behind the catalogue,
# so every hit is checked), then walks the catalogue outwards from the old
# folder. Returns a resolved table (see .px_resolve_table()), unchanged when
# the table is still listed in its old folder, or NULL when it is nowhere.
.px_relocate_table <- function(resolved) {
  px_file <- resolved$px_file
  old_path <- resolved$row$px_path[1]
  tbl <- sub("\\.px$", "", px_file, ignore.case = TRUE)
  # A table already searched for in vain this session is not searched again
  if (tolower(px_file) %in% .mongolstats_px_env$missing) {
    return(NULL)
  }
  new_paths <- NULL
  hits <- tryCatch(
    .px_search_remote(tbl),
    mongolstats_http_error = function(e) NULL
  )
  if (length(hits$id)) {
    for (p in unique(hits$path[tolower(hits$id) == tolower(px_file)])) {
      segs <- .px_split_path(p)
      if (!identical(paste(segs, collapse = "/"), old_path) && .px_table_exists(segs, px_file)) {
        new_paths <- segs
        break
      }
    }
  }
  if (is.null(new_paths)) {
    cli_inform(
      c("i" = "Table {.val {tbl}} is no longer in folder {.val {old_path}}; searching the NSO catalogue for it."),
      class = "mongolstats_table_search"
    )
    new_paths <- .px_find_in_catalogue(px_file, start = .px_split_path(old_path))
  }
  if (is.null(new_paths)) {
    .mongolstats_px_env$missing <- c(.mongolstats_px_env$missing, tolower(px_file))
    return(NULL)
  }
  new_path <- paste(new_paths, collapse = "/")
  if (identical(new_path, old_path)) {
    return(resolved)
  }
  idx <- .px_index()
  moved <- tolower(idx$px_file) == tolower(px_file) & idx$px_path == old_path
  idx$px_path[moved] <- new_path
  if ("list_id" %in% names(idx)) idx$list_id[moved] <- new_path
  .mongolstats_px_env$idx <- idx
  cli_inform(
    c(
      "i" = "Table {.val {tbl}} has moved to folder {.val {new_path}}.",
      " " = "Rebuild the table index with {.fn nso_rebuild_px_index} to refresh all locations."
    ),
    class = "mongolstats_table_moved"
  )
  resolved$paths <- new_paths
  resolved$row$px_path <- new_path
  resolved
}

# Look up a table id that is missing from the index (e.g. published after
# the index was built) with the PXWeb search API. Returns a one-row index
# tibble (also added to the in-memory index) or NULL.
.px_locate_new_table <- function(px_file) {
  hits <- tryCatch(
    .px_search_remote(sub("\\.px$", "", px_file, ignore.case = TRUE)),
    mongolstats_http_error = function(e) NULL
  )
  if (!length(hits$id)) {
    return(NULL)
  }
  hits <- hits[tolower(hits$id) == tolower(px_file), , drop = FALSE]
  for (i in seq_len(nrow(hits))) {
    segs <- .px_split_path(hits$path[i])
    if (!.px_table_exists(segs, hits$id[i])) {
      next
    }
    row <- tibble::tibble(
      px_path = paste(segs, collapse = "/"),
      px_file = hits$id[i],
      tbl_id = sub("\\.px$", "", hits$id[i], ignore.case = TRUE),
      tbl_eng_nm = if (identical(.px_lang(), "en")) hits$title[i] else NA_character_,
      tbl_nm = if (identical(.px_lang(), "mn")) hits$title[i] else NA_character_
    )
    .mongolstats_px_env$idx <- dplyr::bind_rows(.px_index(), row)
    cli_inform(
      c("i" = "Table {.val {row$tbl_id}} is not in the bundled table index; found it in folder {.val {row$px_path}}."),
      class = "mongolstats_table_located"
    )
    return(row)
  }
  NULL
}

# PXWeb search API: tables whose id or title matches `query`. Returns a data
# frame with `id`, `path`, `title`, `score`, `published` (possibly empty).
.px_search_remote <- function(query, lang = .px_lang()) {
  req <- .nso_request(.px_url(lang = lang)) |>
    httr2::req_url_query(query = query)
  res <- .nso_perform(req)
  out <- jsonlite::fromJSON(.px_strip_bom(httr2::resp_body_string(res)), simplifyVector = TRUE)
  if (!is.data.frame(out)) {
    return(data.frame(id = character(), path = character(), title = character()))
  }
  out
}

# Does the table's metadata URL answer? Offline mode propagates.
.px_table_exists <- function(paths, px_file) {
  tryCatch(
    {
      .px_meta_cached(paths, px_file, lang = .px_lang())
      TRUE
    },
    mongolstats_http_error = function(e) FALSE
  )
}

# Breadth-first search for `px_file`, starting in folder `start` and moving
# out one level at a time (old folder, its parent, ..., the catalogue root),
# never listing a folder twice. Returns the folder's path segments or NULL.
.px_find_in_catalogue <- function(px_file, start = character()) {
  seen <- character()
  for (depth in rev(seq(0L, length(start)))) {
    queue <- list(start[seq_len(depth)])
    while (length(queue)) {
      paths <- queue[[1]]
      queue <- queue[-1]
      key <- paste(paths, collapse = "/")
      if (key %in% seen) {
        next
      }
      seen <- c(seen, key)
      kids <- tryCatch(
        .px_list_cached(paths, lang = .px_lang()),
        mongolstats_http_error = function(e) NULL
      )
      if (!length(kids) || !nrow(kids)) {
        next
      }
      if (any(kids$type == "t" & tolower(kids$id) == tolower(px_file))) {
        return(paths)
      }
      for (id in kids$id[kids$type == "l"]) {
        queue[[length(queue) + 1L]] <- c(paths, id)
      }
    }
  }
  NULL
}

.px_split_path <- function(path) {
  path <- sub("^/+", "", path %||% "")
  if (!nzchar(path)) character() else strsplit(path, "/", fixed = TRUE)[[1]]
}
