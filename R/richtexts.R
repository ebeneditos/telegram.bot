#' Create a bold text
#'
#' @param text The text
#' @export
RichTextBold <- function(text) {
  structure(list(
    type = "bold",
    text = text
  ), class = c("RichText", "RichTextBold"))
}

#' @rdname RichTextBold
#' @param x Object to be tested
#' @export
is.RichTextBold <- function(x) inherits(x, "RichTextBold")


#' Create an italic text
#'
#' @param text The text
#' @export
RichTextItalic <- function(text) {
  structure(list(
    type = "italic",
    text = text
  ), class = c("RichText", "RichTextItalic"))
}

#' @rdname RichTextItalic
#' @param x Object to be tested
#' @export
is.RichTextItalic <- function(x) inherits(x, "RichTextItalic")


#' Create an underlined text
#'
#' @param text The text
#' @export
RichTextUnderline <- function(text) {
  structure(list(
    type = "underline",
    text = text
  ), class = c("RichText", "RichTextUnderline"))
}

#' @rdname RichTextUnderline
#' @param x Object to be tested
#' @export
is.RichTextUnderline <- function(x) inherits(x, "RichTextUnderline")


#' Create a strikethrough text
#'
#' @param text The text
#' @export
RichTextStrikethrough <- function(text) {
  structure(list(
    type = "strikethrough",
    text = text
  ), class = c("RichText", "RichTextStrikethrough"))
}

#' @rdname RichTextStrikethrough
#' @param x Object to be tested
#' @export
is.RichTextStrikethrough <- function(x) inherits(x, "RichTextStrikethrough")


#' Create a spoiler text
#'
#' @param text The text
#' @export
RichTextSpoiler <- function(text) {
  structure(list(
    type = "spoiler",
    text = text
  ), class = c("RichText", "RichTextSpoiler"))
}

#' @rdname RichTextSpoiler
#' @param x Object to be tested
#' @export
is.RichTextSpoiler <- function(x) inherits(x, "RichTextSpoiler")


#' Create a formatted date and time
#'
#' @param text The text
#' @param unix_time The Unix time associated with the entity
#' @param date_time_format The string that defines the formatting
#' @export
RichTextDateTime <- function(text, unix_time, date_time_format) {
  structure(list(
    type = "date_time",
    text = text,
    unix_time = unix_time,
    date_time_format = date_time_format
  ), class = c("RichText", "RichTextDateTime"))
}

#' @rdname RichTextDateTime
#' @param x Object to be tested
#' @export
is.RichTextDateTime <- function(x) inherits(x, "RichTextDateTime")


#' Create a text mention
#'
#' @param text The text
#' @param user The mentioned user
#' @export
RichTextTextMention <- function(text, user) {
  structure(list(
    type = "text_mention",
    text = text,
    user = user
  ), class = c("RichText", "RichTextTextMention"))
}

#' @rdname RichTextTextMention
#' @param x Object to be tested
#' @export
is.RichTextTextMention <- function(x) inherits(x, "RichTextTextMention")


#' Create a subscript text
#'
#' @param text The text
#' @export
RichTextSubscript <- function(text) {
  structure(list(
    type = "subscript",
    text = text
  ), class = c("RichText", "RichTextSubscript"))
}

#' @rdname RichTextSubscript
#' @param x Object to be tested
#' @export
is.RichTextSubscript <- function(x) inherits(x, "RichTextSubscript")


#' Create a superscript text
#'
#' @param text The text
#' @export
RichTextSuperscript <- function(text) {
  structure(list(
    type = "superscript",
    text = text
  ), class = c("RichText", "RichTextSuperscript"))
}

#' @rdname RichTextSuperscript
#' @param x Object to be tested
#' @export
is.RichTextSuperscript <- function(x) inherits(x, "RichTextSuperscript")


#' Create a marked text
#'
#' @param text The text
#' @export
RichTextMarked <- function(text) {
  structure(list(
    type = "marked",
    text = text
  ), class = c("RichText", "RichTextMarked"))
}

