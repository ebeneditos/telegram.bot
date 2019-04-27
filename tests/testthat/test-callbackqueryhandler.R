
context("CallbackQueryHandler")

dispatcher <- Dispatcher(Bot(token))
callbackquery_handler <- CallbackQueryHandler(foo_handler, pattern = ".")
update <- Update(foo_callbackquery)

test_that("Process CallbackQuery", {
  expect_error(dispatcher$add_handler(handler = callbackquery_handler), NA)
  expect_null(dispatcher$process_update(update))
})
