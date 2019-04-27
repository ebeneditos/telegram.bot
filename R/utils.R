
self <- "Only for R CMD check"
private <- "Only for R CMD check"

not_implemented <- function() stop("Currently not implemented.")

#### Export functions ####

#' Get a token from environment
#'
#' Obtain token from system variables (in \code{.Renviron}) set
#' according to the naming convention \code{R_TELEGRAM_BOT_X}
#' where \code{X} is the bot's name.
#'
#' @param bot_name The bot's name.
#' @examples
#' \dontrun{
#' # Open the `.Renviron` file
#' file.edit(path.expand(file.path("~", ".Renviron")))
#' # Add the line (uncomment and replace <bot-token> by your bot TOKEN):
#' # R_TELEGRAM_BOT_RTelegramBot=<bot-token>
#' # Save and restart R
#' 
#' bot_token("RTelegramBot")
#' }
#' @export
bot_token <- function(bot_name) {
  Sys.getenv(paste0("R_TELEGRAM_BOT_", bot_name)) # nocov
}

#' Get a user from environment
#'
#' Obtain Telegram user id from system variables (in \code{.Renviron}) set
#' according to the naming convention \code{R_TELEGRAM_USER_X}
#' where \code{X} is the user's name.
#'
#' @param user_name The user's name.
#' @examples
#' \dontrun{
#' # Open the `.Renviron` file
#' file.edit(path.expand(file.path("~", ".Renviron")))
#' # Add the line (uncomment and replace <user-id> by your Telegram user ID):
#' # R_TELEGRAM_USER_Me=<user-id>
#' # Save and restart R
#' 
#' user_id("Me")
#' }
#' @export
user_id <- function(user_name) {
  Sys.getenv(paste0("R_TELEGRAM_USER_", user_name)) # nocov
}


#### Auxiliar Functions ####

to_json <- function(x = NULL) {
  if (is.null(x)) {
    NULL
  } else {
    jsonlite::toJSON(x, auto_unbox = TRUE, force = TRUE) # nocov
  }
}

interruptError <- function() {
  "Operation was aborted by an application callback"
}

is.error <- function(x) {
  inherits(x, "error")
}

method_summaries <- function(meth,
                             indent = 0L) {
  wrap_at <- 72L - indent
  meth_string <- paste(meth, collapse = ", ")
  indent(strwrap(meth_string, width = wrap_at), indent)
}

indent <- function(str,
                   indent = 0L) {
  gsub("(^|\\n)(?!$)",
    paste0("\\1", paste(rep(" ", indent), collapse = "")),
    str,
    perl = TRUE
  )
}
