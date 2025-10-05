test_that(".ms_to_chr coerces list or vector to character", {
  expect_equal(.ms_to_chr(list("a", "b"), 2), c("a","b"))
  expect_equal(.ms_to_chr(character(0), 3), rep(NA_character_, 3))
  expect_equal(.ms_to_chr(c(1,2), 2), c("1","2"))
})

