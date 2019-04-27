
context("Base")

test_that("Telegram Object", {
  expect_true(is.TelegramObject(TelegramObject$new()), "TelegramObject")
})
