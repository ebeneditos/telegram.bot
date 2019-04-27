
context("Dispatcher")

dispatcher <- Dispatcher(Bot(token))
handler <- Handler(foo_handler)
update <- Update(foo_update)

test_that("Add Handler", {

  # check is.Dispatcher
  expect_true(is.Dispatcher(dispatcher))

  # wrong handler
  expect_error(
    dispatcher$add_handler(handler = "foo"),
    "`handler` must be an instance of `Handler`."
  )

  # wrong group type
  expect_error(
    dispatcher$add_handler(handler = handler, group = "foo"),
    "`group` must be numeric."
  )

  # wrong group number
  expect_error(
    dispatcher$add_handler(handler = handler, group = 0),
    "`group` must be higher or equal to 1."
  )

  # add handler
  expect_error(dispatcher$add_handler(handler = handler), NA)
})

test_that("Process Update", {
  expect_error(dispatcher$process_update(update), "Currently not implemented.")
})

test_that("Error Handler", {

  # not error handlers
  expect_warning(
    dispatcher$dispatch_error(foo_error),
    "No error handlers are registered."
  )

  # add error handler
  expect_error(dispatcher$add_handler(ErrorHandler(foo_handler)), NA)

  # process error
  expect_null(dispatcher$dispatch_error(foo_error))
})
