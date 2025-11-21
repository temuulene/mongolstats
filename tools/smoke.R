#!/usr/bin/env Rscript
options(warn = 1)
cat("SMOKE: starting mongolstats smoke test\n")

pkg_root <- normalizePath(".")
user_lib <- file.path(pkg_root, ".Rlib")
if (!dir.exists(user_lib)) {
  dir.create(user_lib, recursive = TRUE)
}
.libPaths(c(user_lib, .libPaths()))
cat("SMOKE: using lib =", .libPaths()[1], "\n")

need <- c(
  "httr2",
  "jsonlite",
  "tibble",
  "dplyr",
  "purrr",
  "stringr",
  "memoise",
  "cachem",
  "rappdirs",
  "stringi"
)
avail <- rownames(installed.packages(lib.loc = .libPaths()[1]))
miss <- setdiff(need, intersect(need, avail))
if (length(miss)) {
  cat("SMOKE: installing packages:", paste(miss, collapse = ", "), "\n")
  install.packages(
    miss,
    repos = "https://cloud.r-project.org",
    lib = .libPaths()[1],
    dependencies = TRUE
  )
}

invisible(lapply(
  list.files(file.path(pkg_root, "R"), full.names = TRUE),
  source
))
try(nso_cache_enable(), silent = TRUE)

try(
  {
    itms <- nso_itms()
    cat(
      "SMOKE: nso_itms() => rows=",
      nrow(itms),
      " cols=",
      ncol(itms),
      "\n",
      sep = ""
    )
  },
  silent = TRUE
)

try(
  {
    detail <- nso_itms_detail("DT_NSO_0300_001V2")
    cat(
      "SMOKE: nso_itms_detail(DT_NSO_0300_001V2) => fields=",
      paste(unique(detail$field), collapse = ","),
      " n=",
      nrow(detail),
      "\n",
      sep = ""
    )
  },
  silent = TRUE
)

try(
  {
    dat <- nso_data(
      tbl_id = "DT_NSO_0300_001V2",
      selections = list(Sex = "Total", Age = "Total", Year = "2024"),
      labels = "en"
    )
    rng <- suppressWarnings(range(dat$value, na.rm = TRUE))
    cat(
      "SMOKE: nso_data(labels='en') => rows=",
      nrow(dat),
      " value_min=",
      rng[1],
      " value_max=",
      rng[2],
      " has_any_label=",
      any(grepl('(_en|_mn)$', names(dat))),
      "\n",
      sep = ""
    )
  },
  silent = TRUE
)

if (requireNamespace("sf", quietly = TRUE)) {
  try(
    {
      g <- mn_boundaries("ADM1")
      epsg <- tryCatch(sf::st_crs(g)$epsg, error = function(e) NA)
      cat(
        "SMOKE: mn_boundaries(ADM1) => features=",
        nrow(g),
        " epsg=",
        epsg,
        "\n",
        sep = ""
      )
    },
    silent = TRUE
  )
} else {
  cat("SMOKE: skipping mn_boundaries() (sf not installed)\n")
}

cat("SMOKE: done\n")
