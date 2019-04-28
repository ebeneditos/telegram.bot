
## telegram.bot 2.3.1

- Bug affecting `reply_markup` parameter from `editMessageReplyMarkup()` fixed ([#9](https://github.com/ebeneditos/telegram.bot/issues/9)). Thanks to [Diogo Tayt-son](https://github.com/dtaytson) for reporting.

## telegram.bot 2.3.0

- Processing of updates through `Updater()` has been optimized.
- Bug affecting callback query answering fixed. Thanks to Nikita Strezhnev for reporting.

## telegram.bot 2.2.0

- New S3 methods:
  - `+` method for class `TelegramObject`, which eases the `Updater` construction (see [The *add* operator](https://github.com/ebeneditos/telegram.bot/wiki/The-add-operator)).
  - `!`, `&` and `|` methods for class `BaseFilter`, which enables combining filters (see [Advanced Filters](https://github.com/ebeneditos/telegram.bot/wiki/Advanced-Filters)).
- New `destfile` parameter for `getFile()` to download files to a local path.
- New `username` parameter for `CommandHandler()` with examples.
- New `ErrorHandler()` with examples.
- New `from_chat_id()` and `from_user_id()` methods for `Update()`.
- Vignettes update:
  - Added *The add operator*.
  - Substituted *Custom filters* vignette with *Advanced filters*.
- Minor bug fixes.

## telegram.bot 2.1.0

- Fixed a bug that affected sending local files.
- Renamed `Filters` for `MessageFilters` to avoid masking from `utils::Filters`.
- Added *Set a Proxy* vignette and examples.

## telegram.bot 2.0.0

- `Bot()` has been totally updated so to be independent from `TGBot`. Therefore, all its API methods have been implemented, optimized and updated (e.g. adding `timeout` argument  to `getUpdates()`, so to use Long Polling). Additionally, new methods have been added, the full list is:
    - `answerCallbackQuery()`
    - `answerInlineQuery()`
    - `deleteMessage()`
    - `deleteWebhook()`
    - `editMessageReplyMarkup()`
    - `forwardMessage()`
    - `getFile()`
    - `getMe()`
    - `getUpdates()`
    - `getUserProfilePhotos()`
    - `getWebhookInfo()`
    - `leaveChat()`
    - `sendAnimation()`
    - `sendAudio()`
    - `sendChatAction()`
    - `sendDocument()`
    - `sendLocation()`
    - `sendMessage()`
    - `sendPhoto()`
    - `sendSticker()`
    - `sendVideo()`
    - `sendVideoNote()`
    - `sendVoice()`
    - `setWebhook()`
- New parameter `reply_markup` from `sendMessage()` for keyboard displaying, with its objects:
    - `ReplyKeyboardMarkup`
    - `InlineKeyboardMarkup`
    - `ReplyKeyboardRemove`
    - `ForceReply`
- Support of inline mode with `answerInlineQuery()` and the `InlineQueryResult` object.
- New `request_config` parameter for `Bot()` and `Updater()`, which allows you to set additional configuration settings to be passed to the bot's POST requests, useful for users who would like to control the default timeouts and/or control the proxy used for HTTP communication.
- New `clean_updates()`, `set_token()`, `bot_token()` and `user_id()`.
- Vignettes added:
    - *Introduction*
    - *Building a Bot*
    - *Basic functionalities*
    - *Custom filters*
- LICENSE updated from LGPL-3 to GPL-3.
- Minor bug fixes.

## telegram.bot 1.0.0

- First release on CRAN.
