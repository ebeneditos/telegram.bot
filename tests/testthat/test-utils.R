
context("Utils")

test_that("Not Implemented", {

  expect_error(not_implemented(), 'Currently not implemented')

})

test_that("Check Stop", {

  t <- try(stop('test'), silent = T)
  expect_false(check_stop(t))

})

test_that("Check File", {

  path_wrong <- 'test'
  path_right <- getwd()

  # wrong required
  expect_error(check_file(path_wrong, required = T), paste(path_wrong, 'is not a valid path'))

  # wrong not required
  expect_null(check_file(path_wrong))
  
  # right
  expect_equal(check_file(path_right), path_right)

})
