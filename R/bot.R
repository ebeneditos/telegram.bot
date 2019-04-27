
#### INTERNAL METHODS ####

# Print function
.print <- function() {
  obj <- objects(self)
  api_methods <- obj[grepl("[A-Z]", obj)]
  snake <- gsub("([a-z])([A-Z])", "\\1_\\L\\2", api_methods, perl = TRUE)
  dont_show <- c("clone", "initialize", "print")
  avail_methods <- sort(api_methods)
  remaining_methods <- sort(setdiff(obj, c(avail_methods, snake, dont_show)))
  api_string <- method_summaries(avail_methods, indent = 4L)
  remaining_string <- method_summaries(remaining_methods, indent = 4L)

  ret <- paste0("<", class(self)[1L], ">")

  classes <- setdiff(class(self), "R6")
  if (length(classes) >= 2L) {
    ret <- c(ret, paste0("  Inherits from: <", classes[2L], ">")) # nocov
  }

  ret <- c(
    ret,
    "  API Methods:", api_string,
    "  Other Methods:", remaining_string
  )

  cat(paste(ret, collapse = "\n"), sep = "\n")
}

# A very basic validation on token
.validate_token <- function(token) {
  if (grepl(" ", token)) {
    stop("Invalid `token`.")
  }

  split <- strsplit(token, ":")[[1L]]
  if (length(split) < 2L ||
    identical(split[2L], "") ||
    grepl("\\D", split[1L]) ||
    nchar(split[1L]) < 3L) {
    stop("Invalid `token`.")
  }

  token
}

# Request an URL
.request <- function(url,
                     data) {
  result <- httr::POST(
    url = url,
    body = data,
    config = private$request_config,
    encode = "multipart"
  )
  httr::stop_for_status(result)

  if (result$status_code >= 200L && result$status_code < 300L) {
    # 200-299 range are HTTP success statuses
    return(private$parse(result))
  } else {
    stop("HTTPError") # nocov
  }
}

# Parse result
.parse <- function(result) {
  data <- tryCatch({
    httr::content(result, as = "parsed", encoding = "UTF-8")
  })

  if (is.list(data) && data$ok) {
    return(data$result)
  } else {
    stop("Invalid server response.") # nocov
  }
}


#### API METHODS ####

#' Check your bot's information
#'
#' A simple method for testing your bot's auth token. Requires no parameters.
#'
#' You can also use it's snake_case equivalent \code{get_me}.
getMe <- function() {
  url <- sprintf("%s/getMe", private$base_url)

  data <- list()

  result <- private$request(url, data)

  invisible(result)
}


#' Send text messages
#'
#' Use this method to send text messages.
#'
#' You can also use it's snake_case equivalent \code{send_message}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param text Text of the message to be sent.
#' @param parse_mode (Optional). Send 'Markdown' or 'HTML', if you want
#'     Telegram apps to show bold, italic, fixed-width text or inline URLs in
#'     your bot's message.
#' @param disable_web_page_preview (Optional). Disables link previews for links
#'     in this message.
#' @param disable_notification (Optional). Sends the message silently. Users
#'     will receive a notification with no sound.
#' @param reply_to_message_id (Optional). If the message is a reply, ID of the
#'     original message.
#' @param reply_markup (Optional). A Reply Markup parameter object, it can be
#'     either:
#'     \itemize{
#'      \item{\code{\link{ReplyKeyboardMarkup}}}
#'      \item{\code{\link{InlineKeyboardMarkup}}}
#'      \item{\code{\link{ReplyKeyboardRemove}}}
#'      \item{\code{\link{ForceReply}}}
#'     }
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' 
#' bot$sendMessage(
#'   chat_id = chat_id,
#'   text = "foo *bold* _italic_",
#'   parse_mode = "Markdown"
#' )
#' }
sendMessage <- function(chat_id,
                        text,
                        parse_mode = NULL,
                        disable_web_page_preview = NULL,
                        disable_notification = FALSE,
                        reply_to_message_id = NULL,
                        reply_markup = NULL) {
  url <- sprintf("%s/sendMessage", private$base_url)

  data <- list(
    chat_id = chat_id,
    text = text
  )

  if (!missing(parse_mode)) {
    data[["parse_mode"]] <- parse_mode
  }
  if (!missing(disable_web_page_preview)) {
    data[["disable_web_page_preview"]] <- disable_web_page_preview
  }
  if (!missing(disable_notification)) {
    data[["disable_notification"]] <- disable_notification
  }
  if (!missing(reply_to_message_id)) {
    data[["reply_to_message_id"]] <- reply_to_message_id
  }
  if (!missing(reply_markup)) {
    data[["reply_markup"]] <- to_json(reply_markup)
  }

  result <- private$request(url, data)

  invisible(result)
}


#' Delete a message
#'
#' Use this method to delete a message. A message can only be deleted if it was
#' sent less than 48 hours ago. Any such recently sent outgoing message may be
#' deleted. Additionally, if the bot is an administrator in a group chat, it
#' can delete any message. If the bot is an administrator in a supergroup, it
#' can delete messages from any other user and service messages about people
#' joining or leaving the group (other types of service messages may only be
#' removed by the group creator). In channels, bots can only remove their own
#' messages.
#'
#' You can also use it's snake_case equivalent \code{delete_message}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param message_id Identifier of the message to delete.
deleteMessage <- function(chat_id,
                          message_id) { # nocov start
  url <- sprintf("%s/deleteMessage", private$base_url)

  data <- list(
    chat_id = chat_id,
    message_id = message_id
  )

  result <- private$request(url, data)

  invisible(result)
} # nocov end


#' Forward messages of any kind
#'
#' Use this method to forward messages of any kind.
#'
#' You can also use it's snake_case equivalent \code{forward_message}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param from_chat_id Unique identifier for the chat where the
#'     original message was sent.
#' @param message_id Message identifier in the chat specified in from_chat_id.
#' @param disable_notification (Optional). Sends the message silently. Users
#'     will receive a notification with no sound.
forwardMessage <- function(chat_id,
                           from_chat_id,
                           message_id,
                           disable_notification = FALSE) { # nocov start
  url <- sprintf("%s/forwardMessage", private$base_url)

  data <- list(
    chat_id = chat_id,
    from_chat_id = from_chat_id,
    message_id = message_id
  )

  if (!missing(disable_notification)) {
    data[["disable_notification"]] <- disable_notification
  }

  result <- private$request(url, data)

  invisible(result)
} # nocov end


