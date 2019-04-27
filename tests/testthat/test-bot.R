
context("Bot")

bot <- Bot(token = token)

test_that("Initialize", {

  # invalid token 1
  expect_error(Bot(token = " "), "Invalid `token`.")

  # invalid token 2
  expect_error(Bot(token = "123456ABCDEF"), "Invalid `token`.")

  # print
  expect_error(print(bot), NA)
})

test_that("Get Updates", {
  skip_if_offline(bot)

  expect_is(bot$get_updates(
    offset = 0,
    limit = 100,
    allowed_updates = ""
  ), "list")
})

test_that("Send Message", {
  skip_if_offline(bot)

  expect_is(bot$send_message(
    chat_id = chat_id,
    text = foo_text,
    parse_mode = "Markdown",
    disable_web_page_preview = NULL,
    disable_notification = FALSE,
    reply_to_message_id = NULL,
    reply_markup = NULL
  ), "list")
})

test_that("Send Photo", {
  skip_if_offline(bot)

  expect_is(bot$send_photo(
    chat_id = chat_id,
    photo = "https://telegram.org/img/t_logo.png",
    caption = "Telegram Logo",
    disable_notification = FALSE,
    reply_to_message_id = NULL,
    reply_markup = NULL,
    parse_mode = NULL
  ), "list")
})

test_that("Send Audio", {
  skip_if_offline(bot)

  expect_is(bot$sendAudio(
    chat_id = chat_id,
    audio = "http://www.largesound.com/ashborytour/sound/brobob.mp3",
    duration = NULL,
    performer = NULL,
    title = NULL,
    caption = NULL,
    disable_notification = FALSE,
    reply_to_message_id = NULL,
    reply_markup = NULL,
    parse_mode = NULL
  ), "list")
})

test_that("Send Document", {
  skip_if_offline(bot)

  expect_is(bot$sendDocument(
    chat_id = chat_id,
    document = paste0(
      "https://github.com/ebeneditos/telegram.bot/raw/",
      "gh-pages/docs/telegram.bot.pdf"
    ),
    filename = NULL,
    caption = NULL,
    disable_notification = FALSE,
    reply_to_message_id = NULL,
    reply_markup = NULL,
    parse_mode = NULL
  ), "list")
})

test_that("Send Sticker", {
  skip_if_offline(bot)

  expect_is(bot$sendSticker(
    chat_id = chat_id,
    sticker = "https://www.gstatic.com/webp/gallery/1.webp",
    disable_notification = FALSE,
    reply_to_message_id = NULL,
    reply_markup = NULL
  ), "list")
})

test_that("Send Video", {
  skip_if_offline(bot)

  expect_is(bot$sendVideo(
    chat_id = chat_id,
    video = "http://techslides.com/demos/sample-videos/small.mp4",
    duration = NULL,
    caption = NULL,
    disable_notification = FALSE,
    reply_to_message_id = NULL,
    reply_markup = NULL,
    width = NULL,
    height = NULL,
    parse_mode = NULL,
    supports_streaming = NULL
  ), "list")
})

test_that("Send Video Note", {
  skip_if_offline(bot)

  expect_is(bot$sendVideoNote(
    chat_id = chat_id,
    video_note = "http://techslides.com/demos/sample-videos/small.mp4",
    duration = NULL,
    length = NULL,
    disable_notification = FALSE,
    reply_to_message_id = NULL,
    reply_markup = NULL
  ), "list")
})

test_that("Send Animation", {
  skip_if_offline(bot)

  expect_is(bot$sendAnimation(
    chat_id = chat_id,
    animation = "https://media.giphy.com/media/sIIhZliB2McAo/giphy.gif",
    duration = NULL,
    width = NULL,
    height = NULL,
    caption = NULL,
    parse_mode = NULL,
    disable_notification = FALSE,
    reply_to_message_id = NULL,
    reply_markup = NULL
  ), "list")
})

test_that("Send Voice", {
  skip_if_offline(bot)

  expect_is(bot$sendVoice(
    chat_id = chat_id,
    voice = "https://upload.wikimedia.org/wikipedia/commons/c/c8/Example.ogg",
    duration = NULL,
    caption = NULL,
    disable_notification = FALSE,
    reply_to_message_id = NULL,
    reply_markup = NULL,
    parse_mode = NULL
  ), "list")
})

test_that("Send Location", {
  skip_if_offline(bot)

  expect_is(bot$sendLocation(
    chat_id = chat_id,
    latitude = 51.521727,
    longitude = -0.117255,
    disable_notification = FALSE,
    reply_to_message_id = NULL,
    reply_markup = NULL
  ), "list")
})

test_that("Send Chat Action", {
  skip_if_offline(bot)

  expect_true(bot$sendChatAction(
    chat_id = chat_id,
    action = "typing"
  ))
})

test_that("Get User Profile Photos", {
  skip_if_offline(bot)

  expect_is(bot$getUserProfilePhotos(
    user_id = chat_id,
    offset = NULL,
    limit = 1000
  ), "list")
})

test_that("Clean Updates", {
  skip_if_offline(bot)

  expect_null(bot$clean_updates())
})

test_that("Set Token", {
  expect_null(bot$set_token(token = token))
})

test_that("Webhooks", {
  skip_if_offline(bot)

  # set_webhook
  expect_true(bot$set_webhook(
    url = "",
    max_connections = 40,
    allowed_updates = ""
  ))

  # get_webhook_info
  expect_is(bot$get_webhook_info(), "list")

  # delete_webhook
  expect_true(bot$delete_webhook())

  # finish webhook
  expect_true(bot$set_webhook())
})
