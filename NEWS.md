# telegram.bot 3.0.2

- Added `web_app` argument to `InlineKeyboardButton`, `KeyboardButton` and related markup functions
- Allows passing URL or object to open a Telegram Mini App directly from inline or reply keyboard buttons. Thanks to Alexey Seleznev for updating
- Added support for Rich Messages (Bot API 10.1+):
    - New constructors for rich formatted text:
        - `RichText` base class and 26 subclasses: `RichTextBold`, `RichTextItalic`, `RichTextUnderline`, `RichTextStrikethrough`, `RichTextSpoiler`, `RichTextDateTime`, `RichTextTextMention`, `RichTextSubscript`, `RichTextSuperscript`, `RichTextMarked`, `RichTextCode`, `RichTextCustomEmoji`, `RichTextMathematicalExpression`, `RichTextUrl`, `RichTextEmailAddress`, `RichTextPhoneNumber`, `RichTextBankCardNumber`, `RichTextTonAddress`, `RichTextMention`, `RichTextHashtag`, `RichTextCashtag`, `RichTextBotCommand`, `RichTextAnchor`, `RichTextAnchorLink`, `RichTextReference`, `RichTextReferenceLink`
        - `RichMessageButton` with support for URL, callback data, login, web apps, inline queries and other types
    - New constructors for rich blocks:
        - `RichBlock` base and 25 block types: `RichBlockParagraph`, `RichBlockSectionHeading`, `RichBlockPreformatted`, `RichBlockFooter`, `RichBlockDivider`, `RichBlockMathematicalExpression`, `RichBlockAnchor`, `RichBlockList`, `RichBlockListItem`, `RichBlockBlockQuotation`, `RichBlockExpandableBlockQuotation`, `RichBlockPullQuotation`, `RichBlockCollage`, `RichBlockSlideshow`, `RichBlockTable`, `RichBlockTableCell`, `RichBlockDetails`, `RichBlockMap`, `RichBlockButtons`, `RichBlockAnimation`, `RichBlockAudio`, `RichBlockDocument`, `RichBlockPhoto`, `RichBlockVideo`, `RichBlockVoiceNote`, `RichBlockThinking`
        - `RichMessage` combining blocks with `is_rtl` support
    - New input constructors for sending:
        - `InputRichMessage` with blocks/html/markdown/media/is_rtl/skip_entity_detection
        - `InputRichMessageMedia`
        - `InputRichBlock*` types mirroring output blocks
    - New `Bot` methods:
        - `sendRichMessage()` with `rich_message` parameter, support for chat threads, ephemeral messages, and rich formatting
        - `sendRichMessageDraft()` for streaming partial rich messages
        - Both methods have snake_case equivalents (`send_rich_message()`, `send_rich_message_draft()`)
    - Fixed test helper validation of empty TOKEN (now correctly checks for invalid token, not message content)
    - Added comprehensive test coverage for all rich message types

## telegram.bot 3.0.1

- Updated Rd files following target package anchors guidelines

## telegram.bot 3.0.0

- Added Webhook functionality introducing `Webhook` class
- Extended `set_webhook()` method to include `ip_address`, `drop_pending_updates` and `secret_token` parameters
- Added tests for Webhook functionality
- Updated documentation

## telegram.bot 2.4.1

- Included `forwardMessage` in `Bot` class methods
    
## telegram.bot 2.4.0

- New methods have been added to `Bot` class:
    - `editMessageText()`
    - `editMessageCaption()`

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