#' Send image files
#'
#' Use this method to send photos.
#'
#' You can also use it's snake_case equivalent \code{send_photo}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param photo Photo to send. Pass a file_id as String to send a photo that
#'     exists on the Telegram servers (recommended), pass an HTTP URL as a
#'     String for Telegram to get a photo from the Internet, or upload a local
#'     photo by passing a file path.
#' @param caption (Optional). Photo caption (may also be used when re-sending
#'     photos by file_id), 0-1024 characters.
#' @param disable_notification (Optional). Sends the message silently. Users
#'     will receive a notification with no sound.
#' @param reply_to_message_id (Optional). If the message is a reply, ID of the
#'     original message.
#' @param reply_markup (Optional). A Reply Markup parameter object, it can be
#'     either:
#'     \itemize{
#'      \item{\code{\link{ReplyKeyboardMarkup}}}
#'      \item{\code{\link{InlineKeyboardMarkup}}}
#'      \item{\code{\link{ReplyKeyboardRemove}}}
#'      \item{\code{\link{ForceReply}}}}
#' @param parse_mode (Optional). Send 'Markdown' or 'HTML', if you want
#'     Telegram apps to show bold, italic, fixed-width text or inline URLs in
#'     your bot's message.
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' photo_url <- "https://telegram.org/img/t_logo.png"
#' 
#' bot$sendPhoto(
#'   chat_id = chat_id,
#'   photo = photo_url,
#'   caption = "Telegram Logo"
#' )
#' }
sendPhoto <- function(chat_id,
                      photo,
                      caption = NULL,
                      disable_notification = FALSE,
                      reply_to_message_id = NULL,
                      reply_markup = NULL,
                      parse_mode = NULL) {
  url <- sprintf("%s/sendPhoto", private$base_url)

  if (file.exists(photo)) {
    photo <- httr::upload_file(photo) # nocov
  }

  data <- list(chat_id = chat_id, photo = photo)

  if (!missing(caption)) {
    data[["caption"]] <- caption
  }
  if (!missing(disable_notification)) {
    data[["disable_notification"]] <- disable_notification
  }
  if (!missing(reply_to_message_id)) {
    data[["reply_to_message_id"]] <- reply_to_message_id
  }
  if (!missing(reply_markup)) {
    data[["reply_markup"]] <- to_json(reply_markup)
  }
  if (!missing(parse_mode)) {
    data[["parse_mode"]] <- parse_mode
  }

  result <- private$request(url, data)

  invisible(result)
}


#' Send audio files
#'
#' Use this method to send audio files, if you want Telegram clients to display
#' them in the music player. Your audio must be in the .mp3 format. On success,
#' the sent Message is returned. Bots can currently send audio files of up to
#' 50 MB in size, this limit may be changed in the future.
#' For sending voice messages, use the \code{\link{sendVoice}} method instead.
#'
#' You can also use it's snake_case equivalent \code{send_audio}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param audio Audio file to send. Pass a file_id as String to send an audio
#'     that exists on the Telegram servers (recommended), pass an HTTP URL as a
#'     String for Telegram to get an audio from the Internet, or upload a local
#'     audio file by passing a file path.
#' @param duration (Optional). Duration of sent audio in seconds.
#' @param performer (Optional). Performer.
#' @param title (Optional). Track name.
#' @param caption (Optional). Audio caption, 0-1024 characters.
#' @param disable_notification (Optional). Sends the message silently. Users
#'     will receive a notification with no sound.
#' @param reply_to_message_id (Optional). If the message is a reply, ID of the
#'     original message.
#' @param reply_markup (Optional). A Reply Markup parameter object, it can be
#'     either:
#'     \itemize{
#'      \item{\code{\link{ReplyKeyboardMarkup}}}
#'      \item{\code{\link{InlineKeyboardMarkup}}}
#'      \item{\code{\link{ReplyKeyboardRemove}}}
#'      \item{\code{\link{ForceReply}}}}
#' @param parse_mode (Optional). Send 'Markdown' or 'HTML', if you want
#'     Telegram apps to show bold, italic, fixed-width text or inline URLs in
#'     your bot's message.
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' audio_url <- "http://www.largesound.com/ashborytour/sound/brobob.mp3"
#' 
#' bot$sendAudio(
#'   chat_id = chat_id,
#'   audio = audio_url
#' )
#' }
sendAudio <- function(chat_id,
                      audio,
                      duration = NULL,
                      performer = NULL,
                      title = NULL,
                      caption = NULL,
                      disable_notification = FALSE,
                      reply_to_message_id = NULL,
                      reply_markup = NULL,
                      parse_mode = NULL) {
  url <- sprintf("%s/sendAudio", private$base_url)

  if (file.exists(audio)) {
    audio <- httr::upload_file(audio) # nocov
  }

  data <- list(chat_id = chat_id, audio = audio)

  if (!missing(duration)) {
    data[["duration"]] <- duration
  }
  if (!missing(performer)) {
    data[["performer"]] <- performer
  }
  if (!missing(title)) {
    data[["title"]] <- title
  }
  if (!missing(caption)) {
    data[["caption"]] <- caption
  }
  if (!missing(disable_notification)) {
    data[["disable_notification"]] <- disable_notification
  }
  if (!missing(reply_to_message_id)) {
    data[["reply_to_message_id"]] <- reply_to_message_id
  }
  if (!missing(reply_markup)) {
    data[["reply_markup"]] <- to_json(reply_markup)
  }
  if (!missing(parse_mode)) {
    data[["parse_mode"]] <- parse_mode
  }

  result <- private$request(url, data)

  invisible(result)
}


