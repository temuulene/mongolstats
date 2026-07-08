test_that("nso_data works with valid table and selections", {
  skip_on_cran()
  skip_if_offline()

  result <- tryCatch(
    {
      nso_data(
        tbl_id = "DT_NSO_0300_001V2",
        selections = list(Sex = "Total", Age = "Total", Year = "2024"),
        labels = "none"
      )
    },
    error = function(e) NULL
  )

  expect_true(!is.null(result))
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) > 0)
  expect_true("value" %in% names(result))
})

test_that("nso_data works with label selections", {
  skip_on_cran()
  skip_if_offline()

  result <- tryCatch(
    {
      nso_data(
        tbl_id = "DT_NSO_0300_001V2",
        selections = list(Sex = "Total", Age = "Total", Year = "2024"),
        labels = "en"
      )
    },
    error = function(e) NULL
  )

  expect_true(!is.null(result))
  expect_s3_class(result, "tbl_df")
})

test_that("nso_data works with code selections", {
  skip_on_cran()
  skip_if_offline()

  result <- tryCatch(
    {
      nso_data(
        tbl_id = "DT_NSO_0300_001V2",
        selections = list(Sex = "0", Age = "0", Year = "0"),
        labels = "none"
      )
    },
    error = function(e) NULL
  )

  expect_true(!is.null(result))
  expect_s3_class(result, "tbl_df")
})

test_that("nso_data works with multiple values", {
  skip_on_cran()
  skip_if_offline()

  result <- tryCatch(
    {
      nso_data(
        tbl_id = "DT_NSO_0300_001V2",
        selections = list(
          Sex = c("Male", "Female"),
          Age = "Total",
          Year = "2024"
        ),
        labels = "en"
      )
    },
    error = function(e) NULL
  )

  expect_true(!is.null(result))
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) >= 2) # Should have at least Male and Female
})

test_that("nso_table_periods returns valid periods", {
  skip_on_cran()
  skip_if_offline()

  periods <- tryCatch(
    nso_table_periods("DT_NSO_0300_001V2"),
    error = function(e) NULL
  )

  expect_true(!is.null(periods))
  expect_true(is.character(periods))
  expect_true(length(periods) > 0)
  expect_true("2024" %in% periods)
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

  result <- tryCatch(nso_package(reqs, labels = "none"), error = function(e) {
    NULL
  })

  expect_true(!is.null(result))
  expect_s3_class(result, "tbl_df")
  expect_true("tbl_id" %in% names(result))
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
