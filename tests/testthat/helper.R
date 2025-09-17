# You must define a valid TOKEN in Travis Environment Variables Settings
# NOTE: https://docs.travis-ci.com/user/environment-variables/#Defining-
#       Variables-in-Repository-Settings
token <- Sys.getenv("TOKEN")
chat_id <- Sys.getenv("CHAT_ID")

# Check if the token is valid, otherwise set a default token
# NOTE: This will skip the connection tests, as this token is not valid
res <- try(Bot(token = token))
if (inherits(res, "try-error") &&
  identical(conditionMessage(attr(res, "condition")), "Invalid token.")) {
  token <- "123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"
} else {
  # Ensure wehbook configuration is cleared
  res$delete_webhook()
}

# Skip if it is run offline or the bot request is not valid
skip_if_offline <- function(bot) {
  res <- try(bot$getMe())

  if (inherits(res, "try-error")) {
    skip(attr(res, "condition")$message)
  } else if (inherits(res, "response") && res$status_code != 200L) {
    skip("Bad request.")
  }
}

# Foo text
foo_text <- "foo"

# Handler function
foo_handler <- function(bot, update, ...) {
  return(update)
}

# Foo update
foo_update <- list(
  update_id = 0,
  message = list(
    from = list(id = 1),
    chat = list(id = 123456789),
    text = "/foo bar"
  )
)
foo_command <- list(
  update_id = 0,
  message = list(
    from = list(id = 1),
    chat = list(id = 123456789),
    text = "/foo"
  )
)
# Foo callbackquery
foo_callbackquery <- list(
  update_id = 1,
  callback_query = list(data = "foo")
)

# Foo error
foo_error <- simpleError("test error")

# Foo bot and foo updater
# NOTE: Only used for start_polling testing, as the bot features are tested in
#       other contexts
foo_bot <- structure(list(clean_updates = function(...) {}), class = "Bot")

foo_updater <- Updater(bot = foo_bot)

stop_handler <- function(...) {
  foo_updater$stop_polling()
}

# Webhook bot and associated helpers

webhook_url <- "https://example.com/webhook"

webhook_bot <- structure(
  list(
    set_webhook = function(...) {},
    delete_webhook = function(...) {}
  ),
  class = "Bot"
)

webhook_post_update <- function(url, data, secret_token) {
  handle <- curl::new_handle(
    customrequest = "POST",
    postfields = jsonlite::toJSON(data),
    verbose = FALSE # set to TRUE for debugging
  )
  curl::handle_setheaders(handle,
    "Content-Type" = "application/json",
    "X-Telegram-Bot-Api-Secret-Token" = secret_token
  )

  pool <- curl::new_pool()

  p <- promises::promise(function(resolve, reject) {
    curl::curl_fetch_multi(url, handle = handle, pool = pool, done = resolve, fail = reject)
  })

  finished <- FALSE
  poll <- function() {
    if (!finished) {
      curl::multi_run(timeout = 0, poll = TRUE, pool = pool)
      later::later(poll, 0.01)
    }
  }
  poll()

  promises::then(
    p,
    onFulfilled = function(value) {
      finished <<- TRUE
    },
    onRejected = function(error) {
      print(error)
    }
  )

  while (!later::loop_empty()) {
    later::run_now()
  }

  return(finished)
}