#' Send general files
#'
#' Use this method to send general files.
#'
#' You can also use it's snake_case equivalent \code{send_document}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param document File to send. Pass a file_id as String to send a file that
#'     exists on the Telegram servers (recommended), pass an HTTP URL as a
#'     String for Telegram to get a file from the Internet, or upload a local
#'     file by passing a file path
#' @param filename (Optional). File name that shows in telegram message.
#' @param caption (Optional). Document caption, 0-1024 characters.
#' @param disable_notification (Optional). Sends the message silently. Users
#'     will receive a notification with no sound.
#' @param reply_to_message_id (Optional). If the message is a reply, ID of the
#'     original message.
#' @param reply_markup (Optional). A Reply Markup parameter object, it can be
#'     either:
#'     \itemize{
#'      \item{\code{\link{ReplyKeyboardMarkup}}}
#'      \item{\code{\link{InlineKeyboardMarkup}}}
#'      \item{\code{\link{ReplyKeyboardRemove}}}
#'      \item{\code{\link{ForceReply}}}}
#' @param parse_mode (Optional). Send 'Markdown' or 'HTML', if you want
#'     Telegram apps to show bold, italic, fixed-width text or inline URLs in
#'     your bot's message.
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' document_url <- paste0(
#'   "https://github.com/ebeneditos/telegram.bot/raw/gh-pages/docs/",
#'   "telegram.bot.pdf"
#' )
#' 
#' bot$sendDocument(
#'   chat_id = chat_id,
#'   document = document_url
#' )
#' }
sendDocument <- function(chat_id,
                         document,
                         filename = NULL,
                         caption = NULL,
                         disable_notification = FALSE,
                         reply_to_message_id = NULL,
                         reply_markup = NULL,
                         parse_mode = NULL) {
  url <- sprintf("%s/sendDocument", private$base_url)

  if (file.exists(document)) {
    document <- httr::upload_file(document) # nocov
  }

  data <- list(chat_id = chat_id, document = document)

  if (!missing(filename)) {
    data[["filename"]] <- filename
  }
  if (!missing(caption)) {
    data[["caption"]] <- caption
  }
  if (!missing(disable_notification)) {
    data[["disable_notification"]] <- disable_notification
  }
  if (!missing(reply_to_message_id)) {
    data[["reply_to_message_id"]] <- reply_to_message_id
  }
  if (!missing(reply_markup)) {
    data[["reply_markup"]] <- to_json(reply_markup)
  }
  if (!missing(parse_mode)) {
    data[["parse_mode"]] <- parse_mode
  }

  result <- private$request(url, data)

  invisible(result)
}


#' Send a sticker
#'
#' Use this method to send \code{.webp} stickers.
#'
#' You can also use it's snake_case equivalent \code{send_sticker}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param sticker Sticker to send. Pass a file_id as String to send a file that
#'     exists on the Telegram servers (recommended), pass an HTTP URL as a
#'     String for Telegram to get a \code{.webp} file from the Internet, or
#'     upload a local one by passing a file path.
#' @param disable_notification (Optional). Sends the message silently. Users
#'     will receive a notification with no sound.
#' @param reply_to_message_id (Optional). If the message is a reply, ID of the
#'     original message.
#' @param reply_markup (Optional). A Reply Markup parameter object, it can be
#'     either:
#'     \itemize{
#'      \item{\code{\link{ReplyKeyboardMarkup}}}
#'      \item{\code{\link{InlineKeyboardMarkup}}}
#'      \item{\code{\link{ReplyKeyboardRemove}}}
#'      \item{\code{\link{ForceReply}}}}
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' sticker_url <- "https://www.gstatic.com/webp/gallery/1.webp"
#' 
#' bot$sendSticker(
#'   chat_id = chat_id,
#'   sticker = sticker_url
#' )
#' }
sendSticker <- function(chat_id,
                        sticker,
                        disable_notification = FALSE,
                        reply_to_message_id = NULL,
                        reply_markup = NULL) {
  url <- sprintf("%s/sendSticker", private$base_url)

  if (file.exists(sticker)) {
    sticker <- httr::upload_file(sticker) # nocov
  }

  data <- list(chat_id = chat_id, sticker = sticker)

  if (!missing(disable_notification)) {
    data[["disable_notification"]] <- disable_notification
  }
  if (!missing(reply_to_message_id)) {
    data[["reply_to_message_id"]] <- reply_to_message_id
  }
  if (!missing(reply_markup)) {
    data[["reply_markup"]] <- to_json(reply_markup)
  }

  result <- private$request(url, data)

  invisible(result)
}


#' Send a video
#'
#' Use this method to send video files, Telegram clients support mp4 videos
#' (other formats may be sent as Document).
#'
#' You can also use it's snake_case equivalent \code{send_video}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param video Video file to send. Pass a file_id as String to send a video
#'     that exists on the Telegram servers (recommended), pass an HTTP URL as a
#'     String for Telegram to get a video from the Internet, or upload a local
#'     video file by passing a file path.
#' @param duration (Optional). Duration of sent audio in seconds.
#' @param caption (Optional). Video caption, 0-1024 characters.
#' @param disable_notification (Optional). Sends the message silently. Users
#'     will receive a notification with no sound.
#' @param reply_to_message_id (Optional). If the message is a reply, ID of the
#'     original message.
#' @param reply_markup (Optional). A Reply Markup parameter object, it can be
#'     either:
#'     \itemize{
#'      \item{\code{\link{ReplyKeyboardMarkup}}}
#'      \item{\code{\link{InlineKeyboardMarkup}}}
#'      \item{\code{\link{ReplyKeyboardRemove}}}
#'      \item{\code{\link{ForceReply}}}}
#' @param width (Optional). Video width.
#' @param height (Optional). Video height.
#' @param parse_mode (Optional). Send 'Markdown' or 'HTML', if you want
#'     Telegram apps to show bold, italic, fixed-width text or inline URLs in
#'     your bot's message.
#' @param supports_streaming (Optional). Pass \code{TRUE}, if the uploaded
#'     video is suitable for streaming.
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' video_url <- "http://techslides.com/demos/sample-videos/small.mp4"
#' 
#' bot$sendVideo(
#'   chat_id = chat_id,
#'   video = video_url
#' )
#' }
sendVideo <- function(chat_id,
                      video,
                      duration = NULL,
                      caption = NULL,
                      disable_notification = FALSE,
                      reply_to_message_id = NULL,
                      reply_markup = NULL,
                      width = NULL,
                      height = NULL,
                      parse_mode = NULL,
                      supports_streaming = NULL) {
  url <- sprintf("%s/sendVideo", private$base_url)

  if (file.exists(video)) {
    video <- httr::upload_file(video) # nocov
  }

  data <- list(chat_id = chat_id, video = video)

  if (!missing(duration)) {
    data[["duration"]] <- duration
  }
  if (!missing(width)) {
    data[["width"]] <- width
  }
  if (!missing(height)) {
    data[["height"]] <- height
  }
  if (!missing(caption)) {
    data[["caption"]] <- caption
  }
  if (!missing(disable_notification)) {
    data[["disable_notification"]] <- disable_notification
  }
  if (!missing(reply_to_message_id)) {
    data[["reply_to_message_id"]] <- reply_to_message_id
  }
  if (!missing(reply_markup)) {
    data[["reply_markup"]] <- to_json(reply_markup)
  }
  if (!missing(parse_mode)) {
    data[["parse_mode"]] <- parse_mode
  }
  if (!missing(supports_streaming)) {
    data[["supports_streaming"]] <- supports_streaming
  }

  result <- private$request(url, data)

  invisible(result)
}