#' @rdname RichTextMarked
#' @param x Object to be tested
#' @export
is.RichTextMarked <- function(x) inherits(x, "RichTextMarked")


#' Create a monowidth text
#'
#' @param text The text
#' @export
RichTextCode <- function(text) {
  structure(list(
    type = "code",
    text = text
  ), class = c("RichText", "RichTextCode"))
}

#' @rdname RichTextCode
#' @param x Object to be tested
#' @export
is.RichTextCode <- function(x) inherits(x, "RichTextCode")


#' Create a custom emoji
#'
#' @param custom_emoji_id Unique identifier of the custom emoji
#' @param alternative_text Alternative emoji for the custom emoji
#' @export
RichTextCustomEmoji <- function(custom_emoji_id, alternative_text = NULL) {
  structure(list(
    type = "custom_emoji",
    custom_emoji_id = custom_emoji_id,
    alternative_text = alternative_text
  ), class = c("RichText", "RichTextCustomEmoji"))
}

#' @rdname RichTextCustomEmoji
#' @param x Object to be tested
#' @export
is.RichTextCustomEmoji <- function(x) inherits(x, "RichTextCustomEmoji")


#' Create a mathematical expression
#'
#' @param text The text
#' @export
RichTextMathematicalExpression <- function(text) {
  structure(list(
    type = "mathematical_expression",
    text = text
  ), class = c("RichText", "RichTextMathematicalExpression"))
}

#' @rdname RichTextMathematicalExpression
#' @param x Object to be tested
#' @export
is.RichTextMathematicalExpression <- function(x) inherits(x, "RichTextMathematicalExpression")


#' Create a text with a link
#'
#' @param text The text
#' @param url URL of the link
#' @export
RichTextUrl <- function(text, url) {
  structure(list(
    type = "url",
    text = text,
    url = url
  ), class = c("RichText", "RichTextUrl"))
}

#' @rdname RichTextUrl
#' @param x Object to be tested
#' @export
is.RichTextUrl <- function(x) inherits(x, "RichTextUrl")


#' Create a text with an email address
#'
#' @param text The text
#' @param email_address The email address
#' @export
RichTextEmailAddress <- function(text, email_address) {
  structure(list(
    type = "email_address",
    text = text,
    email_address = email_address
  ), class = c("RichText", "RichTextEmailAddress"))
}

#' @rdname RichTextEmailAddress
#' @param x Object to be tested
#' @export
is.RichTextEmailAddress <- function(x) inherits(x, "RichTextEmailAddress")


#' Create a text with a phone number
#'
#' @param text The text
#' @param phone_number The phone number
#' @export
RichTextPhoneNumber <- function(text, phone_number) {
  structure(list(
    type = "phone_number",
    text = text,
    phone_number = phone_number
  ), class = c("RichText", "RichTextPhoneNumber"))
}

#' @rdname RichTextPhoneNumber
#' @param x Object to be tested
#' @export
is.RichTextPhoneNumber <- function(x) inherits(x, "RichTextPhoneNumber")


#' Create a text with a bank card number
#'
#' @param text The text
#' @param bank_card_number The bank card number
#' @export
RichTextBankCardNumber <- function(text, bank_card_number) {
  structure(list(
    type = "bank_card_number",
    text = text,
    bank_card_number = bank_card_number
  ), class = c("RichText", "RichTextBankCardNumber"))
}

#' @rdname RichTextBankCardNumber
#' @param x Object to be tested
#' @export
is.RichTextBankCardNumber <- function(x) inherits(x, "RichTextBankCardNumber")


#' Create an address in the TON blockchain
#'
#' @param text Text of the address
#' @param address The address
#' @export
RichTextTonAddress <- function(text, address) {
  structure(list(
    type = "ton_address",
    text = text,
    address = address
  ), class = c("RichText", "RichTextTonAddress"))
}

