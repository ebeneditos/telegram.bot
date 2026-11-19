#' Create a rich message
#'
#' Rich formatted message.
#'
#' @param blocks List of \code{\link{RichBlock}} objects. Content of the message
#' @param is_rtl (Optional). TRUE, if the rich message must be shown right-to-left
#' @export
RichMessage <- function(blocks, is_rtl = NULL) {
  RichMessage <- list(
    blocks = blocks,
    is_rtl = is_rtl
  )
  RichMessage <- RichMessage[!unlist(lapply(RichMessage, is.null))]

  structure(RichMessage, class = "RichMessage")
}

#' @rdname RichMessage
#' @param x Object to be tested
#' @export
is.RichMessage <- function(x) inherits(x, "RichMessage")


#' Create a button in a rich message
#'
#' This object represents a button in a \code{\link{RichMessage}}. Exactly one of
#' the fields other than \code{text} and \code{style} must be used to specify the
#' type of the button.
#'
#' @param text \code{\link{RichText}} Text of the button. May contain only plain text,
#'     \code{\link{RichTextCustomEmoji}} and \code{\link{RichTextDateTime}} entities
#' @param style (Optional). Style of the button. Must be one of "danger",
#'     "success", "primary", or "link"
#' @param url (Optional). HTTP or tg:// URL to be opened when the button is pressed
#' @param callback_data (Optional). Data to be sent in a callback query to the bot
#'     when button is pressed, 1-64 bytes
#' @param web_app (Optional). Description of the Web App that will be launched when
#'     the user presses the button. Available only in private chats between a user
#'     and the bot
#' @param login_url (Optional). An HTTPS URL used to automatically authorize the user
#' @param switch_inline_query (Optional). If set, pressing the button will prompt the
#'     user to select one of their chats, open that chat and insert the bot's
#'     username and the specified inline query in the input field
#' @param switch_inline_query_current_chat (Optional). If set, pressing the button will
#'     insert the bot's username and the specified inline query in the current chat's
#'     input field
#' @param switch_inline_query_chosen_chat (Optional). If set, pressing the button will
#'     prompt the user to select one of their chats of the specified type, open that
#'     chat and insert the bot's username and the specified inline query in the input field
#' @param copy_text (Optional). A button that copies the specified text to the clipboard
#' @param disabled (Optional). If set, then the button is disabled and does nothing
#' @export
RichMessageButton <- function(text,
                              style = NULL,
                              url = NULL,
                              callback_data = NULL,
                              web_app = NULL,
                              login_url = NULL,
                              switch_inline_query = NULL,
                              switch_inline_query_current_chat = NULL,
                              switch_inline_query_chosen_chat = NULL,
                              copy_text = NULL,
                              disabled = NULL) {
  if (!is.null(style) && !(style %in% c("danger", "success", "primary", "link"))) {
    stop("`style` must be one of \"danger\", \"success\", \"primary\", or \"link\".")
  }

  RichMessageButton <- list(
    text = text,
    style = style,
    url = url,
    callback_data = callback_data,
    web_app = web_app,
    login_url = login_url,
    switch_inline_query = switch_inline_query,
    switch_inline_query_current_chat = switch_inline_query_current_chat,
    switch_inline_query_chosen_chat = switch_inline_query_chosen_chat,
    copy_text = copy_text,
    disabled = disabled
  )
  RichMessageButton <- RichMessageButton[!unlist(lapply(
    RichMessageButton, is.null
  ))]

  structure(RichMessageButton, class = "RichMessageButton")
}

#' @rdname RichMessageButton
#' @param x Object to be tested
#' @export
is.RichMessageButton <- function(x) inherits(x, "RichMessageButton")