#' Send video messages
#'
#' Use this method to send video messages.
#'
#' You can also use it's snake_case equivalent \code{send_video_note}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param video_note Video note file to send. Pass a file_id as String to send
#'     a video note that exists on the Telegram servers (recommended), pass an
#'     HTTP URL as a String for Telegram to get a video note from the Internet,
#'     or upload a local video note file by passing a file path.
#' @param duration (Optional). Duration of sent audio in seconds.
#' @param length (Optional). Video width and height.
#' @param disable_notification (Optional). Sends the message silently. Users
#'     will receive a notification with no sound.
#' @param reply_to_message_id (Optional). If the message is a reply, ID of the
#'     original message.
#' @param reply_markup (Optional). A Reply Markup parameter object, it can be
#'     either:
#'     \itemize{
#'      \item{\code{\link{ReplyKeyboardMarkup}}}
#'      \item{\code{\link{InlineKeyboardMarkup}}}
#'      \item{\code{\link{ReplyKeyboardRemove}}}
#'      \item{\code{\link{ForceReply}}}}
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' video_note_url <- "http://techslides.com/demos/sample-videos/small.mp4"
#' 
#' bot$sendVideoNote(
#'   chat_id = chat_id,
#'   video_note = video_note_url
#' )
#' }
sendVideoNote <- function(chat_id,
                          video_note,
                          duration = NULL,
                          length = NULL,
                          disable_notification = FALSE,
                          reply_to_message_id = NULL,
                          reply_markup = NULL) {
  url <- sprintf("%s/sendVideoNote", private$base_url)

  if (file.exists(video_note)) {
    video_note <- httr::upload_file(video_note) # nocov
  }

  data <- list(chat_id = chat_id, video_note = video_note)

  if (!missing(duration)) {
    data[["duration"]] <- duration
  }
  if (!missing(length)) {
    data[["length"]] <- length
  }
  if (!missing(disable_notification)) {
    data[["disable_notification"]] <- disable_notification
  }
  if (!missing(reply_to_message_id)) {
    data[["reply_to_message_id"]] <- reply_to_message_id
  }
  if (!missing(reply_markup)) {
    data[["reply_markup"]] <- to_json(reply_markup)
  }

  result <- private$request(url, data)

  invisible(result)
}


#' Send animation files
#'
#' Use this method to send animation files (GIF or H.264/MPEG-4 AVC video
#' without sound).
#'
#' You can also use it's snake_case equivalent \code{send_animation}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param animation Animation to send. Pass a file_id as String to send an
#'     animation that exists on the Telegram servers (recommended), pass an
#'     HTTP URL as a String for Telegram to get an animation from the Internet,
#'     or upload a local file by passing a file path.
#' @param duration (Optional). Duration of sent audio in seconds.
#' @param width (Optional). Video width.
#' @param height (Optional). Video height.
#' @param caption (Optional). Animation caption, 0-1024 characters.
#' @param parse_mode (Optional). Send 'Markdown' or 'HTML', if you want
#'     Telegram apps to show bold, italic, fixed-width text or inline URLs in
#'     your bot's message.
#' @param disable_notification (Optional). Sends the message silently. Users
#'     will receive a notification with no sound.
#' @param reply_to_message_id (Optional). If the message is a reply, ID of the
#'     original message.
#' @param reply_markup (Optional). A Reply Markup parameter object, it can be
#'     either:
#'     \itemize{
#'      \item{\code{\link{ReplyKeyboardMarkup}}}
#'      \item{\code{\link{InlineKeyboardMarkup}}}
#'      \item{\code{\link{ReplyKeyboardRemove}}}
#'      \item{\code{\link{ForceReply}}}}
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' animation_url <- "http://techslides.com/demos/sample-videos/small.mp4"
#' 
#' bot$sendAnimation(
#'   chat_id = chat_id,
#'   animation = animation_url
#' )
#' }
sendAnimation <- function(chat_id,
                          animation,
                          duration = NULL,
                          width = NULL,
                          height = NULL,
                          caption = NULL,
                          parse_mode = NULL,
                          disable_notification = FALSE,
                          reply_to_message_id = NULL,
                          reply_markup = NULL) {
  url <- sprintf("%s/sendAnimation", private$base_url)

  if (file.exists(animation)) {
    animation <- httr::upload_file(animation) # nocov
  }

  data <- list(chat_id = chat_id, animation = animation)

  if (!missing(duration)) {
    data[["duration"]] <- duration
  }
  if (!missing(width)) {
    data[["width"]] <- width
  }
  if (!missing(height)) {
    data[["height"]] <- height
  }
  if (!missing(caption)) {
    data[["caption"]] <- caption
  }
  if (!missing(disable_notification)) {
    data[["disable_notification"]] <- disable_notification
  }
  if (!missing(reply_to_message_id)) {
    data[["reply_to_message_id"]] <- reply_to_message_id
  }
  if (!missing(reply_markup)) {
    data[["reply_markup"]] <- to_json(reply_markup)
  }
  if (!missing(parse_mode)) {
    data[["parse_mode"]] <- parse_mode
  }

  result <- private$request(url, data)

  invisible(result)
}


#' Send voice files
#'
#' Use this method to send audio files, if you want Telegram clients to display
#' the file as a playable voice message. For this to work, your audio must be
#' in an \code{.ogg} file encoded with OPUS (other formats may be sent with
#' \code{\link{sendAudio}} or \code{\link{sendDocument}}).
#'
#' You can also use it's snake_case equivalent \code{send_voice}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param voice Voice file to send. Pass a file_id as String to send a voice
#'     file that exists on the Telegram servers (recommended), pass an HTTP URL
#'     as a String for Telegram to get a voice file from the Internet, or
#'     upload a local voice file file by passing a file path.
#' @param duration (Optional). Duration of sent audio in seconds.
#' @param caption (Optional). Voice message caption, 0-1024 characters.
#' @param disable_notification (Optional). Sends the message silently. Users
#'     will receive a notification with no sound.
#' @param reply_to_message_id (Optional). If the message is a reply, ID of the
#'     original message.
#' @param reply_markup (Optional). A Reply Markup parameter object, it can be
#'     either:
#'     \itemize{
#'      \item{\code{\link{ReplyKeyboardMarkup}}}
#'      \item{\code{\link{InlineKeyboardMarkup}}}
#'      \item{\code{\link{ReplyKeyboardRemove}}}
#'      \item{\code{\link{ForceReply}}}}
#' @param parse_mode (Optional). Send 'Markdown' or 'HTML', if you want
#'     Telegram apps to show bold, italic, fixed-width text or inline URLs in
#'     your bot's message.
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' ogg_url <- "https://upload.wikimedia.org/wikipedia/commons/c/c8/Example.ogg"
#' 
#' bot$sendVoice(
#'   chat_id = chat_id,
#'   voice = ogg_url
#' )
#' }
sendVoice <- function(chat_id,
                      voice,
                      duration = NULL,
                      caption = NULL,
                      disable_notification = FALSE,
                      reply_to_message_id = NULL,
                      reply_markup = NULL,
                      parse_mode = NULL) {
  url <- sprintf("%s/sendVoice", private$base_url)

  if (file.exists(voice)) {
    voice <- httr::upload_file(voice) # nocov
  }

  data <- list(chat_id = chat_id, voice = voice)

  if (!missing(duration)) {
    data[["duration"]] <- duration
  }
  if (!missing(caption)) {
    data[["caption"]] <- caption
  }
  if (!missing(disable_notification)) {
    data[["disable_notification"]] <- disable_notification
  }
  if (!missing(reply_to_message_id)) {
    data[["reply_to_message_id"]] <- reply_to_message_id
  }
  if (!missing(reply_markup)) {
    data[["reply_markup"]] <- to_json(reply_markup)
  }
  if (!missing(parse_mode)) {
    data[["parse_mode"]] <- parse_mode
  }

  result <- private$request(url, data)

  invisible(result)
}


