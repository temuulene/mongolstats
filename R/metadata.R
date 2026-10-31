#' Retrieve a typed record from the government metadata catalogue
#'
#' @description
#' These experimental interfaces expose the public catalogue at
#' <https://metadata.nso.mn/>. Its numeric identifiers belong to a separate
#' service from PXWeb table identifiers. An `indicator` can describe a
#' questionnaire field rather than a published statistical series.
#'
#' @param type Entity type: `"database"`, `"table"`, `"indicator"`,
#'   `"classification"`, or `"form"`.
#' @param id A positive integer identifier in the metadata service.
#' @param include_raw Retain the complete parsed response in `$raw`.
#' @return An `nso_metadata` list with source-qualified identity, official
#'   Mongolian text and available English text, dates, integer years,
#'   methodology, access statements, relationships, and quality flags.
#'   `$context` retains units, value types, collection sources, dissemination
#'   levels, and the responsible department. Its category records preserve
#'   source identifiers and official labels. `$date_fields` retains original
#'   date and year values, including invalid values, alongside parsed `$dates`
#'   and `$years`, even when `include_raw = FALSE`.
#'   Missing translations remain `NA`; no translation is generated. Dates
#'   use the calendar date supplied by the service, independent of the local
#'   time zone. Access statements and licence categories do not establish
#'   that the underlying records are publicly downloadable.
#' @details
#' Quality flags identify potential inconsistencies and do not correct the
#' upstream record. `include_raw = TRUE` preserves unrecognized fields for
#' inspection. These endpoints have no published stability guarantee.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' field <- nso_metadata("indicator", 12925, include_raw = TRUE)
#' field$quality_flags
#' nso_related(field)
#' @export
nso_metadata <- function(type, id, include_raw = FALSE) {
  type <- .nso_metadata_type(type)
  id <- .nso_metadata_id(id)
  .nso_metadata_raw_option(include_raw)
  raw <- .nso_metadata_request(type, id)
  .nso_metadata_record(raw, type, id, include_raw)
}

