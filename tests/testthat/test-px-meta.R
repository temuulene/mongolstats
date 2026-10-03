# Discovery functions treat offline mode as "no results" but must surface
# genuine request failures instead of returning an empty result.

local_meta_failure <- function(class, env = parent.frame()) {
  testthat::local_mocked_bindings(
    .px_resolve_table = function(tbl_id, ...) {
      list(px_file = "T.px", row = tibble::tibble(px_path = "", px_file = "T.px"), paths = character())
    },
    .px_meta_cached = function(...) cli::cli_abort("request failed", class = class),
    .package = "mongolstats",
    .env = env
  )
}

test_that("discovery functions return empty results in offline mode", {
  local_meta_failure("mongolstats_offline_error")
  expect_equal(nrow(nso_dims("T")), 0)
  expect_equal(nrow(nso_dim_values("T", "Year")), 0)
  expect_equal(nrow(nso_table_meta("T")), 0)
  expect_equal(nrow(nso_itms_detail("T")), 0)
  expect_equal(nrow(nso_table_periods("T")), 0)
  expect_identical(nso_latest_periods("T"), character())
})

test_that("discovery functions surface HTTP errors", {
  local_meta_failure("mongolstats_http_error")
  expect_error(nso_dims("T"), class = "mongolstats_http_error")
  expect_error(nso_dim_values("T", "Year"), class = "mongolstats_http_error")
  expect_error(nso_table_meta("T"), class = "mongolstats_http_error")
  expect_error(nso_itms_detail("T"), class = "mongolstats_http_error")
  expect_error(nso_table_periods("T"), class = "mongolstats_http_error")
})

test_that("catalogue navigation surfaces HTTP errors", {
  local_mocked_bindings(
    .px_list_cached = function(...) {
      cli::cli_abort("request failed", class = "mongolstats_http_error")
    }
  )
  expect_error(nso_sectors(), class = "mongolstats_http_error")
  expect_error(nso_subsectors("Population"), class = "mongolstats_http_error")
})

test_that("catalogue crawl warns when parts of the catalogue fail", {
  local_mocked_bindings(
    .px_list_cached = function(paths = character(), lang = "en") {
      if (!length(paths)) {
        data.frame(id = c("A", "B"), type = "l", text = c("A", "B"))
      } else if (identical(paths, "A")) {
        cli::cli_abort("request failed", class = "mongolstats_http_error")
      } else {
        data.frame(id = "T1.px", type = "t", text = "Table 1")
      }
    },
    .px_meta_cached = function(...) list(title = "Table 1", variables = list())
  )
  expect_snapshot(idx <- nso_px_tables())
  expect_equal(idx$tbl_id, "T1")
})

test_that("catalogue crawl stops in offline mode", {
  nso_offline_enable()
  on.exit(nso_offline_disable(), add = TRUE)
  expect_error(nso_px_tables(), class = "mongolstats_offline_error")
})

# Offline success paths against a small fake table ---------------------

fake_table_meta <- function(lang) {
  mn <- lang == "mn"
  list(variables = list(
    list(
      code = "SEX", text = if (mn) "Хүйс" else "Sex",
      values = list("0", "1"),
      valueTexts = if (mn) list("Бүгд", "Эр") else list("Total", "Male")
    ),
    list(
      code = "YEAR", text = if (mn) "Он" else "Year", time = TRUE,
      values = list("0", "1"), valueTexts = list("2023", "2024")
    ),
    list(
      code = "AGEGRP", text = if (mn) "Нас" else "Age group",
      values = list("0"), valueTexts = list("Total")
    )
  ))
}

local_fake_table <- function(env = parent.frame()) {
  testthat::local_mocked_bindings(
    .px_resolve_table = function(tbl_id, ...) {
      list(px_file = "T.px", row = tibble::tibble(px_path = "p", px_file = "T.px"), paths = "p")
    },
    .px_meta_cached = function(paths, table, lang = .px_lang()) fake_table_meta(lang),
    .package = "mongolstats",
    .env = env
  )
}

