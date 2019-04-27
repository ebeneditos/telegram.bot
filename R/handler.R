
#### METHODS ####

#' Check an update
#'
#' This method is called to determine if an update should be handled by
#' this handler instance. It should always be overridden (see
#' \code{\link{Handler}}).
#' @param update The update to be tested.
check_update <- function(update) {
  not_implemented()
}

#' Handle an update
#'
#' This method is called if it was determined that an update should indeed
#' be handled by this instance. It should also be overridden (see
#' \code{\link{Handler}}).
#'
#' In most cases \code{self$callback(dispatcher$bot, update)} can be called,
#' possibly along with optional arguments.
#' @param update The update to be handled.
#' @param dispatcher The dispatcher to collect optional arguments.
handle_update <- function(update,
                          dispatcher) {
  not_implemented()
}


#### CLASS ####

#' The base of all handlers
#'
#' The base class for all update handlers. Create custom handlers by inheriting
#' from it.
#'
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @name Handler
#' @aliases is.Handler
#' @section Methods: \describe{
#'     \item{\code{\link{check_update}}}{Called to determine if an update
#'       should be handled by this handler instance.}
#'     \item{\code{\link{handle_update}}}{Called if it was determined that an
#'       update should indeed be handled by this instance.}
#' }
#' @section Sub-classes: \describe{
#'     \item{\code{\link{MessageHandler}}}{To handle Telegram messages.}
#'     \item{\code{\link{CommandHandler}}}{To handle Telegram commands.}
#'     \item{\code{\link{CallbackQueryHandler}}}{To handle Telegram callback
#'       queries.}
#'     \item{\code{\link{ErrorHandler}}}{To handle errors while polling for
#'       updates.}
#' }
#' @param callback The callback function for this handler. Its inputs will be
#'     \code{(bot, update)},
#'     where \code{bot} is a \code{\link{Bot}} instance and \code{update} an
#'     \code{\link{Update}} class.
#' @param check_update Function that will override the default
#'     \code{\link{check_update}} method. Use it if you want to create your own
#'     \code{Handler}.
#' @param handle_update Function that will override the default
#'     \code{\link{handle_update}} method. Use it if you want to create your
#'     own \code{Handler}.
#' @param handlername Name of the customized class, which will inherit from
#'     \code{Handler}. If \code{NULL} (default) it will create a \code{Handler}
#'     class.
#' @examples
#' \dontrun{
#' # Example of a Handler
#' callback_method <- function(bot, update) {
#'   chat_id <- update$effective_chat()$id
#'   bot$sendMessage(chat_id = chat_id, text = "Hello")
#' }
#' 
#' hello_handler <- Handler(callback_method)
#' 
#' # Customizing Handler
#' check_update <- function(update) {
#'   TRUE
#' }
#' 
#' handle_update <- function(update, dispatcher) {
#'   self$callback(dispatcher$bot, update)
#' }
#' 
#' foo_handler <- Handler(callback_method,
#'   check_update = check_update,
#'   handle_update = handle_update,
#'   handlername = "FooHandler"
#' )
#' }
#' @export
Handler <- function(callback,
                    check_update = NULL,
                    handle_update = NULL,
                    handlername = NULL) {
  HandlerClassInherit <- R6::R6Class(
    classname = handlername,
    inherit = HandlerClass
  )

  if (!missing(check_update)) {
    HandlerClassInherit$set("public", "check_update",
      check_update,
      overwrite = TRUE
    )
  }

  if (!missing(handle_update)) {
    HandlerClassInherit$set("public", "handle_update",
      handle_update,
      overwrite = TRUE
    )
  }

  HandlerClassInherit$new(callback)
}


HandlerClass <- R6::R6Class("Handler",
  inherit = TelegramObject,
  public = list(
    initialize = function(callback) {
      self$callback <- callback
    },

    # Methods
    check_update = check_update,
    handle_update = handle_update,

    # Params
    callback = NULL
  )
)

#' @rdname Handler
#' @param x Object to be tested.
#' @export
is.Handler <- function(x) {
  inherits(x, "Handler")
}
