
#' @name +.TelegramObject
#' @rdname TelegramObject-add
#' @aliases add
#'
#' @title Constructing an Updater
#'
#' @description With \code{+} you can add any kind of \code{\link{Handler}} to
#'     an \code{\link{Updater}}'s \code{Dispatcher} (or directly to a
#'     \code{\link{Dispatcher}}).
#'
#' @details See \code{\link{add_handler}} for further information.
#'
#' @param e1 An object of class \code{\link{Updater}} or
#'     \code{\link{Dispatcher}}.
#' @param e2 An object of class \code{\link{Handler}}.
#' @examples
#' \dontrun{
#' # You can chain multiple handlers
#' start <- function(bot, update) {
#'   bot$sendMessage(
#'     chat_id = update$message$chat_id,
#'     text = sprintf(
#'       "Hello %s!",
#'       update$message$from$first_name
#'     )
#'   )
#' }
#' echo <- function(bot, update) {
#'   bot$sendMessage(
#'     chat_id = update$message$chat_id,
#'     text = update$message$text
#'   )
#' }
#' 
#' updater <- Updater("TOKEN") + CommandHandler("start", start) +
#'   MessageHandler(echo, MessageFilters$text)
#' 
#' # And keep adding...
#' caps <- function(bot, update, args) {
#'   if (length(args > 0L)) {
#'     text_caps <- toupper(paste(args, collapse = " "))
#'     bot$sendMessage(
#'       chat_id = update$message$chat_id,
#'       text = text_caps
#'     )
#'   }
#' }
#' 
#' updater <- updater + CommandHandler("caps", caps, pass_args = TRUE)
#' 
#' # Give it a try!
#' updater$start_polling()
#' # Send '/start' to the bot, '/caps foo' or just a simple text
#' }
#' @export
"+.TelegramObject" <- function(e1, e2) { # nocov start
  if (missing(e2)) {
    stop( # nocov
      "Cannot use `+.TelegramBot()` with a single argument. ",
      "Did you accidentally put + on a new line?",
      call. = FALSE
    )
  } else if (!is.Handler(e2)) {
    stop(
      "The second argument from `+.TelegramBot()` ",
      "must be an instance of `Handler`.",
      call. = FALSE
    )
  }

  if (is.Updater(e1)) {
    e1$dispatcher$add_handler(e2)
  } else if (is.Dispatcher(e1)) {
    e1$add_handler(e2)
  } else if (is.Handler(e1)) {
    stop("Cannot add `Handler` objects together.",
      call. = FALSE
    )
  } else {
    stop(sprintf(
      "Cannot add `%s` and `%s` objects together.",
      class(e1), class(e2)
    ),
    call. = FALSE
    )
  }

  e1
} # nocov end

#' The base of telegram.bot objects
#'
#' Base class for most telegram objects.
#'
#' @docType class
#' @name TelegramObject
#' @aliases is.TelegramObject
#' @format An \code{\link{R6Class}} generator object.
#' @export
TelegramObject <- R6::R6Class("TelegramObject")

#' @rdname TelegramObject
#' @param x Object to be tested.
#' @export
is.TelegramObject <- function(x) {
  inherits(x, "TelegramObject")
}
