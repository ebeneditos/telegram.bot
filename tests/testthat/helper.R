
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
