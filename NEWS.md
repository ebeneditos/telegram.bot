
## v2.0.0

- The `Bot` instance has been totally updated so to be independent from `TGBot`. Therefore, all its API methods have been implemented, optimized and updated (e.g. adding `timeout` argument  to the `getUpdates` function, so to use Long Polling). Additionaly, new methods have been added, the full list is:
    - answerCallbackQuery
    - answerInlineQuery
    - deleteMessage
    - deleteWebhook
    - editMessageReplyMarkup
    - forwardMessage
    - getFile
    - getMe
    - getUpdates
    - getUserProfilePhotos
    - getWebhookInfo
    - leaveChat
    - sendAnimation
    - sendAudio
    - sendChatAction
    - sendDocument
    - sendLocation
    - sendMessage
    - sendPhoto
    - sendSticker
    - sendVideo
    - sendVideoNote
    - sendVoice
    - setWebhook
- Keyboard displaying, which includes parameter `reply_markup` from `sendMessage` function with its objects:
    - ReplyKeyboardMarkup
    - InlineKeyboardMarkup
    - ReplyKeyboardRemove
    - ForceReply
- Support of inline mode with the `answerInlineQuery` method and the `InlineQueryResult` object.
- New `request_config` parameter for `Bot` and `Updater` instances, which allows you to set additional configuration settings to be passed to the bot's POST requests, useful for users who would like to control the default timeouts and/or control the proxy used for http communication.
- New functions such as `clean_updates`, `set_token`, `bot_token` and `user_id` (the last 3 inspired by the ones with same name from `telegram`).
- Vignettes added.
- LICENSE update from LGPL-3 to GPL-3.
- Examples added for API methods and documentation updated.
- Other minor fixes.

## v1.0.0

- First release on CRAN.
