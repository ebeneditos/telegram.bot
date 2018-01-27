
context('CommandHandler')

dispatcher <- Dispatcher(Bot(token))
command_handler <- CommandHandler('foo', foo_handler, pass_args = TRUE)
update <- Update(foo_update)

test_that("Process Command", {
  
  expect_error(dispatcher$add_handler(handler = command_handler), NA)
  expect_null(dispatcher$process_update(update))
  
  # one filter
  command_handler$filters <- Filters$all
  expect_error(dispatcher$add_handler(handler = command_handler), NA)
  expect_null(dispatcher$process_update(update))
  
  # list of filters
  command_handler$filters <- list(Filters$text, Filters$command)
  expect_error(dispatcher$add_handler(handler = command_handler), NA)
  expect_null(dispatcher$process_update(update))
  
})
