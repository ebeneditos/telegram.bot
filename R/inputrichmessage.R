#' Create an input rich message
#'
#' Describes a rich message to be sent. Exactly one of \code{blocks}, \code{html},
#' or \code{markdown} must be used.
#'
#' @param blocks (Optional). List of \code{\link{InputRichBlock}} objects describing
#'     the content of the rich message to send
#' @param html (Optional). Content of the rich message described using HTML formatting
#' @param markdown (Optional). Content of the rich message described using Markdown
#'     formatting
#' @param media (Optional). List of \code{\link{InputRichMessageMedia}} objects
#' @param is_rtl (Optional). TRUE if the rich message must be shown right-to-left
#' @param skip_entity_detection (Optional). TRUE to skip automatic detection of
#'     entities
#' @export
InputRichMessage <- function(blocks = NULL,
                             html = NULL,
                             markdown = NULL,
                             media = NULL,
                             is_rtl = NULL,
                             skip_entity_detection = NULL) {
  InputRichMessage <- list(
    blocks = blocks,
    html = html,
    markdown = markdown,
    media = media,
    is_rtl = is_rtl,
    skip_entity_detection = skip_entity_detection
  )
  InputRichMessage <- InputRichMessage[!unlist(lapply(InputRichMessage, is.null))]

  structure(InputRichMessage, class = "InputRichMessage")
}

#' @rdname InputRichMessage
#' @param x Object to be tested
#' @export
is.InputRichMessage <- function(x) inherits(x, "InputRichMessage")


#' Create an input rich message media
#'
#' Describes a media element embedded in an outgoing rich message.
#'
#' @param id Unique identifier of the media used in a `tg://photo?id=`,
#'     `tg://video?id=`, `tg://document?id=`, or `tg://audio?id=` link. 1-64 characters,
#'     only A-Z, a-z, 0-9, _ and - are allowed
#' @param media The media to be sent
#' @export
InputRichMessageMedia <- function(id, media) {
  structure(list(
    id = id,
    media = media
  ), class = "InputRichMessageMedia")
}

#' @rdname InputRichMessageMedia
#' @param x Object to be tested
#' @export
is.InputRichMessageMedia <- function(x) inherits(x, "InputRichMessageMedia")