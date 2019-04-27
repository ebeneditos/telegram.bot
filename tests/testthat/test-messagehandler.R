
context("MessageHandler")

dispatcher <- Dispatcher(Bot(token))
message_handler <- MessageHandler(foo_handler)
update <- Update(foo_update)

test_that("Process Message", {
  expect_error(dispatcher$add_handler(handler = message_handler), NA)

  # wrong update
  expect_null(dispatcher$process_update("foo"))

  # no filters
  expect_null(dispatcher$process_update(update))

  # one filter
  message_handler$filters <- MessageFilters$all
  expect_error(dispatcher$add_handler(handler = message_handler), NA)
  expect_null(dispatcher$process_update(update))

  # list of filters
  message_handler$filters <- list(MessageFilters$text, MessageFilters$command)
  expect_error(dispatcher$add_handler(handler = message_handler), NA)
  expect_null(dispatcher$process_update(update))
})
