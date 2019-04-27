
context("MessageFilters")

message <- Update(foo_update)$message

test_that("Filter Message", {
  expect_true(MessageFilters$all(message))

  expect_false(MessageFilters$text(message))

  expect_true(MessageFilters$command(message))

  expect_false(MessageFilters$reply(message))

  expect_false(MessageFilters$audio(message))

  expect_false(MessageFilters$document(message))

  expect_false(MessageFilters$photo(message))

  expect_false(MessageFilters$sticker(message))

  expect_false(MessageFilters$video(message))

  expect_false(MessageFilters$voice(message))

  expect_false(MessageFilters$contact(message))

  expect_false(MessageFilters$location(message))

  expect_false(MessageFilters$venue(message))

  expect_false(MessageFilters$forwarded(message))

  expect_false(MessageFilters$game(message))

  expect_false(MessageFilters$invoice(message))

  expect_false(MessageFilters$successful_payment(message))
})