#' @rdname RichTextTonAddress
#' @param x Object to be tested
#' @export
is.RichTextTonAddress <- function(x) inherits(x, "RichTextTonAddress")


#' Create a mention by a username
#'
#' @param text The text
#' @param username The username
#' @export
RichTextMention <- function(text, username) {
  structure(list(
    type = "mention",
    text = text,
    username = username
  ), class = c("RichText", "RichTextMention"))
}

#' @rdname RichTextMention
#' @param x Object to be tested
#' @export
is.RichTextMention <- function(x) inherits(x, "RichTextMention")


#' Create a hashtag
#'
#' @param text The text
#' @export
RichTextHashtag <- function(text) {
  structure(list(
    type = "hashtag",
    text = text
  ), class = c("RichText", "RichTextHashtag"))
}

#' @rdname RichTextHashtag
#' @param x Object to be tested
#' @export
is.RichTextHashtag <- function(x) inherits(x, "RichTextHashtag")


#' Create a cashtag
#'
#' @param text The text
#' @export
RichTextCashtag <- function(text) {
  structure(list(
    type = "cashtag",
    text = text
  ), class = c("RichText", "RichTextCashtag"))
}

#' @rdname RichTextCashtag
#' @param x Object to be tested
#' @export
is.RichTextCashtag <- function(x) inherits(x, "RichTextCashtag")


#' Create a bot command
#'
#' @param text The text
#' @export
RichTextBotCommand <- function(text) {
  structure(list(
    type = "bot_command",
    text = text
  ), class = c("RichText", "RichTextBotCommand"))
}

#' @rdname RichTextBotCommand
#' @param x Object to be tested
#' @export
is.RichTextBotCommand <- function(x) inherits(x, "RichTextBotCommand")


#' Create an anchor
#'
#' @param name The name of the anchor
#' @export
RichTextAnchor <- function(name) {
  structure(list(
    type = "anchor",
    name = name
  ), class = c("RichText", "RichTextAnchor"))
}

#' @rdname RichTextAnchor
#' @param x Object to be tested
#' @export
is.RichTextAnchor <- function(x) inherits(x, "RichTextAnchor")


#' Create a link to an anchor
#'
#' @param text The text
#' @param name The name of the anchor
#' @export
RichTextAnchorLink <- function(text, name) {
  structure(list(
    type = "anchor_link",
    text = text,
    name = name
  ), class = c("RichText", "RichTextAnchorLink"))
}

#' @rdname RichTextAnchorLink
#' @param x Object to be tested
#' @export
is.RichTextAnchorLink <- function(x) inherits(x, "RichTextAnchorLink")


#' Create a reference
#'
#' @param text The text
#' @param name The name of the reference
#' @export
RichTextReference <- function(text, name) {
  structure(list(
    type = "reference",
    text = text,
    name = name
  ), class = c("RichText", "RichTextReference"))
}

#' @rdname RichTextReference
#' @param x Object to be tested
#' @export
is.RichTextReference <- function(x) inherits(x, "RichTextReference")


#' Create a button
#'
#' @param button A \code{\link{RichMessageButton}} object
#' @export
RichTextButton <- function(button) {
  if (!is.RichMessageButton(button)) {
    stop("`button` must be a `RichMessageButton` object.")
  }
  structure(list(
    type = "button",
    button = button
  ), class = c("RichText", "RichTextButton"))
}

#' @rdname RichTextButton
#' @param x Object to be tested
#' @export
is.RichTextButton <- function(x) inherits(x, "RichTextButton")


#' Create a link to a reference
#'
#' @param text The text
#' @param name The name of the reference
#' @export
RichTextReferenceLink <- function(text, name) {
  structure(list(
    type = "reference_link",
    text = text,
    name = name
  ), class = c("RichText", "RichTextReferenceLink"))
}

#' @rdname RichTextReferenceLink
#' @param x Object to be tested
#' @export
is.RichTextReferenceLink <- function(x) inherits(x, "RichTextReferenceLink")
