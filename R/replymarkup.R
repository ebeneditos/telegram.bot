
#' Create a keyboard button
#'
#' This object represents one button of the reply keyboard. Optional
#' fields are mutually exclusive.
#'
#' \strong{Note:} \code{request_contact} and \code{request_location}
#' options will only work in Telegram versions released after 9 April,
#' 2016. Older clients will ignore them.
#'
#' @param text Text of the button. If none of the optional
#'     fields are used, it will be sent as a message when the button
#'     is pressed.
#' @param request_contact (Optional). If \code{TRUE}, the user's phone number
#'     will be sent as a contact when the button is pressed. Available in
#'     private chats only.
#' @param request_location (Optional). If \code{TRUE}, the user's current
#'     location will be sent when the button is pressed. Available in private
#'     chats only.
#' @export
KeyboardButton <- function(text,
                           request_contact = NULL,
                           request_location = NULL) {
  KeyboardButton <- list(
    text = text,
    request_contact = request_contact,
    request_location = request_location
  )
  KeyboardButton <- KeyboardButton[!unlist(lapply(KeyboardButton, is.null))]

  structure(KeyboardButton, class = "KeyboardButton")
}

#' @rdname KeyboardButton
#' @param x Object to be tested.
#' @export
is.KeyboardButton <- function(x) {
  inherits(x, "KeyboardButton")
}

#' Create a keyboard markup
#'
#' This object represents a
#' \href{https://core.telegram.org/bots#keyboards}{custom keyboard} with reply
#' options.
#'
#' @param keyboard List of button rows, each represented by a list of
#'     \code{\link{KeyboardButton}} objects.
#' @param resize_keyboard (Optional). Requests clients to resize the keyboard
#'     vertically for optimal fit. Defaults to \code{FALSE}, in which case the
#'     custom keyboard is always of the same height as the app's standard
#'     keyboard.
#' @param one_time_keyboard (Optional). Requests clients to hide the keyboard
#'     as soon as it's been used. The keyboard will still be available, but
#'     clients will automatically display the usual letter-keyboard in the
#'     chat - the user can press a special button in the input field to see the
#'     custom keyboard again. Defaults to \code{FALSE}.
#' @param selective (Optional). Use this parameter if you want to show the
#'     keyboard to specific users only.
#'
#' @examples
#' \dontrun{
#' # Initialize bot
#' bot <- Bot(token = "TOKEN")
#' chat_id <- "CHAT_ID"
#' 
#' # Create Custom Keyboard
#' text <- "Aren't those custom keyboards cool?"
#' RKM <- ReplyKeyboardMarkup(
#'   keyboard = list(
#'     list(KeyboardButton("Yes, they certainly are!")),
#'     list(KeyboardButton("I'm not quite sure")),
#'     list(KeyboardButton("No..."))
#'   ),
#'   resize_keyboard = FALSE,
#'   one_time_keyboard = TRUE
#' )
#' 
#' # Send Custom Keyboard
#' bot$sendMessage(chat_id, text, reply_markup = RKM)
#' }
#' @export
ReplyKeyboardMarkup <- function(keyboard,
                                resize_keyboard = NULL,
                                one_time_keyboard = NULL,
                                selective = NULL) {
  if (!all(unlist(lapply(keyboard, is.list))) |
    !all(unlist(lapply(keyboard, function(x) {
      lapply(x, is.KeyboardButton)
    })))) {
    stop(
      "`keyboard` must be a list of button rows, each represented ",
      "by a list of `KeyboardButton` objects."
    )
  }

  ReplyKeyboardMarkup <- list(
    keyboard = keyboard,
    resize_keyboard = resize_keyboard,
    one_time_keyboard = one_time_keyboard,
    selective = selective
  )
  ReplyKeyboardMarkup <- ReplyKeyboardMarkup[!unlist(lapply(
    ReplyKeyboardMarkup, is.null
  ))]

  structure(ReplyKeyboardMarkup,
    class = c("ReplyKeyboardMarkup", "ReplyMarkup")
  )
}