#' Send point on the map
#'
#' Use this method to send point on the map.
#'
#' You can also use it's snake_case equivalent \code{send_location}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param latitude Latitude of location.
#' @param longitude Longitude of location.
#' @param disable_notification (Optional). Sends the message silently. Users
#'     will receive a notification with no sound.
#' @param reply_to_message_id (Optional). If the message is a reply, ID of the
#'     original message.
#' @param reply_markup (Optional). A Reply Markup parameter object, it can be
#'     either:
#'     \itemize{
#'      \item{\code{\link{ReplyKeyboardMarkup}}}
#'      \item{\code{\link{InlineKeyboardMarkup}}}
#'      \item{\code{\link{ReplyKeyboardRemove}}}
#'      \item{\code{\link{ForceReply}}}}
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' 
#' bot$sendLocation(
#'   chat_id = chat_id,
#'   latitude = 51.521727,
#'   longitude = -0.117255
#' )
#' }
sendLocation <- function(chat_id,
                         latitude,
                         longitude,
                         disable_notification = FALSE,
                         reply_to_message_id = NULL,
                         reply_markup = NULL) {
  url <- sprintf("%s/sendLocation", private$base_url)

  data <- list(chat_id = chat_id, latitude = latitude, longitude = longitude)

  if (!missing(disable_notification)) {
    data[["disable_notification"]] <- disable_notification
  }
  if (!missing(reply_to_message_id)) {
    data[["reply_to_message_id"]] <- reply_to_message_id
  }
  if (!missing(reply_markup)) {
    data[["reply_markup"]] <- to_json(reply_markup)
  }

  result <- private$request(url, data)

  invisible(result)
}


#' Send a chat action
#'
#' Use this method when you need to tell the user that something is happening
#' on the bot's side. The status is set for 5 seconds or less (when a message
#' arrives from your bot, Telegram clients clear its typing status).
#'
#' You can also use it's snake_case equivalent \code{send_chat_action}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
#' @param action Type of action to broadcast. Choose one, depending on
#' what the user is about to receive:
#' \itemize{
#'  \item{\code{typing}}{ for text messages}
#'  \item{\code{upload_photo}}{ for photos}
#'  \item{\code{upload_video}}{ for videos}
#'  \item{\code{record_video}}{ for video recording}
#'  \item{\code{upload_audio}}{ for audio files}
#'  \item{\code{record_audio}}{ for audio file recording}
#'  \item{\code{upload_document}}{ for general files}
#'  \item{\code{find_location}}{ for location data}
#'  \item{\code{upload_video_note}}{ for video notes}
#'  \item{\code{record_video_note}}{ for video note recording}
#' }
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' 
#' bot$sendChatAction(
#'   chat_id = chat_id,
#'   action = "typing"
#' )
#' }
sendChatAction <- function(chat_id,
                           action) {
  url <- sprintf("%s/sendChatAction", private$base_url)

  data <- list(chat_id = chat_id, action = action)

  result <- private$request(url, data)

  invisible(result)
}


#' Get a user's profile photos
#'
#' Use this method to get a list of profile pictures for a user.
#'
#' You can also use it's snake_case equivalent \code{get_user_profile_photos}.
#'
#' See \code{\link{getFile}} to know how to download files.
#' @param user_id Unique identifier of the target user.
#' @param offset (Optional). Sequential number of the first photo to be
#'     returned. By default, all photos are returned.
#' @param limit (Optional). Limits the number of photos to be retrieved. Values
#'     between 1-100 are accepted. Defaults to 100.
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' 
#' photos <- bot$getUserProfilePhotos(chat_id = chat_id)
#' }
getUserProfilePhotos <- function(user_id,
                                 offset = NULL,
                                 limit = 100L) {
  url <- sprintf("%s/getUserProfilePhotos", private$base_url)

  data <- list(user_id = user_id)

  if (!missing(offset)) {
    data[["offset"]] <- offset
  }
  if (!missing(limit)) {
    data[["limit"]] <- limit
  }

  result <- private$request(url, data)

  invisible(result)
}


#' Prepare a file for downloading
#'
#' Use this method to get basic info about a file and prepare it for
#' downloading. For the moment, bots can download files of up to 20MB in size.
#' It is guaranteed that the link will be valid for at least 1 hour. When the
#' link expires, a new one can be requested by calling \code{getFile} again.
#'
#' You can also use it's snake_case equivalent \code{get_file}.
#' @param file_id The file identifier.
#' @param destfile (Optional). If you want to save the file, pass by a
#'     character string with the name where the downloaded file is saved.
#'     See the \code{destfile} parameter from \code{?curl::curl_download} for
#'     further details.
#' @param ... (Optional). Additional parameters to be passed to
#'     \code{\link[curl]{curl_download}}. It is not used if \code{destfile} is
#'     \code{NULL}.
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' chat_id <- user_id("Me")
#' 
#' photos <- bot$getUserProfilePhotos(chat_id = chat_id)
#' 
#' # Download user profile photo
#' file_id <- photos$photos[[1L]][[1L]]$file_id
#' bot$getFile(file_id, destfile = "photo.jpg")
#' }
getFile <- function(file_id,
                    destfile = NULL, ...) { # nocov start
  url <- sprintf("%s/getFile", private$base_url)

  data <- list(file_id = file_id)

  result <- private$request(url, data)

  if (!is.null(destfile)) {
    file_url <- sprintf("%s/%s", private$base_file_url, result$file_path)
    curl::curl_download(file_url, destfile, ...)
  }

  invisible(result)
} # nocov end


