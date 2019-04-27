
context("Handler")

dispatcher <- Dispatcher(Bot(token))
handler <- Handler(foo_handler)
check_update <- function(update) {
  TRUE
}
handle_update <- function(update, dispatcher) {
  self$callback(dispatcher$bot, update)
}

test_that("Set Method", {
  expect_is(Handler(foo_handler, check_update, handle_update), "Handler")
  expect_is(
    Handler(foo_handler, check_update, handle_update, "FooHandler"),
    c("Handler", "FooHandler")
  )
})

test_that("Check Update", {
  expect_error(handler <- Handler(foo_handler, check_update), NA)
  expect_error(dispatcher$add_handler(handler = handler), NA)
  expect_error(dispatcher$process_update(update), "Currently not implemented.")
})

test_that("Handle Update", {
  dispatcher <- Dispatcher(Bot(token))

  expect_error(handler <- Handler(foo_handler, check_update, handle_update), NA)
  expect_error(dispatcher$add_handler(handler = handler), NA)
  expect_null(dispatcher$process_update(update))
})
