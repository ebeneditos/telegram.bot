
#' Filters
#'
#' Predefined filters for use as the \code{filter} argument of class \code{\link{MessageHandler}}.
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
#' @examples \dontrun{
#' # Use to filter all video messages
#' video_handler <- MessageHandler(Filters$video, callback_method)
#'
#' # To filter all contacts, etc.
#' contact_handler <- MessageHandler(Filters$contact, callback_method)
#' }
#' @export
Filters <- list(
  'all' =
    All <- function(message){
      TRUE
    },
  'text' =
    Text <- function(message){
      !is.null(message$text) && !startsWith(message$text, '/')
    },
  'command' =
    Command <- function(message){
      !is.null(message$text) && startsWith(message$text, '/')
    },
  'reply' =
    Reply <- function(message){
      !is.null(message$reply_to_message)
    },
  'audio' =
    Audio <- function(message){
      !is.null(message$audio)
    },
  'document' =
    Document <- function(message){
      !is.null(message$document)
    },
  'photo' =
    Photo <- function(message){
      !is.null(message$photo)
    },
  'sticker' =
    Sticker <- function(message){
      !is.null(message$sticker)
    },
  'video' =
    Video <- function(message){
      !is.null(message$video)
    },
  'voice' =
    Voice <- function(message){
      !is.null(message$voice)
    },
  'contact' =
    Contact <- function(message){
      !is.null(message$contact)
    },
  'location' =
    Location <- function(message){
      !is.null(message$location)
    },
  'venue' =
    Venue <- function(message){
      !is.null(message$venue)
    },
  'forwarded' =
    Forwarded <- function(message){
      !is.null(message$forward_date)
    },
  'game' =
    Game <- function(message){
      !is.null(message$game)
    },
  'invoice' =
    Game <- function(message){
      !is.null(message$invoice)
    },
  'successful_payment' =
    SuccessfulPayment <- function(message){
      !is.null(message$successful_payment)
    }
)
