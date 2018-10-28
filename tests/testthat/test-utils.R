
context("Utils")

test_that("Not Implemented", {

  expect_error(not_implemented(), 'Currently not implemented.')

})

test_that("Check Stop", {

  t <- try(stop('test'), silent = T)
  expect_false(check_stop(t))

})

test_that("Reply Markup to JSON", {
  
  expect_null(reply_markup_to_json())
  expect_error(reply_markup_to_json(foo_text), 'Incorrect Keyboard type.')
  
})
