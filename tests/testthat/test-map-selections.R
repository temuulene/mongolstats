# Unit tests for .px_map_selections() — no network required.
# `vars` mimics meta$variables from jsonlite::fromJSON(simplifyVector = FALSE).

make_vars <- function() {
  list(
    list(
      code = "SEX",
      text = "Sex",
      values = list("0", "1", "2"),
      valueTexts = list("Total", "Male", "Female")
    ),
    list(
      code = "YEAR",
      text = "Year",
      time = TRUE,
      values = list("0", "1", "2"),
      valueTexts = list("2022", "2023", "2024")
    )
  )
}

test_that("labels map to codes", {
  res <- .px_map_selections(make_vars(), list(Sex = "Male", Year = "2024"))
  expect_equal(res$SEX, "1")
  expect_equal(res$YEAR, "2")
})

test_that("codes pass through unchanged and take priority over labels", {
  res <- .px_map_selections(make_vars(), list(Sex = "2"))
  expect_equal(res$SEX, "2")

  # A value valid as both code and label is treated as a code
  vars <- list(list(
    code = "X",
    text = "X",
    values = list("1", "2"),
    valueTexts = list("2", "1")
  ))
  res <- .px_map_selections(vars, list(X = "2"))
  expect_equal(res$X, "2")
})

test_that("codes and labels can be mixed in one vector", {
  res <- .px_map_selections(make_vars(), list(Sex = c("Total", "1")))
  expect_equal(res$SEX, c("0", "1"))
})

test_that("unselected dimensions get all codes", {
  res <- .px_map_selections(make_vars(), list(Year = "2024"))
  expect_equal(res$SEX, c("0", "1", "2"))
})

test_that("dimension names match case-insensitively, by name or code", {
  res <- .px_map_selections(make_vars(), list(year = "2024"))
  expect_equal(res$YEAR, "2")
  res <- .px_map_selections(make_vars(), list(YEAR = "2024"))
  expect_equal(res$YEAR, "2")
})

test_that("unknown dimension names error instead of fetching everything", {
  expect_error(
    .px_map_selections(make_vars(), list(Years = "2024")),
    class = "mongolstats_selection_error"
  )
  err <- tryCatch(
    .px_map_selections(make_vars(), list(Years = "2024")),
    error = function(e) e
  )
  expect_match(conditionMessage(err), "Years")
})

test_that("unknown values error and name the offending value, not NA", {
  err <- tryCatch(
    .px_map_selections(make_vars(), list(Sex = c("Total", "Man"))),
    error = function(e) e
  )
  expect_s3_class(err, "mongolstats_selection_error")
  expect_match(conditionMessage(err), "Man")
  expect_false(grepl("\\bNA\\b", conditionMessage(err)))
})

test_that("empty or NA selections error", {
  expect_error(
    .px_map_selections(make_vars(), list(Sex = character())),
    class = "mongolstats_selection_error"
  )
  expect_error(
    .px_map_selections(make_vars(), list(Sex = NA)),
    class = "mongolstats_selection_error"
  )
})

test_that("two selections targeting the same dimension error", {
  # "Year" matches by display name, "YEAR" would too; use code vs text
  vars <- list(list(
    code = "TIME",
    text = "Year",
    values = list("0"),
    valueTexts = list("2024")
  ))
  expect_error(
    .px_map_selections(vars, list(Year = "2024", TIME = "0")),
    class = "mongolstats_selection_error"
  )
})

test_that("duplicated labels warn and use the first matching code", {
  vars <- list(list(
    code = "REG",
    text = "Region",
    values = list("0", "1"),
    valueTexts = list("Total", "Total")
  ))
  expect_warning(
    res <- .px_map_selections(vars, list(Region = "Total")),
    "not unique"
  )
  expect_equal(res$REG, "0")
})

test_that("dimensions without explicit codes pass values through", {
  vars <- list(list(
    code = "FREE",
    text = "Free",
    values = list(),
    valueTexts = list()
  ))
  res <- .px_map_selections(vars, list(Free = "anything"))
  expect_equal(res$FREE, "anything")
})

test_that("check_selections rejects unnamed and duplicated names", {
  expect_error(
    check_selections(list("2024")),
    class = "mongolstats_selection_error"
  )
  expect_error(
    check_selections(list(Year = "2023", "2024")),
    class = "mongolstats_selection_error"
  )
  expect_error(
    check_selections(list(Year = "2023", year = "2024")),
    class = "mongolstats_selection_error"
  )
  expect_silent(check_selections(list()))
  expect_silent(check_selections(list(Year = c("2023", "2024"))))
})