#' Send answers to callback queries
#'
#' Use this method to send answers to callback queries sent from inline
#' keyboards. The answer will be displayed to the user as a notification at the
#' top of the chat screen or as an alert. On success, \code{TRUE} is returned.
#'
#' You can also use it's snake_case equivalent \code{answer_callback_query}.
#' @param callback_query_id Unique identifier for the query to be answered.
#' @param text (Optional). Text of the notification. If not specified, nothing
#'     will be shown to the user, 0-200 characters.
#' @param show_alert (Optional). If \code{TRUE}, an alert will be shown by the
#'     client instead of a notification at the top of the chat screen. Defaults
#'     to \code{FALSE}.
#' @param url (Optional). URL that will be opened by the user's client.
#' @param cache_time (Optional). The maximum amount of time in seconds that the
#'     result of the callback query may be cached client-side. Telegram apps
#'     will support caching starting in version 3.14. Defaults to 0.
answerCallbackQuery <- function(callback_query_id,
                                text = NULL,
                                show_alert = FALSE,
                                url = NULL,
                                cache_time = NULL) { # nocov start
  url_ <- sprintf("%s/answerCallbackQuery", private$base_url)

  data <- list(callback_query_id = callback_query_id)

  if (!missing(text)) {
    data[["text"]] <- text
  }
  if (!missing(show_alert)) {
    data[["show_alert"]] <- show_alert
  }
  if (!missing(url)) {
    data[["url"]] <- url
  }
  if (!missing(cache_time)) {
    data[["cache_time"]] <- cache_time
  }

  result <- private$request(url_, data)

  invisible(result)
} # nocov end


#' Send answers to an inline query
#'
#' Use this method to send answers to an inline query. No more than 50 results
#' per query are allowed.
#'
#' To enable this option, send the \code{/setinline} command to
#' \href{https://t.me/botfather}{@BotFather} and provide the placeholder text
#' that the user will see in the input field after typing your bot's name.
#'
#' You can also use it's snake_case equivalent \code{answer_inline_query}.
#' @param inline_query_id Unique identifier for the answered query.
#' @param results A list of \code{\link{InlineQueryResult}} for the inline
#'     query.
#' @param cache_time (Optional). The maximum amount of time in seconds that the
#'     result of the inline query may be cached on the server.
#' @param is_personal (Optional). Pass \code{TRUE}, if results may be cached on
#'     the server side only for the user that sent the query. By default,
#'     results may be returned to any user who sends the same query.
#' @param next_offset (Optional). Pass the offset that a client should send in
#'     the next query with the same text to receive more results. Pass an empty
#'     string if there are no more results or if you don't support pagination.
#'     Offset length can't exceed 64 bytes.
#' @param switch_pm_text (Optional). If passed, clients will display a button
#'     with specified text that switches the user to a private chat with the
#'     bot and sends the bot a start message with the parameter
#'     \code{switch_pm_parameter}.
#' @param switch_pm_parameter (Optional). Deep-linking parameter for the
#'     \code{/start} message sent to the bot when user presses the switch
#'     button. 1-64 characters, only \code{A-Z}, \code{a-z}, \code{0-9},
#'     \code{_} and \code{-} are allowed.
#'
#'     \emph{Example:} An inline bot that sends YouTube videos can ask the user
#'     to connect the bot to their YouTube account to adapt search results
#'     accordingly. To do this, it displays a 'Connect your YouTube account'
#'     button above the results, or even before showing any. The user presses
#'     the button, switches to a private chat with the bot and, in doing so,
#'     passes a start parameter that instructs the bot to return an auth link.
#'     Once done, the bot can offer a switch_inline button so that the user can
#'     easily return to the chat where they wanted to use the bot's inline
#'     capabilities.
answerInlineQuery <- function(inline_query_id,
                              results,
                              cache_time = 300L,
                              is_personal = NULL,
                              next_offset = NULL,
                              switch_pm_text = NULL,
                              switch_pm_parameter = NULL) { # nocov start
  url <- sprintf("%s/answerInlineQuery", private$base_url)

  results <- to_json(results)

  data <- list(inline_query_id = inline_query_id, results = results)

  if (!missing(cache_time)) {
    data[["cache_time"]] <- cache_time
  }
  if (!missing(is_personal)) {
    data[["is_personal"]] <- is_personal
  }
  if (!is.null(next_offset)) {
    data[["next_offset"]] <- next_offset
  }
  if (!missing(switch_pm_text)) {
    data[["switch_pm_text"]] <- switch_pm_text
  }
  if (!missing(switch_pm_parameter)) {
    data[["switch_pm_parameter"]] <- switch_pm_parameter
  }

  result <- private$request(url, data)

  invisible(result)
} # nocov end


#' Edit a reply markup
#'
#' Use this method to edit only the reply markup of messages sent by the bot or
#' via the bot (for inline bots).
#'
#' You can also use it's snake_case equivalent
#' \code{edit_message_reply_markup}.
#' @param chat_id (Optional). Unique identifier for the target chat or username
#'     of the target channel.
#' @param message_id (Optional). Required if inline_message_id is not
#'     specified. Identifier of the sent message.
#' @param inline_message_id (Optional). Required if chat_id and message_id are
#'     not specified. Identifier of the inline message.
#' @param reply_markup (Optional). A Reply Markup parameter object, it can be
#'     either:
#'     \itemize{
#'      \item{\code{\link{ReplyKeyboardMarkup}}}
#'      \item{\code{\link{InlineKeyboardMarkup}}}
#'      \item{\code{\link{ReplyKeyboardRemove}}}
#'      \item{\code{\link{ForceReply}}}}
editMessageReplyMarkup <- function(chat_id = NULL,
                                   message_id = NULL,
                                   inline_message_id = NULL,
                                   reply_markup = NULL) { # nocov start
  if (is.null(inline_message_id) & (is.null(chat_id) | is.null(message_id))) {
    stop(
      "Both `chat_id` and `message_id` are required ",
      "when `inline_message_id` is not specified."
    )
  }

  url <- sprintf("%s/editMessageReplyMarkup", private$base_url)

  data <- list()

  if (!missing(chat_id)) {
    data[["chat_id"]] <- chat_id
  }
  if (!missing(message_id)) {
    data[["message_id"]] <- message_id
  }
  if (!missing(inline_message_id)) {
    data[["inline_message_id"]] <- inline_message_id
  }
  if (!missing(reply_markup)) {
    data[["reply_markup"]] <- to_json(reply_markup)
  }

  result <- private$request(url, data)

  invisible(result)
} # nocov end


