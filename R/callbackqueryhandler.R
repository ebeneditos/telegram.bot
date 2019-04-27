
#### CLASS ####

#' Handling callback queries
#'
#' \code{\link{Handler}} class to handle Telegram callback queries. Optionally
#' based on a regex.
#'
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @param callback The callback function for this handler.
#'   See \code{\link{Handler}} for information about this function.
#' @param pattern (Optional). Regex pattern to test.
#' @export
CallbackQueryHandler <- function(callback,
                                 pattern = NULL) {
  CallbackQueryHandlerClass$new(callback, pattern)
}


CallbackQueryHandlerClass <- R6::R6Class("CallbackQueryHandler",
  inherit = HandlerClass,
  public = list(
    initialize = function(callback, pattern) {
      self$callback <- callback

      if (!missing(pattern)) {
        self$pattern <- pattern
      }
    },

    # Methods
    is_allowed_update = function(update) {
      !is.null(update$callback_query)
    },

    # This method is called to determine if an update should be handled by
    # this handler instance.
    check_update = function(update) {
      if (is.Update(update) && self$is_allowed_update(update)) {
        if (!is.null(self$pattern) && !is.null(update$callback_query$data)) {
          return(grepl(self$pattern, update$callback_query$data))
        } else {
          return(TRUE) # nocov
        }
      } else {
        return(FALSE) # nocov
      }
    },

    # This method is called if it was determined that an update should indeed
    # be handled by this instance.
    handle_update = function(update, dispatcher) {
      self$callback(dispatcher$bot, update)
    },

    # Params
    callback = NULL,
    pattern = NULL
  )
)
