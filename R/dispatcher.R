
#### METHODS ####

#' add_handler
#'
#' Register a handler. A handler must be an instance of a subclass of \code{\link{Handler}}. All handlers
#' are organized in groups with a numeric value. The default group is 1. All groups will be
#' evaluated for handling an update, but only 0 or 1 handler per group will be used.
#'
#' The priority/order of handlers is determined as follows:
#' \enumerate{
#'   \item{Priority of the group (lower group number = higher priority)}
#'   \item{The first handler in a group which should handle an update will be used. Other handlers from the group will not be used.
#'     The order in which handlers were added to the group defines the priority.
#'   }
#' }
#' @param handler A \code{Handler} instance.
#' @param group The group identifier, must be higher or equal to 1. Default is 1.
add_handler <- function(handler,
                        group = 1)
{

  if(!inherits(handler, 'Handler'))
    stop('handler is not an instance of Handler')
  if(!inherits(group, 'numeric'))
    stop('group is not numeric')
  
  group <- round(group[1])
  if (group < 1)
    stop('group must be higher or equal to 1')

  if (group > length(private$groups) || is.null(private$handlers[[group]])){
    private$handlers[[group]] <- list()
    private$groups <- sort(c(private$groups, group))
  }

  private$handlers[[group]] <- c(private$handlers[[group]], handler)

}


#' add_error_handler
#'
#' Registers an error handler in the \code{\link{Dispatcher}}.
#' @param callback A function that takes \code{(Bot, Update)} as arguments.
add_error_handler <- function(callback)
{

  private$error_handlers <- c(private$error_handlers, callback)

}


#### CLASS ####

#' Dispatcher
#'
#' This class dispatches all kinds of updates to its registered handlers.
#'
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @param bot The bot object that should be passed to the handlers.
#' @section Methods: \describe{
#'     \item{\code{\link{add_handler}}}{Registers a handler in the \code{Dispatcher}.}
#'     \item{\code{\link{add_error_handler}}}{Registers an error handler in the \code{Dispatcher}.}
#' }
#' @export
Dispatcher <- function(bot){
  DispatcherClass$new(bot)
}


DispatcherClass <-
  R6::R6Class("Dispatcher",
              public = list(

                ## args
                bot = NULL,

                ## initialize
                initialize =
                  function(bot){
                    self$bot <- bot
                  },

                ## methods
                add_handler = add_handler,
                add_error_handler = add_error_handler,

                ## functions

                # Processes a single update.
                process_update = function(update){

                  # An error happened while polling
                  if(is.null(update)){
                    res <- try(self$dispatch_error(update))
                    if(inherits(res, 'try-error')) warning('An uncaught error was raised while handling the error')
                    return()
                  }

                  for (group in private$groups){
                    
                    for (handler in private$handlers[[group]]){

                      if (handler$check_update(update)){
                        handler$handle_update(update, self)
                        break
                      }
                    }
                  }
                },

                # Dispatches an error.
                dispatch_error = function(update){

                  if (length(private$error_handlers) != 0)
                    for (callback in private$error_handlers){
                      callback(self$bot, update)
                    }

                  else warning('No error handlers are registered.')
                }
              ),
              private = list(

                ## members
                # A list handlers can use to store data for the user.
                user_data = list(),
                # A list handlers can use to store data for the chat.
                chat_data = list(),
                # Holds the handlers per group.
                handlers = list(),
                # A vector with all groups.
                groups = c(),
                # A vector of errorHandlers.
                error_handlers = list()
              )
  )
