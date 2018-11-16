
#' @name +.TelegramObject
#' @rdname TelegramObject-add
#' @aliases add
#' 
#' @title Add handlers to an updater
#'
#' @description With \code{+} you can add an object of type \code{Handler} to either
#'     an \code{\link{Updater}} or a \code{\link{Dispatcher}}.
#'
#' @param e1 An object of class \code{\link{Updater}} or  \code{\link{Dispatcher}}.
#' @param e2 An object of class \code{\link{Handler}}.
#' @examples \dontrun{
#' # You can chain multiple handlers
#' start <- function(bot, update){
#'   bot$sendMessage(chat_id = update$message$chat_id,
#'                   text = sprintf("Hello %s!",
#'                                  update$message$from$first_name))
#' }
#' echo <- function(bot, update){
#'   bot$sendMessage(chat_id = update$message$chat_id,
#'                   text = update$message$text)
#' }
#' 
#' updater <- Updater("TOKEN") + CommandHandler("start", start) +
#'   MessageHandler(echo, MessageFilters$text)
#'   
#' # And keep adding!
#' caps <- function(bot, update, args){
#'   text_caps <- toupper(paste(args, collapse = " "))
#'   bot$sendMessage(chat_id = update$message$chat_id,
#'                   text = text_caps)
#' }
#' 
#' updater <- updater + CommandHandler("caps", caps, pass_args = T)
#' 
#' # Give it a try
#' updater$start_polling()
#' # Send '/start' to the bot, '/caps foo' or just a simple text
#' }
#' @export
"+.TelegramObject" <- function(e1, e2) {
  if (missing(e2)) {
    stop("Cannot use `+.TelegramBot()` with a single argument. ",
         "Did you accidentally put + on a new line?",
         call. = FALSE)
  }
  
  if      (is.Updater(e1))  e1$dispatcher$add_handler(e2)
  else if (is.Dispatcher(e1)) dispatcher$add_handler(e2)
  else if (is.Handler(e1)) {
    stop("Cannot add 'Handler' objects together.",
         call. = FALSE)
  }
  
  e1
}

#' The base of telegram.bot objects
#'
#' Base class for most telegram objects.
#'
#' @docType class
#' @format An \code{\link{R6Class}} generator object.
#' @name TelegramObject
#' @aliases is.TelegramObject
#' @export
TelegramObject <- R6::R6Class("TelegramObject")

#' @rdname TelegramObject
#' @export
is.TelegramObject <- function(x){
  inherits(x, "TelegramObject")
}
