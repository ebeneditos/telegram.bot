
context("Updater")

updater <- Updater(token = token)

test_that("Initialize", {

  # No inputs
  expect_error(Updater(), "`token` or `bot` must be passed.")

  # Mutually exclusive
  expect_error(
    Updater(token = token, bot = Bot(token)),
    "`token` and `bot` are mutually exclusive."
  )

  # Wrong bot
  expect_error(Updater(bot = "bot"), "`bot` must be an instance of `Bot`.")

  # Initialize with bot
  expect_is(Updater(bot = Bot(token)), "Updater")

  # Initialize with token
  expect_is(updater, "Updater")

  # Check is.Updater
  expect_true(is.Updater(updater))
})

test_that("Stop Polling", {
  expect_silent(updater$stop_polling())
})

test_that("Start Polling", {
  expect_error(foo_updater$dispatcher$add_error_handler(stop_handler), NA)

  # check error during get updates
  expect_null(foo_updater$start_polling(clean = TRUE, verbose = TRUE))

  # check stop
  foo_updater$bot$get_updates <- function(...) {
    stop(interruptError())
  }

  expect_null(foo_updater$start_polling(verbose = TRUE))

  # check warning when stopping polling
  foo_updater$bot$get_updates <- function(...) {
    foo_updater$stop_polling()
    return(list(Update(foo_update)))
  }

  expect_null(foo_updater$start_polling(verbose = TRUE))

  # check processing updates
  foo_updater$bot$get_updates <- function(...) {
    return(list(Update(foo_update)))
  }

  expect_error(foo_updater$dispatcher$add_handler(
    handler = CommandHandler("foo", stop_handler)
  ), NA)

  expect_null(foo_updater$start_polling(verbose = T))
})
