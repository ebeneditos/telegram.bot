
self <- 'Only for R CMD check'
private <- 'Only for R CMD check'

not_implemented <- function() stop('Currently not implemented')

#### Export functions ####

#' bot_token
#'
#' Obtain token from system variables (in \code{Renviron}) set
#' according to the naming convention \code{R_TELEGRAM_BOT_X}
#' where \code{X} is the bot's name.
#'
#' @param bot_name The bot's name
#' @examples \dontrun{
#' bot_token('RBot')
#' }
#' @export
bot_token <- function(bot_name){
  Sys.getenv(paste0("R_TELEGRAM_BOT_", bot_name))
}

#' user_id
#'
#' Obtain Telegram user id from system variables (in \code{Renviron}) set
#' according to the naming convention \code{R_TELEGRAM_USER_X}
#' where \code{X} is the user's name.
#'
#' @param user_name The user's name
#' @examples \dontrun{
#' user_id('me')
#' }
#' @export
user_id <- function(user_name){
  Sys.getenv(paste0("R_TELEGRAM_USER_", user_name))
}


#### Auxiliar Functions ####

reply_markup_to_json <- function(reply_markup = NULL){
  if(is.null(reply_markup)) NULL
  else{
    if(!inherits(reply_markup, "ReplyMarkup")) stop("Incorrect Keyboard type.")
    jsonlite::toJSON(reply_markup, auto_unbox = T, force = T)
  }
}

check_stop <- function(error){
  return(attr(error, 'condition')$message == "Operation was aborted by an application callback")
}

method_summaries <- function(meth, indent = 0){
  wrap_at <- 72 - indent
  meth_string <- paste(meth, collapse = ", ")
  indent(strwrap(meth_string, width = wrap_at), indent)
}

indent <- function(str, indent = 0) {
  gsub("(^|\\n)(?!$)",
       paste0("\\1", paste(rep(" ", indent), collapse = "")),
       str,
       perl = TRUE
  )
}