#' Search or browse the government metadata catalogue
#'
#' @param query Search text. A nonempty query uses the site's public search
#'   interface and returns its limited result window, with no pagination.
#' @param type Entity type, `"all"`, `"organization"`, or `"sector"`.
#'   With an empty query, browse `"database"`, `"organization"`, or `"sector"`.
#' @param organization Numeric organization identifier. Required to browse
#'   databases with an empty query.
#' @param sector Numeric sector identifier. Filtering applies only to rows
#'   present in the returned response, and rows without the required metadata
#'   are excluded. The `unresolved_filter_rows` attribute counts those rows.
#' @param page Positive page number for database browsing. The package sends
#'   this value to the service and preserves the reported pagination without
#'   assuming that the server honored the requested page.
#' @return A tibble of source-qualified references. Attributes `coverage`,
#'   `exhaustive`, `pagination`, `retrieved_at`, and `unresolved_filter_rows`
#'   describe the scope. `exhaustive` is always `FALSE`: a returned page,
#'   search window, or response catalogue is not a verified complete inventory.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' nso_metadata_search("\u044d\u0440\u04af\u04af\u043b \u043c\u044d\u043d\u0434", type = "all")
#' nso_metadata_search(organization = 1, page = 1)
#' nso_metadata_search(type = "organization")
#' @export
nso_metadata_search <- function(
  query = "",
  type = "database",
  organization = NULL,
  sector = NULL,
  page = 1
) {
  if (!is.character(query) || length(query) != 1L || is.na(query)) {
    cli::cli_abort("{.arg query} must be a single string.")
  }
  type <- .nso_metadata_type(type, search = TRUE)
  page <- as.integer(.nso_metadata_id(page, "page"))
  organization <- if (!is.null(organization)) {
    .nso_metadata_id(organization, "organization")
  }
  sector <- if (!is.null(sector)) .nso_metadata_id(sector, "sector")
  query <- trimws(query)
  pagination <- NULL
  if (nzchar(query)) {
    if (page != 1L) {
      cli::cli_abort("The public search interface has no verified pagination.")
    }
    if (type %in% c("organization", "sector")) {
      cli::cli_abort(
        "Search {.arg query} supports database, table, indicator, classification, form, or all."
      )
    }
    raw <- .nso_metadata_request("elastic", body = list(values = query))
    response <- .nso_metadata_text(raw$response)
    if (is.na(response) || !startsWith(trimws(response), "{")) {
      .nso_metadata_schema_error(
        "The public search response does not contain embedded JSON text."
      )
    }
    parsed <- tryCatch(
      jsonlite::fromJSON(raw$response, simplifyVector = FALSE),
      error = function(e) NULL
    )
    if (!is.list(parsed$hits) || !is.list(parsed$hits$hits)) {
      .nso_metadata_schema_error("The public search response has no hit list.")
    }
    entries <- lapply(parsed$hits$hits, .nso_metadata_hit)
    entries <- Filter(Negate(is.null), entries)
    coverage <- "server_search_window"
    pagination <- list(total = parsed$hits$total, returned = length(entries))
  } else if (type == "database") {
    if (is.null(organization)) {
      cli::cli_abort(
        "Supply {.arg organization} to browse databases, or provide a search {.arg query}."
      )
    }
    raw <- .nso_metadata_request(
      "database",
      query = list(org = organization, page = page)
    )
    if (!is.list(raw$data)) {
      .nso_metadata_schema_error("The database listing has no data list.")
    }
    entries <- lapply(raw$data, \(x) list(type = type, raw = x))
    coverage <- "returned_page"
    pagination <- list(
      requested_page = page,
      current_page = raw$currentPage,
      last_page = raw$lastPage,
      per_page = raw$perPage,
      total = raw$allresults
    )
  } else if (type %in% c("organization", "sector")) {
    if (page != 1L) {
      cli::cli_abort("This response catalogue has no verified pagination.")
    }
    if (!is.null(organization) || !is.null(sector)) {
      cli::cli_abort(
        "Organization and sector filters apply to entity search or database browsing."
      )
    }
    raw <- .nso_metadata_request(type)
    if (!is.list(raw) || !is.null(names(raw))) {
      .nso_metadata_schema_error(
        "The response catalogue is not a list of records."
      )
    }
    entries <- lapply(raw, \(x) list(type = type, raw = x))
    coverage <- "response_catalog"
  } else {
    cli::cli_abort("Supply a nonempty {.arg query} for this {.arg type}.")
  }
  out <- .nso_metadata_refs()
  unresolved <- 0L
  for (entry in entries) {
    if (type != "all" && type != entry$type) {
      next
    }
    row <- entry$raw
    org_id <- .nso_metadata_text(row$org_id %||% row$organization$id)
    sector_value <- if (is.list(row$sector)) row$sector$id else row$sector
    sector_id <- .nso_metadata_text(
      row$sector_id %||% row$sectors$id %||% sector_value
    )
    # The organization of a database browse is established by its request.
    if (!nzchar(query) && type == "database" && is.na(org_id)) {
      org_id <- organization
    }
    unresolved_org <- !is.null(organization) && is.na(org_id)
    unresolved_sector <- !is.null(sector) && is.na(sector_id)
    if (unresolved_org || unresolved_sector) {
      unresolved <- unresolved + 1L
      next
    }
    if (!is.null(organization) && org_id != organization) {
      next
    }
    if (!is.null(sector) && sector_id != sector) {
      next
    }
    out <- dplyr::bind_rows(out, .nso_metadata_ref(row, entry$type))
  }
  attr(out, "coverage") <- coverage
  attr(out, "exhaustive") <- FALSE
  attr(out, "pagination") <- pagination
  attr(out, "retrieved_at") <- Sys.time()
  attr(out, "unresolved_filter_rows") <- unresolved
  out
}

#' Inspect relationships in a metadata record
#'
#' @param record An `nso_metadata` result.
#' @return A tibble of source-qualified references. This function does not
#'   make network requests; embedded records may be partial. Retrieve the
#'   full record with [nso_metadata()] where its type is supported.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' database <- nso_metadata("database", 526)
#' nso_related(database)
#' @export
nso_related <- function(record) {
  if (!inherits(record, "nso_metadata")) {
    cli::cli_abort("{.arg record} must be an {.cls nso_metadata} result.")
  }
  record$related
}