#' Create an inline keyboard button
#'
#' This object represents one button of an inline keyboard. You
#' \strong{must} use exactly one of the optional fields. If all optional fields
#' are NULL, by defect it will generate \code{callback_data} with same data as
#' in \code{text}.
#'
#' \strong{Note:} After the user presses a callback button,
#' Telegram clients will display a progress bar until you call
#' \code{\link{answerCallbackQuery}}. It is, therefore, necessary to
#' react by calling \code{\link{answerCallbackQuery}} even if no notification
#' to the user is needed (e.g., without specifying any of the
#' optional parameters).
#'
#' @param text Label text on the button.
#' @param url (Optional). HTTP url to be opened when button is pressed.
#' @param callback_data (Optional). Data to be sent in a
#'     \href{https://core.telegram.org/bots/api#callbackquery}{callback query}
#'     to the bot when button is pressed, 1-64 bytes.
#' @param switch_inline_query (Optional). If set, pressing the button will
#'     prompt the user to select one of their chats, open that chat and insert
#'     the bot's username and the specified inline query in the input field.
#'     Can be empty, in which case just the bot's username will be inserted.
#' @param switch_inline_query_current_chat (Optional). If set, pressing the
#'     button will insert the bot's username and the specified inline query in
#'     the current chat's input field. Can be empty, in which case only the
#'     bot's username will be inserted.
#' @export
InlineKeyboardButton <- function(text,
                                 url = NULL,
                                 callback_data = NULL,
                                 switch_inline_query = NULL,
                                 switch_inline_query_current_chat = NULL) {
  if (all(unlist(lapply(
    list(
      url,
      callback_data,
      switch_inline_query,
      switch_inline_query_current_chat
    ),
    is.null
  )))) {
    callback_data <- text
  } else if (sum(unlist(lapply(
    list(
      url,
      callback_data,
      switch_inline_query,
      switch_inline_query_current_chat
    ),
    function(x) !is.null(x)
  ))) != 1L) {
    stop("You must use exactly one of the optional fields.")
  }

  InlineKeyboardButton <- list(
    text = text,
    url = url,
    callback_data = callback_data,
    switch_inline_query = switch_inline_query,
    switch_inline_query_current_chat = switch_inline_query_current_chat
  )
  InlineKeyboardButton <- InlineKeyboardButton[!unlist(lapply(
    InlineKeyboardButton, is.null
  ))]

  structure(InlineKeyboardButton, class = "InlineKeyboardButton")
}

#' @rdname InlineKeyboardButton
#' @param x Object to be tested.
#' @export
is.InlineKeyboardButton <- function(x) {
  inherits(x, "InlineKeyboardButton")
}

#' Create an inline keyboard markup
#'
#' This object represents an
#' \href{https://core.telegram.org/bots#inline-keyboards-and-on-the-fly-updating}{inline keyboard}
#' that appears right next to the message it belongs to.
#'
#' \strong{Note:} After the user presses a callback button,
#' Telegram clients will display a progress bar until you call
#' \code{\link{answerCallbackQuery}}. It is, therefore, necessary to
#' react by calling \code{\link{answerCallbackQuery}} even if no notification
#' to the user is needed (e.g., without specifying any of the
#' optional parameters).
#'
#' @param inline_keyboard List of button rows, each represented by a list of
#'     \code{\link{InlineKeyboardButton}} objects.
#'
#' @examples
#' \dontrun{
#' # Initialize bot
#' bot <- Bot(token = "TOKEN")
#' chat_id <- "CHAT_ID"
#' 
#' # Create Inline Keyboard
#' text <- "Could you type their phone number, please?"
#' IKM <- InlineKeyboardMarkup(
#'   inline_keyboard = list(
#'     list(
#'       InlineKeyboardButton(1),
#'       InlineKeyboardButton(2),
#'       InlineKeyboardButton(3)
#'     ),
#'     list(
#'       InlineKeyboardButton(4),
#'       InlineKeyboardButton(5),
#'       InlineKeyboardButton(6)
#'     ),
#'     list(
#'       InlineKeyboardButton(7),
#'       InlineKeyboardButton(8),
#'       InlineKeyboardButton(9)
#'     ),
#'     list(
#'       InlineKeyboardButton("*"),
#'       InlineKeyboardButton(0),
#'       InlineKeyboardButton("#")
#'     )
#'   )
#' )
#' 
#' # Send Inline Keyboard
#' bot$sendMessage(chat_id, text, reply_markup = IKM)
#' }
#' @export
InlineKeyboardMarkup <- function(inline_keyboard) {
  if (!all(unlist(lapply(inline_keyboard, is.list))) |
    !all(unlist(lapply(inline_keyboard, function(x) {
      lapply(x, is.InlineKeyboardButton)
    })))) {
    stop(
      "`inline_keyboard` must be a list of button rows, each represented ",
      "by a list of `KeyboardButton` objects."
    )
  }

  InlineKeyboardMarkup <- list(inline_keyboard = inline_keyboard)
  InlineKeyboardMarkup <- InlineKeyboardMarkup[!unlist(lapply(
    InlineKeyboardMarkup, is.null
  ))]

  structure(InlineKeyboardMarkup,
    class = c("InlineKeyboardMarkup", "ReplyMarkup")
  )
}

