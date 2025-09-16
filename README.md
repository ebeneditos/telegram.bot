# telegram.bot

> Develop a Telegram Bot with R

[![CRAN](http://www.r-pkg.org/badges/version/telegram.bot)](https://cran.r-project.org/package=telegram.bot)
[![Monthly downloads](https://cranlogs.r-pkg.org/badges/telegram.bot)](https://www.r-pkg.org/pkg/telegram.bot)
[![Total downloads](https://cranlogs.r-pkg.org/badges/grand-total/telegram.bot)](https://www.r-pkg.org/pkg/telegram.bot)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ebeneditos/telegram.bot?svg=true)](https://ci.appveyor.com/project/ebeneditos/telegram-bot)
[![Codecov](https://codecov.io/gh/ebeneditos/telegram.bot/branch/master/graphs/badge.svg?branch=master)](https://app.codecov.io/gh/ebeneditos/telegram.bot)
[![License](https://img.shields.io/cran/l/telegram.bot.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

This package provides a pure R interface for the [Telegram Bot API](http://core.telegram.org/bots/api). In addition to the pure API implementation, it features a number of tools to make the development of Telegram bots with R easy and straightforward, providing an easy-to-use interface that takes some work off the programmer.

## Installation

You can install `telegram.bot` from CRAN:

``` r
install.packages("telegram.bot")
```

Or the development version from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("ebeneditos/telegram.bot")
```

## Usage

You can quickly build a chatbot with a few lines!

If you don't have an access token (`TOKEN`), please follow the steps explained 
[below](#generating-an-access-token) to generate one.

### Updater

`Updater` polls for new messages using the Telegram `getUpdates` API method and invokes 
your handlers when new messages are found.

Replace `TOKEN` with the access token you generated.

```r
library(telegram.bot)

start <- function(bot, update) {
  bot$sendMessage(
    chat_id = update$message$chat$id,
    text = sprintf("Hello %s!", update$message$from$first_name)
  )
}

updater <- Updater("TOKEN") + CommandHandler("start", start)

updater$start_polling() # Send "/start" to the bot
```

### Webhook

`Webhook` listens for messages POST'd to a webhook end-point URL, configured using the 
Telegram `setWebhook` API method, and invokes your handlers when new messages are received.

Note that this method requires a publicly accessible end-point which Telegram is able to access.

Replace `TOKEN` with the access token you generated and `https://example.com/webhook` with
your end-point's publicly accessible URL.

**Security Consideration**: It is recommended that you run the `Webhook` server behind a reverse 
proxy since it needs to be publicly accessible on the internet and thus needs to be secured.

```r
library(telegram.bot)

start <- function(bot, update) {
  bot$sendMessage(
    chat_id = update$message$chat$id,
    text = sprintf("Hello %s!", update$message$from$first_name)
  )
}

webhook <- Webhook("https://example.com/webhook", "TOKEN") + CommandHandler("start", start)

webhook$start_server() # Send "/start" to the bot
```

## Telegram API Methods

One of the core instances from the package is `Bot`, which represents a Telegram Bot. You can find a full list of the Telegram API methods implemented in its documentation (`?Bot`), but here there are some examples:

```r
# Initialize bot
bot <- Bot(token = "TOKEN")

# Get bot info
print(bot$getMe())

# Get updates
updates <- bot$getUpdates()

# Retrieve your chat id
# Note: you should text the bot before calling `getUpdates`
chat_id <- updates[[1L]]$from_chat_id()

# Send message
bot$sendMessage(chat_id,
  text = "foo *bold* _italic_",
  parse_mode = "Markdown"
)

# Send photo
bot$sendPhoto(chat_id,
  photo = "https://telegram.org/img/t_logo.png"
)

# Send audio
bot$sendAudio(chat_id,
  audio = "http://www.largesound.com/ashborytour/sound/brobob.mp3"
)

# Send document
bot$sendDocument(chat_id,
  document = "https://github.com/ebeneditos/telegram.bot/raw/gh-pages/docs/telegram.bot.pdf"
)

# Send sticker
bot$sendSticker(chat_id,
  sticker = "https://www.gstatic.com/webp/gallery/1.webp"
)

# Send video
bot$sendVideo(chat_id,
  video = "http://techslides.com/demos/sample-videos/small.mp4"
)

# Send gif
bot$sendAnimation(chat_id,
  animation = "https://media.giphy.com/media/sIIhZliB2McAo/giphy.gif"
)

# Send location
bot$sendLocation(chat_id,
  latitude = 51.521727,
  longitude = -0.117255
)

# Send chat action
bot$sendChatAction(chat_id,
  action = "typing"
)

# Get user profile photos
photos <- bot$getUserProfilePhotos(user_id = chat_id)

# Download user profile photo
file_id <- photos$photos[[1L]][[1L]]$file_id
bot$getFile(file_id, destfile = "photo.jpg")
```

Note that you can also send local files by passing their path instead of an URL. Additionally, all methods accept their equivalent `snake_case` syntax (e.g. `bot$get_me()` is equivalent to `bot$getMe()`).

## Generating an Access Token

To make it work, you'll need an access `TOKEN` (it should look something like `123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`). If you don't have it, you have to talk to [*@BotFather*](https://telegram.me/botfather) and follow a few simple steps (described [here](https://core.telegram.org/bots#6-botfather)).

**Recommendation:** Following [Hadley's API
guidelines](https://github.com/r-lib/httr/blob/master/vignettes/api-packages.Rmd#appendix-api-key-best-practices)
it's unsafe to type the `TOKEN` just in the R script. It's better to use
environment variables set in `.Renviron` file.

So let's say you have named your bot `RTelegramBot`; you can open the `.Renviron` file with the R command:

```r
file.edit(path.expand(file.path("~", ".Renviron")))
```

And put the following line with your `TOKEN` in your `.Renviron`:

```r
R_TELEGRAM_BOT_RTelegramBot=TOKEN
```
If you follow the suggested `R_TELEGRAM_BOT_` prefix convention you'll be able
to use the `bot_token` function (otherwise you'll have to get
these variable from `Sys.getenv`). Finally, **restart R** and you can then create the `Updater` object as:

```r
updater <- Updater(token = bot_token("RTelegramBot"))
```

## Getting Started

To get you started with `telegram.bot`, we recommend to take a look at its [Wiki](https://github.com/ebeneditos/telegram.bot/wiki):

- [Introduction to the API](https://github.com/ebeneditos/telegram.bot/wiki/Introduction-to-the-API).
- Tutorial: [Building an R Bot in 3 steps](https://github.com/ebeneditos/telegram.bot/wiki/Building-an-R-Bot-in-3-steps).

You can also check these other resources:

- [Telegram Bot API Documentation](https://core.telegram.org/bots/api)
- ['telegram.bot' CRAN Documentation](https://CRAN.R-project.org/package=telegram.bot/telegram.bot.pdf)

If you have any other doubt about the package, you can [post a question on Stack Overflow](https://stackoverflow.com/questions/ask) under the `r-telegram-bot` tag or directly [e-mail the package's maintainer](mailto:ebeneditos@gmail.com).

## Contributing

The package is in a starting phase, so contributions of all sizes are very welcome. Please:
- Review our [contribution guidelines](https://github.com/ebeneditos/telegram.bot/blob/master/.github/CONTRIBUTING.md) to get started.
- You can also help by [reporting bugs](https://github.com/ebeneditos/telegram.bot/issues/new).

## Attribution

This package is inspired by Python's library
[`python-telegram-bot`](https://github.com/python-telegram-bot/python-telegram-bot), specially by its submodule `telegram.ext`.
