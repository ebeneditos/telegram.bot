
#### CLASS ####

#' Handling errors
#'
#' \code{\link{Handler}} class to handle errors in the
#' \code{\link{Dispatcher}}.
#'
#' @docType class
#' @format An \code{\link{R6Class}} object.
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
#' updater$dispatcher$add_handler(ErrorHandler(error_callback))
#' # or
#' updater <- updater + ErrorHandler(error_callback)
#' }
#' @export
ErrorHandler <- function(callback) {
  ErrorHandlerClass$new(callback)
}


ErrorHandlerClass <- R6::R6Class("ErrorHandler",
  inherit = HandlerClass,
  public = list(
    initialize = function(callback) {
      self$callback <- callback
    },

    # Params
    callback = NULL
  )
)

#' @rdname ErrorHandler
#' @param x Object to be tested.
#' @export
is.ErrorHandler <- function(x) {
  inherits(x, "ErrorHandler")
}