#' Receive incoming updates
#'
#' Use this method to receive incoming updates. It returns a
#' list of \code{\link{Update}} objects.
#'
#' 1. This method will not work if an outgoing webhook is set up.
#'
#' 2. In order to avoid getting duplicate updates, recalculate offset after
#' each server response or use \code{Bot} method \code{\link{clean_updates}}.
#'
#' 3. To take full advantage of this library take a look at
#' \code{\link{Updater}}.
#'
#' You can also use it's snake_case equivalent \code{get_updates}.
#' @param offset (Optional). Identifier of the first update to be returned
#'     returned.
#' @param limit (Optional). Limits the number of updates to be retrieved.
#'     Values between 1-100 are accepted. Defaults to 100.
#' @param timeout (Optional). Timeout in seconds for long polling. Defaults to
#'     0, i.e. usual short polling. Should be positive, short polling should
#'     be used for testing purposes only.
#' @param allowed_updates (Optional). String or vector of strings with the
#'     types of updates you want your bot to receive. For example, specify
#'     \code{c("message", "edited_channel_post", "callback_query")} to only
#'     receive updates of these types. See
#'     \href{https://core.telegram.org/bots/api#update}{Update}
#'     for a complete list of available update types. Specify an empty string
#'     to receive all updates regardless of type (default). If not specified,
#'     the previous setting will be used.
#'
#'     Please note that this parameter doesn't affect updates created before
#'     the call to the getUpdates, so unwanted updates may be received for a
#'     short period of time.
#' @examples
#' \dontrun{
#' bot <- Bot(token = bot_token("RTelegramBot"))
#' 
#' updates <- bot$getUpdates()
#' }
getUpdates <- function(offset = NULL,
                       limit = 100L,
                       timeout = 0L,
                       allowed_updates = NULL) {
  url <- sprintf("%s/getUpdates", private$base_url)

  data <- list(timeout = timeout)

  if (!missing(offset)) {
    data[["offset"]] <- offset
  }
  if (!missing(limit)) {
    data[["limit"]] <- limit
  }
  if (!missing(allowed_updates) && !is.null(allowed_updates)) {
    data[["allowed_updates"]] <- I(allowed_updates)
  }

  result <- private$request(url, data)

  invisible(lapply(result, function(u) Update(u)))
}


#' Set a webhook
#'
#' Use this method to specify a url and receive incoming updates via an
#' outgoing webhook. Whenever there is an update for the bot, we will send an
#' HTTPS POST request to the specified url, containing a JSON-serialized
#' \href{https://core.telegram.org/bots/api#update}{Update}.
#'
#' If you'd like to make sure that the webhook request comes from Telegram, we
#' recommend using a secret path in the URL, e.g.
#' \code{https://www.example.com/<token>}.
#'
#' You can also use it's snake_case equivalent \code{set_webhook}.
#' @param url HTTPS url to send updates to. Use an empty string to remove
#'     webhook integration.
#' @param certificate (Optional). Upload your public key certificate so that
#'     the root certificate in use can be checked. See Telegram's
#'     \href{https://core.telegram.org/bots/self-signed}{self-signed guide} for
#'     details.
#' @param max_connections (Optional). Maximum allowed number of simultaneous
#'     HTTPS connections to the webhook for update delivery, 1-100. Defaults to
#'     40. Use lower values to limit the load on your bot's server, and higher
#'     values to increase your bot's throughput.
#' @param allowed_updates (Optional). String or vector of strings with the
#'     types of updates you want your bot to receive. For example, specify
#'     \code{c("message", "edited_channel_post", "callback_query")} to only
#'     receive updates of these types. See
#'     \href{https://core.telegram.org/bots/api#update}{Update}
#'     for a complete list of available update types. Specify an empty string
#'     to receive all updates regardless of type (default). If not specified,
#'     the previous setting will be used.
#'
#'     Please note that this parameter doesn't affect updates created before
#'     the call to the get_updates, so unwanted updates may be received for a
#'     short period of time.
setWebhook <- function(url = NULL,
                       certificate = NULL,
                       max_connections = 40L,
                       allowed_updates = NULL) {
  url_ <- sprintf("%s/setWebhook", private$base_url)

  data <- list()

  if (!missing(url)) {
    data[["url"]] <- url
  }
  if (!missing(certificate)) {
    if (file.exists(certificate)) { # nocov
      data[["certificate"]] <- httr::upload_file(certificate) # nocov
    } else {
      data[["certificate"]] <- certificate # nocov
    }
  }
  if (!missing(max_connections)) {
    data[["max_connections"]] <- max_connections
  }
  if (!missing(allowed_updates) && !is.null(allowed_updates)) {
    data[["allowed_updates"]] <- I(allowed_updates)
  }

  result <- private$request(url_, data)

  invisible(result)
}


#' Remove webhook integration
#'
#' Use this method to remove webhook integration if you decide to switch back
#' to \code{getUpdates}. Requires no parameters.
#'
#' You can also use it's snake_case equivalent \code{delete_webhook}.
deleteWebhook <- function() {
  url <- sprintf("%s/deleteWebhook", private$base_url)

  data <- list()

  result <- private$request(url, data)

  invisible(result)
}


#' Get current webhook status
#'
#' Use this method to get current webhook status. Requires no parameters.
#'
#' If the bot is using \code{getUpdates}, will return an object with the url
#' field empty.
#'
#' You can also use it's snake_case equivalent \code{get_webhook_info}.
getWebhookInfo <- function() {
  url <- sprintf("%s/getWebhookInfo", private$base_url)

  data <- list()

  result <- private$request(url, data)

  invisible(result)
}

#' Leave a chat
#'
#' Use this method for your bot to leave a group, supergroup or channel.
#'
#' You can also use it's snake_case equivalent \code{leave_chat}.
#' @param chat_id Unique identifier for the target chat or username of
#'     the target channel.
leaveChat <- function(chat_id) { # nocov start
  url <- sprintf("%s/leaveChat", private$base_url)

  data <- list(chat_id = chat_id)

  result <- private$request(url, data)

  invisible(result)
} # nocov end


#### OTHER METHODS ####

#' Clean any pending updates
#'
#' Use this method to clean any pending updates on Telegram servers.
#' Requires no parameters.
clean_updates <- function() {
  updates <- self$get_updates()

  if (length(updates)) {
    self$get_updates(updates[[length(updates)]]$update_id + 1L) # nocov
  }

  invisible(NULL)
}