#' Remove a keyboard
#'
#' Upon receiving a message with this object, Telegram clients will
#' remove the current custom keyboard and display the default
#' letter-keyboard. By default, custom keyboards are displayed until
#' a new keyboard is sent by a bot. An exception is made for one-time
#' keyboards that are hidden immediately after the user presses a
#' button (see \code{\link{ReplyKeyboardMarkup}}).
#'
#' @param remove_keyboard Requests clients to remove the custom keyboard.
#'     (user will not be able to summon this keyboard; if you want to hide
#'     the keyboard from sight but keep it accessible, use
#'     \code{one_time_keyboard} in \code{\link{ReplyKeyboardMarkup}}).
#'     Defaults to \code{TRUE}.
#' @param selective (Optional). Use this parameter if you want to show the
#'     keyboard to specific users only.
#'
#' @examples
#' \dontrun{
#' # Initialize bot
#' bot <- Bot(token = "TOKEN")
#' chat_id <- "CHAT_ID"
#' 
#' # Create Custom Keyboard
#' text <- "Don't forget to send me the answer!"
#' RKM <- ReplyKeyboardMarkup(
#'   keyboard = list(
#'     list(KeyboardButton("Yes, they certainly are!")),
#'     list(KeyboardButton("I'm not quite sure")),
#'     list(KeyboardButton("No..."))
#'   ),
#'   resize_keyboard = FALSE,
#'   one_time_keyboard = FALSE
#' )
#' 
#' # Send Custom Keyboard
#' bot$sendMessage(chat_id, text, reply_markup = RKM)
#' 
#' # Remove Keyboard
#' bot$sendMessage(
#'   chat_id,
#'   "Okay, thanks!",
#'   reply_markup = ReplyKeyboardRemove()
#' )
#' }
#' @export
ReplyKeyboardRemove <- function(remove_keyboard = TRUE,
                                selective = NULL) {
  ReplyKeyboardRemove <- list(
    remove_keyboard = remove_keyboard,
    selective = selective
  )
  ReplyKeyboardRemove <- ReplyKeyboardRemove[!unlist(lapply(
    ReplyKeyboardRemove, is.null
  ))]

  structure(ReplyKeyboardRemove,
    class = c("ReplyKeyboardRemove", "ReplyMarkup")
  )
}


#' Display a reply
#'
#' Upon receiving a message with this object, Telegram clients will display
#' a reply interface to the user (act as if the user has selected the bot's
#' message and tapped 'Reply').
#'
#' @param force_reply Shows reply interface to the user, as if they manually
#'     selected the bot's message and tapped 'Reply'. Defaults to \code{TRUE}.
#' @param selective (Optional). Use this parameter if you want to show the
#'     keyboard to specific users only.
#'
#' @examples
#' \dontrun{
#' # Initialize bot
#' bot <- Bot(token = "TOKEN")
#' chat_id <- "CHAT_ID"
#' 
#' # Set input parameters
#' text <- "Don't forget to send me the answer!"
#' 
#' # Send reply message
#' bot$sendMessage(chat_id, text, reply_markup = ForceReply())
#' }
#' @export
ForceReply <- function(force_reply = TRUE,
                       selective = NULL) {
  ForceReply <- list(
    force_reply = force_reply,
    selective = selective
  )
  ForceReply <- ForceReply[!unlist(lapply(ForceReply, is.null))]

  structure(ForceReply, class = c("ForceReply", "ReplyMarkup"))
}