#' List collection forms embedded in a metadata database record
#'
#' @param database_id A numeric metadata database identifier.
#' @param include_raw Retain the source database response in the result's
#'   `metadata` attribute and embedded raw form fields in `records`.
#' @return A tibble of form references with a `records` list column of typed
#'   embedded records. Records may be partial; use [nso_metadata()] with
#'   `type = "form"` to retrieve full details. An empty result means the
#'   database response contained no forms.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' forms <- nso_forms(database_id = 526)
#' forms[c("type", "id", "name_mn")]
#' forms$records
#' @export
nso_forms <- function(database_id, include_raw = FALSE) {
  .nso_metadata_raw_option(include_raw)
  record <- nso_metadata("database", database_id, include_raw = TRUE)
  forms <- record$raw$forms %||% list()
  out <- .nso_metadata_refs()
  records <- list()
  for (form in forms) {
    reference <- .nso_metadata_ref(form, "form")
    out <- dplyr::bind_rows(out, reference)
    records[[length(records) + 1L]] <- .nso_metadata_record(
      form,
      "form",
      reference$id,
      include_raw
    )
  }
  out$records <- records
  if (!include_raw) {
    record$raw <- NULL
  }
  attr(out, "metadata") <- record
  attr(out, "coverage") <- "embedded_records"
  out
}

#' Retrieve a versioned metadata classification codebook
#'
#' @param id Numeric metadata classification identifier.
#' @param include_raw Retain the raw response in the `metadata` attribute.
#' @return A tibble with character codes, definitions, parent codes, source,
#'   and version. Attributes contain the typed `metadata`, `quality_flags`,
#'   and `completeness`: `"empty"`, `"incomplete"`, or `"unverified"`.
#'   Nonempty responses do not establish completeness. No cross-service
#'   geographic equivalence or administrative vintage is inferred.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' codes <- nso_classification(3446)
#' codes
#' attr(codes, "completeness")
#' attr(codes, "metadata")$version
#' @export
nso_classification <- function(id, include_raw = FALSE) {
  .nso_metadata_raw_option(include_raw)
  record <- nso_metadata("classification", id, include_raw = TRUE)
  codes <- record$raw$classificationCode %||% list()
  out <- tibble::tibble(
    source = character(),
    classification_id = character(),
    classification_key = character(),
    code = character(),
    definition = character(),
    parent_code = character(),
    version = character(),
    is_active = logical(),
    source_url = character()
  )
  for (entry in codes) {
    out <- dplyr::bind_rows(
      out,
      tibble::tibble(
        source = record$source,
        classification_id = record$id,
        classification_key = record$key,
        code = .nso_metadata_text(entry$code),
        definition = .nso_metadata_text(entry$definition %||% entry$name),
        parent_code = .nso_metadata_text(entry$parent_code),
        version = .nso_metadata_text(entry$version %||% record$version),
        is_active = .nso_metadata_logical(entry$is_active),
        source_url = record$url
      )
    )
  }
  completeness <- if (!length(codes)) "empty" else "unverified"
  if (anyNA(out$code) || anyDuplicated(out$code)) {
    completeness <- "incomplete"
    record$quality_flags <- dplyr::bind_rows(
      record$quality_flags,
      .nso_metadata_flag(
        "invalid_codes",
        "classificationCode",
        "The codebook contains missing or duplicate codes."
      )
    )
  }
  if (!include_raw) {
    record$raw <- NULL
  }
  attr(out, "metadata") <- record
  attr(out, "quality_flags") <- record$quality_flags
  attr(out, "completeness") <- completeness
  out
}

