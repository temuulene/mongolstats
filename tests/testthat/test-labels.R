# .px_add_labels() attaches labels by dimension *code*, not display text:
# data columns carry the fetch-language text ("Sex") while both languages
# share the code ("Хүйс"), so mn labels must be routed through the code map.

fake_meta <- function(lang) {
  sex_texts <- if (lang == "en") list("Total", "Male") else list("Бүгд", "Эрэгтэй")
  year_texts <- list("2023", "2024")
  list(variables = list(
    list(
      code = "Хүйс",
      text = if (lang == "en") "Sex" else "Хүйс",
      values = list("0", "1"),
      valueTexts = sex_texts
    ),
    list(
      code = "Он",
      text = if (lang == "en") "Year" else "Он",
      values = list("21", "22"),
      valueTexts = year_texts
    )
  ))
}

with_fake_meta <- function() {
  testthat::local_mocked_bindings(
    .px_resolve_table = function(tbl_id, ...) {
      list(px_file = "T.px", row = NULL, paths = character())
    },
    .px_meta_cached = function(paths, table, lang = .px_lang()) fake_meta(lang),
    .package = "mongolstats",
    .env = parent.frame()
  )
}

test_that("labels = 'mn' attaches Mongolian labels to English-named columns", {
  with_fake_meta()
  df <- tibble::tibble(Sex = c("0", "1"), Year = c("21", "22"), value = c(1, 2))
  out <- .px_add_labels(df, "T", which = "mn")
  expect_equal(out$Sex_mn, c("Бүгд", "Эрэгтэй"))
  expect_equal(out$Year_mn, c("2023", "2024"))
  expect_false("Sex_en" %in% names(out))
})

test_that("labels = 'both' attaches both languages", {
  with_fake_meta()
  df <- tibble::tibble(Sex = c("1", "0"), value = c(1, 2))
  out <- .px_add_labels(df, "T", which = "both")
  expect_equal(out$Sex_en, c("Male", "Total"))
  expect_equal(out$Sex_mn, c("Эрэгтэй", "Бүгд"))
})

test_that("labels = 'en' works when data was fetched in Mongolian", {
  with_fake_meta()
  old <- options(mongolstats.lang = "mn")
  on.exit(options(old), add = TRUE)
  # With lang = "mn" the data columns carry the Mongolian display text
  df <- tibble::tibble(
    "Хүйс" = c("0", "1"),
    value = c(1, 2)
  )
  out <- .px_add_labels(df, "T", which = "en")
  expect_equal(out[["Хүйс_en"]], c("Total", "Male"))
})

test_that("mismatched code/label lengths are skipped, not an error", {
  testthat::local_mocked_bindings(
    .px_resolve_table = function(tbl_id, ...) {
      list(px_file = "T.px", row = NULL, paths = character())
    },
    .px_meta_cached = function(paths, table, lang = .px_lang()) {
      list(variables = list(list(
        code = "X",
        text = "X",
        values = list("0", "1"),
        valueTexts = list("only-one")
      )))
    },
    .package = "mongolstats"
  )
  df <- tibble::tibble(X = c("0", "1"), value = c(1, 2))
  out <- .px_add_labels(df, "T", which = "en")
  expect_identical(out, df)
})

test_that("labels = 'both' attaches mn labels with recorded metadata", {
  with_px_fixtures("px_meta", {
    # Codes "0" = Total in both languages for DT_NSO_0300_001V2
    df <- tibble::tibble(
      Sex = "0", Age = "0", Year = "1",
      value = 3448838
    )
    out <- .px_add_labels(df, "DT_NSO_0300_001V2", which = "both")
    expect_true(all(c("Sex_en", "Sex_mn", "Year_en", "Year_mn") %in% names(out)))
    expect_false(any(is.na(out$Sex_mn)))
    expect_equal(out$Sex_en, "Total")
  })
})

test_that("nso_itms_detail() joins Mongolian labels on the dimension code", {
  with_fake_meta()
  d <- nso_itms_detail("T")
  mn <- fake_meta("mn")$variables
  expect_equal(d$field, c("Sex", "Sex", "Year", "Year"))
  expect_equal(d$scr_mn, unlist(c(mn[[1]]$valueTexts, mn[[2]]$valueTexts)))
})
