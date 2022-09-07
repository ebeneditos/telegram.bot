
context("Webhook")

webhook <- Webhook(
  webhook_url,
  bot = webhook_bot,
  verbose = TRUE
)

test_that("Initialize", {
  # No inputs
  expect_error(Webhook(NULL), "`webhook_url` must be passed.")
  expect_error(Webhook(""), "`webhook_url` must be passed.")

  # No token or bot
  expect_error(Webhook(webhook_url), "`token` or `bot` must be passed.")

  # Mutually exclusive
  expect_error(
    Webhook(webhook_url = webhook_url, token = token, bot = Bot(token)),
    "`token` and `bot` are mutually exclusive."
  )

  # Wrong bot
  expect_error(Webhook(webhook_url, bot = "bot"), "`bot` must be an instance of `Bot`.")

  # Initialize with bot
  expect_is(Webhook(webhook_url, bot = webhook_bot), "Webhook")

  # Initialize with token
  expect_is(webhook, "Webhook")

  # Check is.Webhook
  expect_true(is.Webhook(webhook))

  # Assigns dispatcher
  expect_true(!is.null(webhook$dispatcher))

  # Generates secret token
  expect_true(!is.null(webhook$secret_token))
})

test_that("Starts, Dispatches Messages and Stops", {

  port <- httpuv::randomPort()
  server_url <- sprintf("http://127.0.0.1:%d/webhook", port)

  # Wire up handlers

  ## Command
  commandUpdate <- NULL
  webhook$dispatcher$add_handler(
    CommandHandler("foo", function(bot, update) {
      commandUpdate <<- update
    })
  )

  ## Message
  messageUpdate <- NULL
  webhook$dispatcher$add_handler(
    MessageHandler(function(bot, update) {
      messageUpdate <<- update
    })
  )

  # Server running?
  expect_false(webhook$running())

  # Start server
  # NOTE: not (easily) able to test with blocking
  expect_true(webhook$start_server(port = port, blocking = FALSE))

  # Server running?
  expect_true(webhook$running())

  # Can't start server again
  expect_false(webhook$start_server())

  # POST command
  commandJson <- jsonlite::read_json("./updates/command.json")
  expect_true(webhook_post_update(server_url, commandJson, webhook$secret_token))
  expect_false(is.null(commandUpdate))

  # POST message
  messageJson <- jsonlite::read_json("./updates/message.json")
  expect_true(webhook_post_update(server_url, messageJson, webhook$secret_token))
  expect_false(is.null(messageUpdate))

  # Stop server
  expect_true(webhook$stop_server())

  # Server running?
  expect_false(webhook$running())
})
