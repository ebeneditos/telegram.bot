
context('Filters')

message <- Update(foo_update)$message

test_that("Filter Message", {
  
  expect_true(Filters$all(message))
  
  expect_false(Filters$text(message))
  
  expect_true(Filters$command(message))
  
  expect_false(Filters$reply(message))
  
  expect_false(Filters$audio(message))
  
  expect_false(Filters$document(message))
  
  expect_false(Filters$photo(message))
  
  expect_false(Filters$sticker(message))
  
  expect_false(Filters$video(message))
  
  expect_false(Filters$voice(message))
  
  expect_false(Filters$contact(message))
  
  expect_false(Filters$location(message))
  
  expect_false(Filters$venue(message))
  
  expect_false(Filters$forwarded(message))
  
  expect_false(Filters$game(message))
  
  expect_false(Filters$invoice(message))
  
  expect_false(Filters$successful_payment(message))
  
})