#' Change your bot's auth token
#'
#' Use this method to change your bot's auth token.
#' @param token The bot's token given by the \emph{BotFather}.
set_token <- function(token) {
  if (!missing(token)) {
    private$token <- token
  }

  invisible(NULL)
}


### CLASS ####

#' Creating a Bot
#'
#' This object represents a Telegram Bot.
#'
#' To take full advantage of this library take a look at \code{\link{Updater}}.
#'
#' You can also use its methods \code{snake_case} equivalent.
#' @section API Methods: \describe{
#'     \item{\code{\link{answerCallbackQuery}}}{Send
#'     answers to callback queries}
#'     \item{\code{\link{answerInlineQuery}}}{Send answers to an inline query}
#'     \item{\code{\link{deleteMessage}}}{Delete a message}
#'     \item{\code{\link{deleteWebhook}}}{Remove webhook integration}
#'     \item{\code{\link{editMessageReplyMarkup}}}{Edit the reply
#'     markup of a message}
#'     \item{\code{\link{forwardMessage}}}{Forward messages of any
#'     kind}
#'     \item{\code{\link{getFile}}}{Prepare a file for downloading}
#'     \item{\code{\link{getMe}}}{Check your bot's information}
#'     \item{\code{\link{getUpdates}}}{Receive incoming
#'     updates}
#'     \item{\code{\link{getUserProfilePhotos}}}{Get a user's profile photos}
#'     \item{\code{\link{getWebhookInfo}}}{Get current webhook status}
#'     \item{\code{\link{leaveChat}}}{Leave a chat}
#'     \item{\code{\link{sendAnimation}}}{Send animation files}
#'     \item{\code{\link{sendAudio}}}{Send audio files}
#'     \item{\code{\link{sendChatAction}}}{Send a chat action}
#'     \item{\code{\link{sendDocument}}}{Send general files}
#'     \item{\code{\link{sendLocation}}}{Send point on the map}
#'     \item{\code{\link{sendMessage}}}{Send text messages}
#'     \item{\code{\link{sendPhoto}}}{Send image files}
#'     \item{\code{\link{sendSticker}}}{Send a sticker}
#'     \item{\code{\link{sendVideo}}}{Send a video}
#'     \item{\code{\link{sendVideoNote}}}{Send video messages}
#'     \item{\code{\link{sendVoice}}}{Send voice files}
#'     \item{\code{\link{setWebhook}}}{Set a webhook}
#' }
#' @section Other Methods: \describe{
#'     \item{\code{\link{clean_updates}}}{Clean any pending updates}
#'     \item{\code{\link{set_token}}}{Change your bot's auth token}
#' }
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @param token The bot's token given by the \emph{BotFather}.
#' @param base_url (Optional). Telegram Bot API service URL.
#' @param base_file_url (Optional). Telegram Bot API file URL.
#' @param request_config (Optional). Additional configuration settings
#'     to be passed to the bot's POST requests. See the \code{config}
#'     parameter from \code{?httr::POST} for further details.
#'
#'     The \code{request_config} settings are very
#'     useful for the advanced users who would like to control the
#'     default timeouts and/or control the proxy used for HTTP communication.
#' @examples
#' \dontrun{
#' bot <- Bot(token = "TOKEN")
#' 
#' # In case you want to set a proxy (see ?httr:use_proxy)
#' bot <- Bot(
#'   token = "TOKEN",
#'   request_config = httr::use_proxy(...)
#' )
#' }
#' @export
Bot <- function(token,
                base_url = NULL,
                base_file_url = NULL,
                request_config = NULL) {
  BotClass$new(token, base_url, base_file_url, request_config)
}


BotClass <- R6::R6Class("Bot",
  inherit = TelegramObject,
  public = list(
    initialize = function(token, base_url, base_file_url, request_config) {
      private$token <- private$validate_token(token)

      if (is.null(base_url)) {
        base_url <- "https://api.telegram.org/bot"
      }
      if (is.null(base_file_url)) {
        base_file_url <- "https://api.telegram.org/file/bot"
      }
      if (is.null(request_config)) {
        request_config <- list()
      }

      private$base_url <- paste0(
        as.character(base_url),
        as.character(private$token)
      )
      private$base_file_url <- paste0(
        as.character(base_file_url),
        as.character(private$token)
      )
      private$request_config <- request_config
    },
    print = .print,

    # API Methods
    getMe = getMe,
    get_me = getMe,
    sendMessage = sendMessage,
    send_message = sendMessage,
    deleteMessage = deleteMessage,
    delete_message = deleteMessage,
    sendPhoto = sendPhoto,
    send_photo = sendPhoto,
    sendAudio = sendAudio,
    send_audio = sendAudio,
    sendDocument = sendDocument,
    send_document = sendDocument,
    sendSticker = sendSticker,
    send_sticker = sendSticker,
    sendVideo = sendVideo,
    send_video = sendVideo,
    sendVideoNote = sendVideoNote,
    send_video_note = sendVideoNote,
    sendAnimation = sendAnimation,
    send_animation = sendAnimation,
    sendVoice = sendVoice,
    send_voice = sendVoice,
    sendLocation = sendLocation,
    send_location = sendLocation,
    sendChatAction = sendChatAction,
    send_chat_action = sendChatAction,
    getUserProfilePhotos = getUserProfilePhotos,
    get_user_profile_photos = getUserProfilePhotos,
    getFile = getFile,
    get_file = getFile,
    answerCallbackQuery = answerCallbackQuery,
    answer_callback_query = answerCallbackQuery,
    answerInlineQuery = answerInlineQuery,
    answer_inline_query = answerInlineQuery,
    editMessageReplyMarkup = editMessageReplyMarkup,
    edit_message_reply_markup = editMessageReplyMarkup,
    getUpdates = getUpdates,
    get_updates = getUpdates,
    setWebhook = setWebhook,
    set_webhook = setWebhook,
    deleteWebhook = deleteWebhook,
    delete_webhook = deleteWebhook,
    getWebhookInfo = getWebhookInfo,
    get_webhook_info = getWebhookInfo,
    leaveChat = leaveChat,
    leave_chat = leaveChat,

    # Other Methods
    clean_updates = clean_updates,
    set_token = set_token
  ),
  private = list(
    # Params
    token = NULL,
    base_url = NULL,
    base_file_url = NULL,
    request_config = NULL,

    # Internal Methods
    validate_token = .validate_token,
    request = .request,
    parse = .parse
  )
)

#' @rdname Bot
#' @param x Object to be tested.
#' @export
is.Bot <- function(x) {
  inherits(x, "Bot")
}
