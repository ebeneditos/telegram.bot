
#' Filter message updates
#'
#' Predefined filters for use as the \code{filter} argument of class
#' \code{\link{MessageHandler}}.
#'
#' See \code{\link{BaseFilter}} and \code{\link{filtersLogic}} for
#' advanced filters.
#'
#' @docType data
#' @format A \code{list} with filtering functions.
#' @section Functions: \itemize{
#'     \item{\code{all}: All Messages.}
#'     \item{\code{text}: Text Messages.}
#'     \item{\code{command}: Messages starting with \code{/}.}
#'     \item{\code{reply}: Messages that are a reply to another message.}
#'     \item{\code{audio}: Messages that contain audio.}
#'     \item{\code{document}: Messages that contain document.}
#'     \item{\code{photo}: Messages that contain photo.}
#'     \item{\code{sticker}: Messages that contain sticker.}
#'     \item{\code{video}: Messages that contain video.}
#'     \item{\code{voice}: Messages that contain voice.}
#'     \item{\code{contact}: Messages that contain contact.}
#'     \item{\code{location}: Messages that contain location.}
#'     \item{\code{venue}: Messages that are forwarded.}
#'     \item{\code{game}: Messages that contain game.}
#' }
#' @examples
#' \dontrun{
#' # Use to filter all video messages
#' video_handler <- MessageHandler(callback_method, MessageFilters$video)
#' 
#' # To filter all contacts, etc.
#' contact_handler <- MessageHandler(callback_method, MessageFilters$contact)
#' }
#' @export
MessageFilters <- list(
  "all" = BaseFilter(function(message) TRUE),
  "text" = BaseFilter(function(message) {
    !is.null(message$text) && !startsWith(message$text, "/")
  }),
  "command" = BaseFilter(function(message) {
    !is.null(message$text) && startsWith(message$text, "/")
  }),
  "reply" = BaseFilter(function(message) !is.null(message$reply_to_message)),
  "audio" = BaseFilter(function(message) !is.null(message$audio)),
  "document" = BaseFilter(function(message) !is.null(message$document)),
  "photo" = BaseFilter(function(message) !is.null(message$photo)),
  "sticker" = BaseFilter(function(message) !is.null(message$sticker)),
  "video" = BaseFilter(function(message) !is.null(message$video)),
  "voice" = BaseFilter(function(message) !is.null(message$voice)),
  "contact" = BaseFilter(function(message) !is.null(message$contact)),
  "location" = BaseFilter(function(message) !is.null(message$location)),
  "venue" = BaseFilter(function(message) !is.null(message$venue)),
  "forwarded" = BaseFilter(function(message) !is.null(message$forward_date)),
  "game" = BaseFilter(function(message) !is.null(message$game)),
  "invoice" = BaseFilter(function(message) !is.null(message$invoice)),
  "successful_payment" = BaseFilter(function(message) {
    !is.null(message$successful_payment)
  })
)