#' Retrieve official metadata category dictionaries
#'
#' @param dictionary One of `"collection-method"`, `"frequency"`,
#'   `"security-level"`, `"licence"`, or `"source"`.
#' @return A tibble of source-qualified category identifiers, character codes,
#'   and official text. The `source_url`, `retrieved_at`, and `coverage`
#'   attributes describe the returned catalogue. A licence or security
#'   category describes metadata and does not establish data availability.
#' @examplesIf identical(Sys.getenv("NOT_CRAN"), "true") && curl::has_internet()
#' nso_metadata_dictionary("frequency")
#' @export
nso_metadata_dictionary <- function(dictionary) {
  allowed <- c(
    "collection-method",
    "frequency",
    "security-level",
    "licence",
    "source"
  )
  if (
    !is.character(dictionary) ||
      length(dictionary) != 1L ||
      is.na(dictionary) ||
      !dictionary %in% allowed
  ) {
    cli::cli_abort("{.arg dictionary} must be one of: {.or {allowed}}.")
  }
  raw <- .nso_metadata_request(dictionary)
  if (!is.list(raw) || !is.null(names(raw))) {
    .nso_metadata_schema_error(
      "The dictionary response is not a list of categories."
    )
  }
  out <- .nso_metadata_refs()
  for (row in raw) {
    out <- dplyr::bind_rows(out, .nso_metadata_ref(row, dictionary))
  }
  out$url <- NULL
  attr(out, "source_url") <- .nso_service_url("metadata", dictionary)
  attr(out, "retrieved_at") <- Sys.time()
  attr(out, "coverage") <- "response_catalog"
  out
}

.nso_metadata_raw_option <- function(include_raw) {
  if (
    !is.logical(include_raw) || length(include_raw) != 1L || is.na(include_raw)
  ) {
    cli::cli_abort("{.arg include_raw} must be TRUE or FALSE.")
  }
  invisible(NULL)
}

.nso_metadata_request <- function(
  resource,
  id = NULL,
  query = list(),
  body = NULL
) {
  segments <- c(resource, id)
  .nso_service_json("metadata", segments, query = query, body = body)
}

.nso_metadata_type <- function(type, search = FALSE) {
  allowed <- c("database", "table", "indicator", "classification", "form")
  if (search) {
    allowed <- c(allowed, "all", "organization", "sector")
  }
  if (
    !is.character(type) ||
      length(type) != 1L ||
      is.na(type) ||
      !type %in% allowed
  ) {
    cli::cli_abort("{.arg type} must be one of: {.or {allowed}}.")
  }
  type
}

.nso_metadata_id <- function(id, arg = "id") {
  valid <- (is.numeric(id) || is.character(id)) &&
    length(id) == 1L &&
    !is.na(id) &&
    (is.numeric(id) || grepl("^[0-9]+$", id)) &&
    is.finite(suppressWarnings(as.numeric(id))) &&
    as.numeric(id) > 0 &&
    as.numeric(id) <= .Machine$integer.max &&
    as.numeric(id) == floor(as.numeric(id))
  if (!valid) {
    cli::cli_abort(
      "{.arg {arg}} must be a positive integer metadata identifier."
    )
  }
  as.character(as.integer(id))
}

.nso_metadata_schema_error <- function(message) {
  cli::cli_abort(message, class = "mongolstats_metadata_schema_error")
}

.nso_metadata_text <- function(value) {
  if (is.null(value) || length(value) != 1L || is.list(value) || is.na(value)) {
    return(NA_character_)
  }
  value <- if (is.numeric(value)) {
    format(value, scientific = FALSE, trim = TRUE)
  } else {
    as.character(value)
  }
  if (!nzchar(trimws(value))) NA_character_ else value
}

.nso_metadata_logical <- function(value) {
  if (is.logical(value) && length(value) == 1L) value else NA
}

.nso_metadata_refs <- function() {
  tibble::tibble(
    source = character(),
    type = character(),
    id = character(),
    key = character(),
    name_mn = character(),
    name_en = character(),
    code = character(),
    url = character()
  )
}

.nso_metadata_ref <- function(raw, type) {
  id <- .nso_metadata_text(raw$id)
  if (is.na(id) || !grepl("^[0-9]+$", id)) {
    .nso_metadata_schema_error("A metadata record has no numeric identifier.")
  }
  tibble::tibble(
    source = "metadata",
    type = type,
    id = id,
    key = paste("metadata", type, id, sep = ":"),
    name_mn = .nso_metadata_text(raw$name),
    name_en = .nso_metadata_text(raw$name_en),
    code = .nso_metadata_text(raw$code),
    url = paste0("https://metadata.nso.mn/", type, "/", id)
  )
}

