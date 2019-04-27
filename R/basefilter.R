
#' @name filtersLogic
#'
#' @aliases !
#' @aliases &
#' @aliases |
#'
#' @title Combining filters
#'
#' @description Creates a function which returns the corresponding logical
#'     operation between what \code{f} and \code{g} return.
#'
#' @details See \code{\link{BaseFilter}} and \code{\link{MessageFilters}} for
#'     further details.
#'
#' @param f,g Arbitrary \code{\link{BaseFilter}} class functions.
NULL

#' @rdname filtersLogic
#' @examples
#' not_command <- !MessageFilters$command
#' @export
"!.BaseFilter" <- function(f) BaseFilter(function(...) !f(...))

#' @rdname filtersLogic
#' @examples
#' text_and_reply <- MessageFilters$text & MessageFilters$reply
#' @export
"&.BaseFilter" <- function(f, g) BaseFilter(function(...) f(...) & g(...))

#' @rdname filtersLogic
#' @examples
#' audio_or_video <- MessageFilters$audio | MessageFilters$video
#' @export
"|.BaseFilter" <- function(f, g) BaseFilter(function(...) f(...) | g(...))

#' The base of all filters
#'
#' Base class for all Message Filters.
#'
#' See \code{\link{filtersLogic}} to know more about combining filter
#' functions.
#' @name BaseFilter
#' @aliases as.BaseFilter
#' @aliases is.BaseFilter
#' @param filter If you want to create your own filters you can call this
#'     generator passing by a \code{filter} function that takes a
#'     \code{message} as input and returns a boolean: \code{TRUE} if the
#'     message should be handled, \code{FALSE} otherwise.
#' @examples
#' \dontrun{
#' # Create a filter function
#' text_or_command <- function(message) !is.null(message$text)
#' 
#' # Make it an instance of BaseFilter with its generator:
#' text_or_command <- BaseFilter(filter = text_or_command)
#' 
#' # Or by coercing it with as.BaseFilter:
#' text_or_command <- as.BaseFilter(function(message) !is.null(message$text))
#' }
#' @export
BaseFilter <- function(filter) {
  filter <- match.fun(filter)
  structure(filter, class = "BaseFilter")
}

#' @rdname BaseFilter
#' @param x Object to be coerced or tested.
#' @param ... Further arguments passed to or from other methods.
#' @export
as.BaseFilter <- function(x, ...) {
  BaseFilter(x)
}

#' @rdname BaseFilter
#' @export
is.BaseFilter <- function(x) {
  inherits(x, "BaseFilter")
}
