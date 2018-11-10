
#### CLASS ####

#' CommandHandler
#'
#' \code{\link{Handler}} class to handle Telegram commands.
#'
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @param command The command or list of commands this handler
#'   should listen for.
#' @param callback The callback function for this handler.
#'   See \code{\link{Handler}} for information about this function.
#' @param filters (Optional). Only allow updates with these filters. See
#'   \code{\link{Filters}} for a full list of all available filters.
#' @param pass_args (Optional). Determines whether the handler should be passed
#'   \code{args}, received as a \code{vector}, split on spaces.
#' @export
CommandHandler <- function(command, callback, filters = NULL, pass_args = FALSE){
  CommandHandlerClass$new(command, callback, filters, pass_args)
}


CommandHandlerClass <-
  R6::R6Class("CommandHandler",
              inherit = HandlerClass,
              public = list(

                ## args
                command = NULL,
                callback = NULL,
                filters = NULL,
                pass_args = NULL,

                ## initialize
                initialize =
                  function(command, callback, filters, pass_args){
                    self$command <- tolower(command)
                    self$callback <- callback

                    if (!missing(filters))
                      self$filters <- filters
                    if (!missing(pass_args))
                      self$pass_args <- pass_args
                  },

                ## methods
                is_allowed_update = function(update){
                  !is.null(update$message)
                },

                # This method is called to determine if an update should be handled by
                # this handler instance.
                check_update = function(update){

                  if (inherits(update, 'Update') && self$is_allowed_update(update)){

                    message <- update$message

                    if (!is.null(message$text) && startsWith(message$text, '/')){
                      command <- strsplit(substring(message$text, 2), ' ')[[1]]

                      if(is.null(self$filters)){
                        res <- TRUE
                      }

                      else if(inherits(self$filters, 'list')){
                        res <- any(unlist(lapply(self$filters, function(func) func(message))))
                      }

                      else{
                        res <-  self$filters(message)
                      }
                      
                      return(res && (tolower(command[1]) %in% self$command))
                    }

                    else return(FALSE) # nocov
                  }

                  else return(FALSE) # nocov
                },

                # This method is called if it was determined that an update should indeed
                # be handled by this instance.
                handle_update = function(update, dispatcher){
                  
                  if (self$pass_args){
                    optional_args <- strsplit(update$message$text, ' ')[[1]]
                    self$callback(dispatcher$bot, update, optional_args[2:length(optional_args)])
                  }
                  else
                    self$callback(dispatcher$bot, update)
                }
              )
  )