.nso_metadata_hit <- function(hit) {
  raw <- hit$`_source`
  type <- .nso_metadata_text(raw$`_type`)
  if (
    is.na(type) ||
      !type %in% c("database", "table", "indicator", "classification", "form")
  ) {
    return(NULL)
  }
  prefix <- switch(type, database = "db", table = "tbl", type)
  raw$id <- raw[[paste0(prefix, "_id")]] %||% raw$id
  raw$name <- raw[[paste0(prefix, "_name")]] %||% raw$name
  raw$name_en <- raw[[paste0(prefix, "_name_en")]] %||% raw$name_en
  list(type = type, raw = raw)
}

.nso_metadata_flag <- function(
  code = character(),
  field = character(),
  message = character()
) {
  tibble::tibble(code = code, field = field, message = message)
}

.nso_metadata_context_category <- function(value, id = NULL) {
  category <- if (is.list(value)) value else list()
  list(
    id = id %||% category$id,
    name_mn = .nso_metadata_text(
      category$name %||% if (is.character(value)) value
    ),
    name_en = .nso_metadata_text(category$name_en),
    details = category
  )
}

.nso_metadata_context <- function(raw) {
  sources <- raw$source_id %||% raw$source %||% list()
  if (is.list(sources) && !is.null(sources$id)) {
    sources <- list(sources)
  }
  source_records <- lapply(sources, function(value) {
    if (is.list(value)) {
      .nso_metadata_context_category(value)
    } else {
      .nso_metadata_context_category(NULL, id = value)
    }
  })
  list(
    unit = .nso_metadata_context_category(raw$unit, raw$unit_id),
    value_type = .nso_metadata_context_category(
      raw$value_type,
      raw$value_type_id
    ),
    source = list(records = source_records, other = raw$source_other),
    dissemination = .nso_metadata_context_category(
      raw$dissemination_level %||% raw$dissimenation_level,
      raw$dissemination_level_id %||% raw$dissimenation_level_id
    ),
    owner_department = .nso_metadata_text(raw$owner_department)
  )
}

.nso_metadata_record <- function(raw, type, id, include_raw) {
  returned_id <- if (is.list(raw)) .nso_metadata_text(raw$id) else NA_character_
  if (is.na(returned_id) || !identical(returned_id, as.character(id))) {
    .nso_metadata_schema_error(
      "The metadata response does not match the requested identifier."
    )
  }
  reference <- .nso_metadata_ref(raw, type)
  flags <- .nso_metadata_flag()
  dates <- list()
  years <- list()
  date_fields <- raw[grep("(_date|_year)$", names(raw), value = TRUE)]
  for (field in names(date_fields)) {
    text <- .nso_metadata_text(raw[[field]])
    if (!is.na(text) && grepl("^[12][0-9]{3}$", text)) {
      years[[field]] <- as.integer(text)
      next
    }
    date <- as.Date(NA_character_)
    if (!is.na(text) && grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}($|T)", text)) {
      calendar <- substr(text, 1, 10)
      parsed <- suppressWarnings(as.Date(calendar, format = "%Y-%m-%d"))
      if (!is.na(parsed) && identical(format(parsed, "%Y-%m-%d"), calendar)) {
        date <- parsed
      }
    }
    dates[[field]] <- date
    if (is.na(date)) {
      code <- if (is.na(text)) "missing_date" else "invalid_date"
      flags <- dplyr::bind_rows(
        flags,
        .nso_metadata_flag(
          code,
          field,
          "The source field does not contain a valid calendar date or year."
        )
      )
    }
  }
  if (identical(raw$is_active, FALSE)) {
    flags <- dplyr::bind_rows(
      flags,
      .nso_metadata_flag(
        "inactive",
        "is_active",
        "The source marks this record inactive."
      )
    )
  }
  is_test <- grepl(
    "(^|[^a-z])(test|demo)([^a-z]|$)|\u0442\u0443\u0440\u0448\u0438\u043b\u0442",
    reference$name_mn,
    ignore.case = TRUE
  )
  if (isTRUE(is_test)) {
    flags <- dplyr::bind_rows(
      flags,
      .nso_metadata_flag(
        "test_record",
        "name",
        "The record name may identify a test or demonstration record."
      )
    )
  }
  classifications <- raw$indicators_classifications %||% list()
  definitions <- unlist(
    lapply(classifications, function(x) {
      lapply(x$classification$classificationCode, \(code) code$definition)
    }),
    use.names = FALSE
  )
  yes_no <- all(
    c("\u0422\u0438\u0439\u043c", "\u04ae\u0433\u04af\u0439") %in% definitions
  )
  currency <- .nso_metadata_text(raw$unit$name)
  if (
    yes_no &&
      !is.na(currency) &&
      grepl(
        "\u0442\u04e9\u0433\u0440\u04e9\u0433|currency|tugrik|mnt",
        currency,
        ignore.case = TRUE
      )
  ) {
    flags <- dplyr::bind_rows(
      flags,
      .nso_metadata_flag(
        "suspect_unit",
        "unit",
        "A yes/no classification is paired with a currency unit; verify the source."
      )
    )
  }
  if (type == "classification" && !length(raw$classificationCode)) {
    flags <- dplyr::bind_rows(
      flags,
      .nso_metadata_flag(
        "empty_codebook",
        "classificationCode",
        "The source returned no classification codes; completeness is unverified."
      )
    )
  }
  related <- .nso_metadata_relationships(raw)
  related <- related[related$key != reference$key, , drop = FALSE]
  out <- c(
    as.list(reference[1, ]),
    list(
      api_url = .nso_service_url("metadata", c(type, id)),
      retrieved_at = Sys.time(),
      description_mn = .nso_metadata_text(raw$description %||% raw$definition),
      description_en = .nso_metadata_text(
        raw$description_en %||% raw$definition_en
      ),
      version = .nso_metadata_text(raw$version),
      is_active = .nso_metadata_logical(raw$is_active),
      dates = dates,
      years = years,
      date_fields = date_fields,
      context = .nso_metadata_context(raw),
      methodology = raw[grep(
        "methodology|confirmed_|decree|collection_method|frequency|form_guide",
        names(raw)
      )],
      access = c(
        raw[intersect(
          c(
            "security_level",
            "security_level_id",
            "licenceType",
            "licence_type",
            "licence_type_other",
            "opendata_url",
            "files"
          ),
          names(raw)
        )],
        list(data_access_confirmed = FALSE)
      ),
      related = related,
      quality_flags = flags
    )
  )
  if (include_raw) {
    out$raw <- raw
  }
  structure(out, class = c("nso_metadata", "list"))
}

