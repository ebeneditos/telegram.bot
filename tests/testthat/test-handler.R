
context('Handler')

dispatcher <- Dispatcher(Bot(token))
handler <- Handler(foo_handler)

test_that("Check Update", {

  handler$check_update <- function(update){return(TRUE)}
  expect_error(dispatcher$add_handler(handler = handler), NA)
  expect_null(dispatcher$process_update(update))
  
})
