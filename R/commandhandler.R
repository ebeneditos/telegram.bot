
#### CLASS ####

#' Handling commands
#'
#' \code{\link{Handler}} class to handle Telegram commands.
#'
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @param command The command or vector of commands this handler
#'   should listen for.
#' @param callback The callback function for this handler.
#'   See \code{\link{Handler}} for information about this function.
#' @param filters (Optional). Only allow updates with these filters. See
#'   \code{\link{MessageFilters}} for a full list of all available filters.
#' @param pass_args (Optional). Determines whether the handler should be passed
#'   \code{args}, received as a \code{vector}, split on spaces.
#' @param username (Optional). Bot's username, you can retrieve it from
#'   \code{bot$getMe()$username}. If this parameter is passed, then the
#'   \code{CommandHandler} will also listen to the command
#'   \code{/command@username}, as bot commands are often called this way.
#' @examples
#' \dontrun{
#' 
#' # Initialize bot
#' bot <- Bot("TOKEN")
#' username <- bot$getMe()$username
#' updater <- Updater(bot = bot)
#' 
#' # Add a command
#' start <- function(bot, update) {
#'   bot$sendMessage(
#'     chat_id = update$message$chat_id,
#'     text = "Hi, I am a bot!"
#'   )
#' }
#' 
#' updater <- updater + CommandHandler("start", start, username = username)
#' }
#' @export
CommandHandler <- function(command,
                           callback,
                           filters = NULL,
                           pass_args = FALSE,
                           username = NULL) {
  CommandHandlerClass$new(command, callback, filters, pass_args, username)
}


CommandHandlerClass <- R6::R6Class("CommandHandler",
  inherit = HandlerClass,
  public = list(
    initialize = function(command, callback, filters, pass_args, username) {
      command <- tolower(command)
      if (is.null(username)) {
        self$command <- command
      } else {
        self$command <- c(command, paste(
          command, tolower(username),
          sep = "@"
        ))
      }
      self$callback <- callback

      if (!missing(filters)) {
        self$filters <- filters
      }
      if (!missing(pass_args)) {
        self$pass_args <- pass_args
      }
    },

    # Methods
    is_allowed_update = function(update) {
      !is.null(update$message)
    },

    # This method is called to determine if an update should be handled by
    # this handler instance.
    check_update = function(update) {
      if (is.Update(update) && self$is_allowed_update(update)) {
        message <- update$message

        if (!is.null(message$text) && startsWith(message$text, "/")) {
          command <- strsplit(substring(message$text, 2L), " ")[[1L]]

          if (is.null(self$filters)) {
            res <- TRUE
          } else if (inherits(self$filters, "list")) {
            res <- any(unlist(lapply(self$filters, function(func) {
              func(message)
            })))
          } else {
            res <- self$filters(message)
          }

          return(res && (tolower(command[1L]) %in% self$command))
        } else {
          return(FALSE) # nocov
        }
      } else {
        return(FALSE) # nocov
      }
    },

    # This method is called if it was determined that an update should indeed
    # be handled by this instance.
    handle_update = function(update, dispatcher) {
      if (self$pass_args) {
        args <- strsplit(update$message$text, " ")[[1L]]
        if (length(args) < 2L) {
          args <- c()
        } else {
          args <- args[2L:length(args)]
        }
        self$callback(dispatcher$bot, update, args)
      } else {
        self$callback(dispatcher$bot, update)
      }
    },

    # Params
    command = NULL,
    callback = NULL,
    filters = NULL,
    pass_args = NULL,
    username = NULL
  )
)
