
#### METHODS ####

#' check_update
#'
#' This method is called to determine if an update should be handled by
#' this handler instance. It should always be overridden.
#' @param update The update to be tested.
check_update = function(update){
  not_implemented()
}

#' handle_update
#'
#' This method is called if it was determined that an update should indeed
#' be handled by this instance. It should also be overridden, but in most
#' cases call \code{self$callback(dispatcher$bot, update)}, possibly along with
#' optional arguments.
#' @param update The update to be handled.
#' @param dispatcher The dispatcher to collect optional args.
handle_update = function(update, dispatcher){
  self$callback(dispatcher$bot, update)
}


#### CLASS ####

#' Handler
#'
#' The base class for all update handlers. Create custom handlers by inheriting from it.
#'
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @section Methods: \describe{
#'     \item{\code{\link{check_update}}}{Called to determine if an update should be handled by
#' this handler instance.}
#'     \item{\code{\link{handle_update}}}{Called if it was determined that an update should indeed
#' be handled by this instance.}
#' }
#' @section Sub-classes: \describe{
#'     \item{\code{\link{MessageHandler}}}{To handle Telegram messages.}
#'     \item{\code{\link{CommandHandler}}}{To handle Telegram commands.}
#'     \item{\code{\link{CallbackQueryHandler}}}{To handle Telegram callback queries.}
#' }
#' @param callback The callback function for this handler. Its inputs will be \code{(bot, update)},
#'   where \code{bot} is a \code{\link{Bot}} instance and \code{update} an \code{\link{Update}} class.
#' @examples
#' # Example of a Handler
#' callback_method <- function(bot, update){
#'   chat_id <- update$message$chat$id
#'   bot$sendMessage(chat_id = chat_id, text = 'Hello')
#' }
#'
#' hello_handler <- Handler(callback_method)
#' @export
Handler <- function(callback){
  HandlerClass$new(callback)
}


HandlerClass <-
  R6::R6Class("Handler",
              public = list(

                ## args
                callback = NULL,

                ## methods
                check_update = check_update,
                handle_update = handle_update,
                
                ## initialize
                initialize =
                  function(callback){
                    self$callback <- callback
                    unlockBinding('check_update', environment(self$check_update)$self)
                    unlockBinding('handle_update', environment(self$handle_update)$self)
                  }
              )
)

