
context("Updater")

updater <- Updater(token = token)

test_that("Initialize", {
  
  # No inputs
  expect_error(Updater(), '`token` or `bot` must be passed')
  
  # Mutually exclusive
  expect_error(Updater(token = token, bot = Bot(token)), '`token` and `bot` are mutually exclusive')
  
  # Initialize with bot
  expect_is(Updater(bot = Bot(token)), "Updater")
  
  # Initialize with token
  expect_is(updater, "Updater")
  
})

test_that("Stop Polling", {
  
  expect_silent(updater$stop_polling())
  
})
