
#### METHODS ####

#' Add a handler
#'
#' Register a handler. A handler must be an instance of a subclass of
#' \code{\link{Handler}}. All handlers are organized in groups with a numeric
#' value. The default group is 1. All groups will be evaluated for handling an
#' update, but only 0 or 1 handler per group will be used.
#'
#' You can use the \code{\link{add}} (\code{+}) operator instead.
#'
#' The priority/order of handlers is determined as follows:
#' \enumerate{
#'   \item{Priority of the group (lower group number = higher priority)}
#'   \item{The first handler in a group which should handle an update will be
#'     used. Other handlers from the group will not be used.
#'     The order in which handlers were added to the group defines the priority
#'     (the first handler added in a group has the highest priority).
#'   }
#' }
#' @param handler A \code{Handler} instance.
#' @param group The group identifier, must be higher or equal to 1.
#'     Default is 1.
add_handler <- function(handler,
                        group = 1L) {
  if (is.ErrorHandler(handler)) {
    self$add_error_handler(handler$callback)
    return(invisible(NULL))
  }
  if (!is.Handler(handler)) {
    stop("`handler` must be an instance of `Handler`.")
  }
  if (!is.numeric(group)) {
    stop("`group` must be numeric.")
  }

  group <- round(group[1L])
  if (group < 1L) {
    stop("`group` must be higher or equal to 1.")
  }

  if (group > length(private$groups) || is.null(private$handlers[[group]])) {
    private$handlers[[group]] <- list()
    private$groups <- sort(c(private$groups, group))
  }

  private$handlers[[group]] <- c(private$handlers[[group]], handler)

  invisible(NULL)
}


#' Add an error handler
#'
#' Registers an error handler in the \code{\link{Dispatcher}}.
#'
#' You can also use \code{\link{add_handler}} to register error handlers
#' if the handler is of type \code{\link{ErrorHandler}}.
#' @param callback A function that takes \code{(bot, error)} as arguments.
#' @examples
#' \dontrun{
#' updater <- Updater(token = "TOKEN")
#' 
#' # Create error callback
#' error_callback <- function(bot, error) {
#'   warning(simpleWarning(conditionMessage(error), call = "Updates polling"))
#' }
#' 
#' # Register it to the updater's dispatcher
#' updater$dispatcher$add_error_handler(error_callback)
#' # or
#' updater$dispatcher$add_handler(ErrorHandler(error_callback))
#' # or
#' updater <- updater + ErrorHandler(error_callback)
#' }
add_error_handler <- function(callback) {
  private$error_handlers <- c(private$error_handlers, callback)
  invisible(NULL)
}


#### CLASS ####

#' The dispatcher of all updates
#'
#' This class dispatches all kinds of updates to its registered handlers.
#'
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @name Dispatcher
#' @aliases is.Dispatcher
#' @param bot The bot object that should be passed to the handlers.
#' @section Methods: \describe{
#'     \item{\code{\link{add_handler}}}{Registers a handler in the
#'       \code{Dispatcher}.}
#'     \item{\code{\link{add_error_handler}}}{Registers an error handler in the
#'       \code{Dispatcher}.}
#' }
#' @export
Dispatcher <- function(bot) {
  DispatcherClass$new(bot)
}


DispatcherClass <- R6::R6Class("Dispatcher",
  inherit = TelegramObject,
  public = list(
    initialize = function(bot) {
      self$bot <- bot
    },

    # Methods
    add_handler = add_handler,
    add_error_handler = add_error_handler,

    # Methods

    # Processes a single update.
    process_update = function(update) {
      for (group in private$groups) {
        for (handler in private$handlers[[group]]) {
          if (handler$check_update(update)) {
            handler$handle_update(update, self)
            return(invisible(NULL))
          }
        }
      }
      invisible(NULL)
    },

    # Dispatches an error.
    dispatch_error = function(error) {
      if (length(private$error_handlers) > 0L) {
        for (callback in private$error_handlers) {
          callback(self$bot, error)
        }
      } else {
        warning("No error handlers are registered.")
      }
    },

    # Params
    bot = NULL
  ),
  private = list(
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

#' @rdname Dispatcher
#' @param x Object to be tested.
#' @export
is.Dispatcher <- function(x) {
  inherits(x, "Dispatcher")
}
