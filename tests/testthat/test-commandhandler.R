
context("CommandHandler")

dispatcher <- Dispatcher(Bot(token))
command_handler <- CommandHandler(
  "foo",
  foo_handler,
  pass_args = TRUE,
  username = "fooBot"
)
update <- Update(foo_update)

test_that("Process Command", {
  expect_error(dispatcher$add_handler(handler = command_handler), NA)
  expect_null(dispatcher$process_update(update))
  expect_null(dispatcher$process_update(Update(foo_command)))

  # one filter
  command_handler$filters <- MessageFilters$all
  expect_error(dispatcher$add_handler(handler = command_handler), NA)
  expect_null(dispatcher$process_update(update))

  # list of filters
  command_handler$filters <- list(MessageFilters$text, MessageFilters$command)
  expect_error(dispatcher$add_handler(handler = command_handler), NA)
  expect_null(dispatcher$process_update(update))
})
