
#### CLASS ####

#' MessageHandler
#'
#' \code{\link{Handler}} class to handle Telegram messages. They might contain text, media or status updates.
#'
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @param filters Only allow updates with these Filters. Use \code{Filters$all}
#'   for no filtering. See \code{\link{Filters}} for a full list of all available filters.
#' @param callback The callback function for this handler.
#'   See \code{\link{Handler}} for information about this function.
#' @examples \dontrun{
#' # No filtering
#' message_handler <- MessageHandler(Filters$all, callback_method)
#' }
#' @export
MessageHandler <- function(filters, callback){
  MessageHandlerClass$new(filters, callback)
}


MessageHandlerClass <-
  R6::R6Class("MessageHandler",
              inherit = HandlerClass,
              public = list(

                ## args
                filters = NULL,
                callback = NULL,

                ## initialize
                initialize =
                  function(filters, callback){
                    self$filters <- filters
                    self$callback <- callback
                  },

                ## methods
                is_allowed_update = function(update){
                  any(!is.null(update$message),
                      !is.null(update$channel_post))
                },

                # This method is called to determine if an update should be handled by
                # this handler instance.
                check_update = function(update){

                  if (inherits(update, 'Update') && self$is_allowed_update(update)){

                    if(is.null(self$filters)){
                      res <- TRUE
                    }

                    else{
                      message <- update$effective_message()

                      if(inherits(self$filters, 'list')){
                        res <- any(unlist(lapply(self$filters, function(func) func(message))))
                      }

                      else{
                        res <-  self$filters(message)
                      }
                    }
                  }

                  else{
                    res <- FALSE
                  }

                  res
                },

                # This method is called if it was determined that an update should indeed
                # be handled by this instance.
                handle_update = function(update, dispatcher){
                  self$callback(dispatcher$bot, update)
                }
              )
)
