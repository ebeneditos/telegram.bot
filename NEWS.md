
## v2.3.0

- Update processing optimized.
- Bug affecting callback query answering fixed. Thanks to Nikita Strezhnev for reporting.
- Documentation update.

## v2.2.0

- New S3 methods:
  - Added `+` method for class `TelegramObject`, which eases the `Updater` construction (see [The *add* operator](https://github.com/ebeneditos/telegram.bot/wiki/The-add-operator)).
  - Added `!`, `&` and `|` methods for class `BaseFilter`, which enables combining filters (see [Advanced Filters](https://github.com/ebeneditos/telegram.bot/wiki/Advanced-Filters)).
- Added `destfile` parameter for `getFile` method to download files to a local path.
- Added `username` parameter for `CommandHandler` method with examples.
- Added `ErrorHandler` class with examples.
- Added `from_chat_id` and `from_user_id` methods for `Update` class.
- Vignettes update:
  - Added *The add operator*.
  - Substituted *Custom filters* vignette with *Advanced filters*.
- Minor bug fixes.
- Documentation updated.

## v2.1.0

- Fixed a bug that affected sending local files.
- Renamed `Filters` instance to `MessageFilters` in order to avoid masking from `utils::Filters` object.
- Added *Set a Proxy* vignette and examples.
- Documentation updated.

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
- Vignettes added:
    - *Introduction*
    - *Building a Bot*
    - *Basic functionalities*
    - *Custom filters*
- LICENSE update from LGPL-3 to GPL-3.
- Examples added for API methods and documentation updated.
- Other minor fixes.

## v1.0.0

- First release on CRAN.
