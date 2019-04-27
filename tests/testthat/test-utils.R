
context("Utils")

test_that("Not Implemented", {
  expect_error(not_implemented(), "Currently not implemented.")
})

test_that("Reply Markup to JSON", {
  expect_null(to_json())
})
