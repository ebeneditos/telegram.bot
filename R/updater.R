
#### METHODS ####

#' start_polling
#'
#' Starts polling updates from Telegram. You can stop the polling either by using the the
#' \code{interrupt R} command in the session menu or with the \code{\link{stop_polling}}
#' method.
#' @param timeout (Optional). Passed to \code{\link{get_updates}}. Default is 10.
#' @param clean (Optional). Whether to clean any pending updates on Telegram servers
#'   before actually starting to poll. Default is \code{FALSE}.
#' @param allowed_updates (Optional). Passed to \code{\link{get_updates}}.
#' @param verbose (Optional). If \code{TRUE}, prints status of the polling. Default is \code{FALSE}.
#' @examples \dontrun{
#' # Start polling example
#' updater <- Updater(token = 'TOKEN')
#' 
#' updater$start_polling(verbose = TRUE)
#' }
start_polling <- function(timeout = 10, clean = FALSE, allowed_updates = NULL, verbose = FALSE){
  
  private$verbose <- verbose
  if (!private$running) private$running <- TRUE
  
  if (private$verbose) cat("Start polling\n")

  if (clean){
    if (private$verbose) cat("Cleaning updates from Telegram server\n")
    self$bot$clean_updates()
  }

  while (private$running){

    updates <- try(
      self$bot$get_updates(
          offset = private$last_update_id,
          timeout = timeout,
          allowed_updates = allowed_updates),
      silent = TRUE
    )

    if (inherits(updates, "try-error")){
      if (check_stop(updates)){
        self$stop_polling()
      }
      else{
        if (private$verbose) cat("Error while getting Updates\n")
        self$dispatcher$process_update(NULL)    
      }
    }
    
    else{

      if (!private$running){
        if (!is.null(updates) && length(updates) > 0)
          if (private$verbose) cat("Updates ignored and will be pulled again on restart.\n")
        break
      }
      
      if (length(updates)){

        for (update in updates){

          if (private$verbose) cat(sprintf("Processing Update: %i\n", update$update_id))
          self$dispatcher$process_update(update)
        }
        
        private$last_update_id <- updates[[length(updates)]]$update_id + 1
      }
    }
  }
}


#' stop_polling
#'
#' Stops the polling. Requires no parameters.
#' @examples \dontrun{
#' # Supperassign the updater
#' updater <<- Updater(token = 'TOKEN')
#' 
#' # Example of a 'kill' command
#' kill <- function(bot, update){
#'   bot$sendMessage(chat_id = update$message$chat_id,
#'                   text = "Bye!")
#'   # Clean 'kill' update
#'   bot$get_updates(offset = update$update_id + 1)
#'   # Stop the updater polling
#'   updater$stop_polling()
#' }
#' 
#' updater$dispatcher$add_handler(CommandHandler('kill', kill))
#' 
#' updater$start_polling(verbose = T) # Send '/kill' to the bot
#' }
stop_polling <- function(){
  
  if (private$verbose) cat("End polling\n")
  if (private$running) private$running <- FALSE
  
}


#### CLASS ####

#' Updater
#'
#' Package main class. This class, which employs the class \code{\link{Dispatcher}}, provides a front-end to
#' class \code{\link{Bot}} to the programmer, so they can focus on coding the bot. Its purpose is to
#' receive the updates from Telegram and to deliver them to said dispatcher. The
#' dispatcher supports \code{\link{Handler}} classes for different kinds of data: Updates from Telegram, basic text
#' commands and even arbitrary types.
#'
#' \strong{Note:} You \strong{must} supply either a \code{bot} or a \code{token} argument.
#' @format An \code{\link{R6Class}} object.
#' @param token (Optional). The bot's token given by the @BotFather.
#' @param bot (Optional). A pre-initialized \code{Bot} instance.
#' @section Methods: \describe{
#'     \item{\code{\link{start_polling}}}{Starts polling updates from Telegram.}
#'     \item{\code{\link{stop_polling}}}{Stops the polling.}
#' }
#' @references \href{http://core.telegram.org/bots}{Bots: An
#'     introduction for developers} and
#'     \href{http://core.telegram.org/bots/api}{Telegram Bot API}
#' @examples \dontrun{
#' updater <- Updater(token = 'TOKEN')
#' }
#' @export
Updater <- function(token = NULL, bot = NULL){
  UpdaterClass$new(token, bot)
}


UpdaterClass <-
  R6::R6Class("Updater",
              public = list(

                ## args
                bot = NULL,
                dispatcher = NULL,

                ## initialize
                initialize = function(token, bot){

                  if (is.null(token) & is.null(bot))
                    stop('`token` or `bot` must be passed')
                  if (!is.null(token) & !is.null(bot))
                    stop('`token` and `bot` are mutually exclusive')

                  if (!is.null(bot)){
                    if (inherits(bot, 'Bot'))
                      self$bot <- bot
                    else stop("`bot` must be of class 'Bot'")
                  }
                    
                  else
                    self$bot <- Bot(token)

                  self$dispatcher <- Dispatcher(self$bot)

                },

                ## methods
                start_polling = start_polling,
                stop_polling = stop_polling

              ),
              private = list(

                ## members
                last_update_id = 0,
                running = FALSE,
                verbose = FALSE

              )
)
