
context("BaseFilter")

test_that("Base Filter", {
  expect_true(is.BaseFilter(as.BaseFilter(function(...) TRUE)), "BaseFilter")
})

test_that("Filters Logic", {
  expect_is(!MessageFilters$command, "BaseFilter")
  expect_is(MessageFilters$text & MessageFilters$reply, "BaseFilter")
  expect_is(MessageFilters$audio | MessageFilters$video, "BaseFilter")
})