test_that("nso_dims() lists every dimension", {
  local_fake_table()
  d <- nso_dims("T")
  expect_equal(d$dim, c("Sex", "Year", "Age group"))
  expect_equal(d$code, c("SEX", "YEAR", "AGEGRP"))
  expect_equal(d$is_time, c(FALSE, TRUE, FALSE))
  expect_equal(d$n_values, c(2L, 2L, 1L))
})

test_that("nso_dim_values() matches dimensions by code, name, or unique partial name", {
  local_fake_table()
  expect_equal(nso_dim_values("T", "SEX")$code, c("0", "1"))
  expect_equal(nso_dim_values("T", "year", labels = "en")$label_en, c("2023", "2024"))
  expect_equal(nso_dim_values("T", "age")$code, "0")
  both <- nso_dim_values("T", "Sex", labels = "both")
  expect_named(both, c("code", "label_en", "label_mn"))
  expect_equal(both$label_mn, c("Бүгд", "Эр"))
  expect_equal(nso_dim_values("T", "Sex", labels = "none"), nso_dim_values("T", "Sex"))
})

test_that("nso_dim_values() explains unknown and ambiguous dimensions", {
  local_fake_table()
  expect_snapshot(nso_dim_values("T", "Region"), error = TRUE)
  expect_snapshot(nso_dim_values("T", "e"), error = TRUE)
  expect_snapshot(nso_dim_values("T", c("Sex", "Year")), error = TRUE)
})

test_that("nso_table_meta() returns per-dimension codebooks in both languages", {
  local_fake_table()
  meta <- nso_table_meta("T")
  expect_equal(meta$dim, c("Sex", "Year", "Age group"))
  expect_equal(meta$n_values, c(2L, 2L, 1L))
  sex <- meta$codes[[1]]
  expect_equal(sex$label_en, c("Total", "Male"))
  expect_equal(sex$label_mn, c("Бүгд", "Эр"))
})

test_that("nso_table_periods() lists the time dimension's periods", {
  local_fake_table()
  p <- nso_table_periods("T")
  expect_equal(p$label, c("2023", "2024"))
  expect_equal(p$code, c("0", "1"))
  expect_equal(p$date, as.Date(c("2023-01-01", "2024-01-01")))
  expect_equal(nso_latest_periods("T"), "2024")
  expect_equal(nso_latest_periods("T", n = 5), c("2023", "2024"))
  expect_snapshot(nso_latest_periods("T", n = 0), error = TRUE)
})

test_that(".px_periods() sorts newest-first catalogues oldest first", {
  vars <- list(list(
    code = "Month", text = "Month",
    values = list("0", "1", "2"),
    valueTexts = list("2026-03", "2026-02", "2026-01")
  ))
  p <- .px_periods(vars)
  expect_equal(p$label, c("2026-01", "2026-02", "2026-03"))
  expect_equal(p$code, c("2", "1", "0"))
  expect_equal(.px_period_range(vars), c("2026-01", "2026-03"))
  expect_equal(.px_period_range(list()), c(NA_character_, NA_character_))
})

test_that("nso_latest_periods() errors for a table without a time dimension", {
  local_mocked_bindings(
    .px_resolve_table = function(tbl_id, ...) {
      list(px_file = "T.px", row = tibble::tibble(px_path = "", px_file = "T.px"), paths = character())
    },
    .px_meta_cached = function(...) {
      list(variables = list(list(code = "S", text = "Sex", values = list("0"), valueTexts = list("Total"))))
    }
  )
  expect_snapshot(nso_latest_periods("T"), error = TRUE)
})

test_that("nso_subsectors() splits a path id into PXWeb path segments", {
  seen <- NULL
  local_mocked_bindings(
    .px_list_cached = function(paths = character(), lang = "en") {
      seen <<- paths
      data.frame(id = "x", type = "t", text = "X")
    }
  )
  expect_equal(nrow(nso_subsectors("Population, household/1_Population")), 1)
  expect_equal(seen, c("Population, household", "1_Population"))
  nso_subsectors("")
  expect_equal(seen, character())
  expect_snapshot(nso_subsectors(c("a", "b")), error = TRUE)
})
