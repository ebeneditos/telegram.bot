
#### CLASS ####

#' Handling messages
#'
#' \code{\link{Handler}} class to handle Telegram messages. They might contain
#' text, media or status updates.
#'
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @param callback The callback function for this handler.
#'     See \code{\link{Handler}} for information about this function.
#' @param filters (Optional). Only allow updates with these filters. Use
#'     \code{NULL} (default) or \code{MessageFilters$all} for no filtering. See
#'     \code{\link{MessageFilters}} for a full list of all available filters.
#' @examples
#' \dontrun{
#' callback_method <- function(bot, update) {
#'   chat_id <- update$message$chat_id
#'   bot$sendMessage(chat_id = chat_id, text = "Hello")
#' }
#' 
#' # No filtering
#' message_handler <- MessageHandler(callback_method, MessageFilters$all)
#' }
#' @export
MessageHandler <- function(callback,
                           filters = NULL) {
  MessageHandlerClass$new(callback, filters)
}


MessageHandlerClass <- R6::R6Class("MessageHandler",
  inherit = HandlerClass,
  public = list(
    initialize = function(callback, filters) {
      self$callback <- callback
      self$filters <- filters
    },

    # Methods
    is_allowed_update = function(update) {
      any(
        !is.null(update$message),
        !is.null(update$channel_post)
      )
    },

    # This method is called to determine if an update should be handled by
    # this handler instance.
    check_update = function(update) {
      if (is.Update(update) && self$is_allowed_update(update)) {
        if (is.null(self$filters)) {
          res <- TRUE
        } else {
          message <- update$effective_message()

          if (inherits(self$filters, "list")) {
            res <- any(unlist(lapply(self$filters, function(func) {
              func(message)
            })))
          } else {
            res <- self$filters(message)
          }
        }
      } else {
        res <- FALSE
      }

      res
    },

    # This method is called if it was determined that an update should indeed
    # be handled by this instance.
    handle_update = function(update, dispatcher) {
      self$callback(dispatcher$bot, update)
    },

    # Params
    callback = NULL,
    filters = NULL
  )
)