.nso_metadata_relationships <- function(raw) {
  out <- .nso_metadata_refs()
  visit <- function(value) {
    if (!is.list(value)) {
      return(invisible(NULL))
    }
    if (is.null(names(value))) {
      for (element in value) {
        visit(element)
      }
      return(invisible(NULL))
    }
    for (field in c("db_id", "tbl_id", "org_id")) {
      if (!is.null(value[[field]])) {
        type <- switch(
          field,
          db_id = "database",
          tbl_id = "table",
          org_id = "organization"
        )
        out <<- dplyr::bind_rows(
          out,
          .nso_metadata_ref(list(id = value[[field]]), type)
        )
      }
    }
    types <- c(
      database = "database",
      table = "table",
      organization = "organization",
      classification = "classification",
      form = "form",
      indicator = "indicator",
      tables = "table",
      forms = "form",
      indicators = "indicator"
    )
    for (field in intersect(names(value), names(types))) {
      item <- value[[field]]
      if (!is.list(item)) {
        next
      }
      if (
        field %in%
          c(
            "database",
            "table",
            "organization",
            "classification",
            "form",
            "indicator"
          )
      ) {
        foreign_key <- switch(
          field,
          database = "db_id",
          table = "tbl_id",
          organization = "org_id",
          paste0(field, "_id")
        )
        item$id <- item$id %||% value[[foreign_key]]
        items <- list(item)
      } else {
        items <- item
      }
      for (element in items) {
        if (is.list(element) && !is.null(element$id)) {
          out <<- dplyr::bind_rows(
            out,
            .nso_metadata_ref(element, types[[field]])
          )
        }
      }
    }
    for (field in intersect(
      names(value),
      c(names(types), "indicators_classifications")
    )) {
      visit(value[[field]])
    }
    invisible(NULL)
  }
  visit(raw)
  out <- out[order(is.na(out$name_mn)), , drop = FALSE]
  out[!duplicated(out$key), , drop = FALSE]
}
