# Live integration tests against data.1212.mn. They run locally and on CI,
# never on CRAN. Errors are deliberately not caught: if the API breaks,
# the real error message should appear in test output.

test_that("nso_data works with valid table and selections", {
  skip_on_cran()
  skip_if_offline()

  result <- nso_data(
    tbl_id = "DT_NSO_0300_001V2",
    selections = list(Sex = "Total", Age = "Total", Year = "2024"),
    labels = "none"
  )

  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
  expect_true("value" %in% names(result))
  expect_type(result$value, "double")
})

test_that("nso_data works with label selections", {
  skip_on_cran()
  skip_if_offline()

  result <- nso_data(
    tbl_id = "DT_NSO_0300_001V2",
    selections = list(Sex = "Total", Age = "Total", Year = "2024"),
    labels = "en"
  )

  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
  # labels = "en" adds *_en columns for the dimensions
  expect_true(any(grepl("_en$", names(result))))
})

test_that("nso_data works with code selections", {
  skip_on_cran()
  skip_if_offline()

  result <- nso_data(
    tbl_id = "DT_NSO_0300_001V2",
    selections = list(Sex = "0", Age = "0", Year = "0"),
    labels = "none"
  )

  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

test_that("nso_data works with multiple values", {
  skip_on_cran()
  skip_if_offline()

  result <- nso_data(
    tbl_id = "DT_NSO_0300_001V2",
    selections = list(
      Sex = c("Male", "Female"),
      Age = "Total",
      Year = "2024"
    ),
    labels = "en"
  )

  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 2) # Should have at least Male and Female
})

test_that("nso_table_periods returns valid periods", {
  skip_on_cran()
  skip_if_offline()

  periods <- nso_table_periods("DT_NSO_0300_001V2")

  expect_named(periods, c("code", "label", "date", "frequency"))
  expect_gte(nrow(periods), 1)
  expect_true("2024" %in% periods$label)
  expect_false(is.unsorted(periods$date))
  expect_true(all(periods$frequency == "year"))
})

test_that("time dimensions come back as labels, not positional codes", {
  skip_on_cran()
  skip_if_offline()

  result <- nso_data(
    "DT_NSO_0300_001V2",
    selections = list(Sex = "Total", Age = "Total", Year = c("2023", "2024")),
    labels = "none"
  )
  expect_setequal(result$Year, c("2023", "2024"))
  # Other dimensions keep their codes
  expect_true(all(result$Sex == "0"))
})

test_that("nso_latest_periods() returns the newest period labels", {
  skip_on_cran()
  skip_if_offline()

  latest <- nso_latest_periods("DT_NSO_0300_001V2", n = 2)
  periods <- nso_table_periods("DT_NSO_0300_001V2")
  expect_equal(latest, utils::tail(periods$label, 2))
})

test_that("large selections are fetched in parts with the same result", {
  skip_on_cran()
  skip_if_offline()

  sel <- list(Sex = c("Male", "Female"), Year = c("2023", "2024"))
  whole <- nso_data("DT_NSO_0300_001V2", sel)
  withr::local_options(mongolstats.max_cells = 50)
  parts <- nso_data("DT_NSO_0300_001V2", sel)
  key <- c("Sex", "Age", "Year")
  expect_equal(
    dplyr::arrange(parts, dplyr::across(dplyr::all_of(key))),
    dplyr::arrange(whole, dplyr::across(dplyr::all_of(key)))
  )
})

test_that("a table that moved folder is found and the index updated", {
  skip_on_cran()
  skip_if_offline()

  # Pretend the index still lists the population table in a stale folder
  idx <- .px_index()
  withr::defer(.mongolstats_px_env$idx <- idx)
  stale <- idx
  hit <- stale$tbl_id == "DT_NSO_0300_001V2"
  stale$px_path[hit] <- "Population, household"
  .mongolstats_px_env$idx <- stale
  .mongolstats_px_env$missing <- NULL

  expect_message(dims <- nso_dims("DT_NSO_0300_001V2"), class = "mongolstats_table_moved")
  expect_true("Year" %in% dims$dim)
  expect_equal(.px_resolve_table("DT_NSO_0300_001V2")$row$px_path, idx$px_path[hit][1])
})

test_that("nso_package works with multiple tables", {
  skip_on_cran()
  skip_if_offline()

  reqs <- list(
    list(
      tbl_id = "DT_NSO_0300_001V2",
      selections = list(Sex = "Total", Age = "Total", Year = "2024")
    )
  )

  result <- nso_package(reqs, labels = "none")

  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
  expect_true("tbl_id" %in% names(result))
  expect_true(all(result$tbl_id == "DT_NSO_0300_001V2"))
})

test_that("label to code mapping works correctly", {
  skip_on_cran()
  skip_if_offline()

  tbl <- "DT_NSO_0300_001V2"

  # Resolve codes from live metadata rather than assuming positional codes
  # (codes shift when NSO adds a new period).
  code_for <- function(dim, label) {
    v <- nso_dim_values(tbl, dim, labels = "en")
    code <- v$code[!is.na(v$label_en) & v$label_en == label]
    if (length(code) != 1L) {
      skip(sprintf("no unique code for %s = '%s'", dim, label))
    }
    code
  }
  sex_code <- code_for("Sex", "Total")
  age_code <- code_for("Age", "Total")
  year_code <- code_for("Year", "2024")

  # Both should return the same data
  result_label <- nso_data(
    tbl_id = tbl,
    selections = list(Sex = "Total", Age = "Total", Year = "2024"),
    labels = "none"
  )

  result_code <- nso_data(
    tbl_id = tbl,
    selections = list(Sex = sex_code, Age = age_code, Year = year_code),
    labels = "none"
  )

  expect_s3_class(result_label, "tbl_df")
  expect_s3_class(result_code, "tbl_df")
  expect_equal(nrow(result_label), nrow(result_code))
  expect_equal(result_label$value, result_code$value)
})

test_that("mixed code and label selections return consistent data", {
  skip_on_cran()
  skip_if_offline()

  tbl <- "DT_NSO_0300_001V2"
  v <- nso_dim_values(tbl, "Sex", labels = "en")
  total_code <- v$code[!is.na(v$label_en) & v$label_en == "Total"]
  skip_if(length(total_code) != 1L, "no unique code for Sex = 'Total'")

  by_label <- nso_data(
    tbl_id = tbl,
    selections = list(Sex = "Total", Age = "Total", Year = "2024"),
    labels = "none"
  )
  by_mixed <- nso_data(
    tbl_id = tbl,
    selections = list(Sex = total_code, Age = "Total", Year = "2024"),
    labels = "none"
  )
  expect_equal(by_label$value, by_mixed$value)
})

test_that("nso_dims() marks the time dimension NSO leaves unflagged", {
  skip_on_cran()
  skip_if_offline()

  d <- nso_dims("DT_NSO_0300_001V2")
  expect_equal(d$dim[d$is_time], "Year")
})
