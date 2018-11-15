
#' @name filtersLogic
#' 
#' @aliases !
#' @aliases &
#' @aliases |
#'
#' @title BaseFilter Logical Operators
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
#' not_command <- ! MessageFilters$command
#' @export
"!.BaseFilter" <- function(f) function(...) ! f(...)

#' @rdname filtersLogic
#' @examples
#' text_and_reply <- MessageFilters$text & MessageFilters$reply
#' @export
"&.BaseFilter" <- function(f, g) function(...) f(...) & g(...)

#' @rdname filtersLogic
#' @examples
#' audio_or_video <- MessageFilters$audio | MessageFilters$video
#' @export
"|.BaseFilter" <- function(f, g) function(...) f(...) | g(...)

#' BaseFilter
#'
#' Base class for all Message Filters.
#' 
#' See \code{\link{filtersLogic}} to know more about combining filter functions.
#' @name BaseFilter
#' @aliases as.BaseFilter
#' @aliases is.BaseFilter
#' @param filter If you want to create your own filters you can call this generator passing by
#'     a \code{filter} function that takes a \code{message} as input and returns a boolean:
#'     \code{TRUE} if the message should be handled, \code{FALSE} otherwise.
#' @examples \dontrun{
#' 
#' }
#' @export
BaseFilter <- function(filter){
  filter <- match.fun(filter)
  structure(filter, class = "BaseFilter")
}

#' @rdname BaseFilter
#' @export
as.BaseFilter <- function(x, ...){
  BaseFilter(x)
}

#' @rdname BaseFilter
#' @export
is.BaseFilter <- function(x){
  inherits(x, "BaseFilter")
}

