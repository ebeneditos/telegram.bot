# telegram.bot

> Develop a Telegram Bot with R

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![CRAN](http://www.r-pkg.org/badges/version/telegram.bot)](https://cran.r-project.org/package=telegram.bot)
[![Downloads](https://cranlogs.r-pkg.org/badges/telegram.bot)](https://www.r-pkg.org/pkg/telegram.bot)
[![Travis CI Status](https://travis-ci.org/ebeneditos/telegram.bot.svg?branch=master)](https://travis-ci.org/ebeneditos/telegram.bot)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ebeneditos/telegram.bot?svg=true)](https://ci.appveyor.com/project/ebeneditos/telegram-bot)
[![Codecov](https://img.shields.io/codecov/c/github/ebeneditos/telegram.bot.svg)](https://codecov.io/gh/ebeneditos/telegram.bot)
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

You can quickly build a chatbot with a few lines:

```r
library(telegram.bot)

start <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = sprintf("Hello %s!", update$message$from$first_name))
}

updater <- Updater("TOKEN") + CommandHandler("start", start)

updater$start_polling() # Send '/start' to the bot
```

If you don't have a `TOKEN`, you can follow the steps explained [below](#generating-an-access-token) to generate one.

## Telegram API Methods

One of the core instances from the package is `Bot`, which represents a Telegram Bot. You can find a full list of the Telegram API methods implemented in its documentation (`?Bot`), but here there are some examples:

```r
# Initialize bot
bot <- Bot(token = "TOKEN")
chat_id <- "CHAT_ID" # you can retrieve it from bot$getUpdates() after sending a message to the bot

# Get bot info
print(bot$getMe())

# Get updates
updates <- bot$getUpdates()

# Send message
bot$sendMessage(chat_id = chat_id,
                text = "foo *bold* _italic_",
                parse_mode = "Markdown")

# Send photo
bot$sendPhoto(chat_id = chat_id,
               photo = "https://telegram.org/img/t_logo.png")

# Send audio
bot$sendAudio(chat_id = chat_id,
              audio = "http://www.largesound.com/ashborytour/sound/brobob.mp3")

# Send document
bot$sendDocument(chat_id = chat_id,
                 document = "https://github.com/ebeneditos/telegram.bot/raw/gh-pages/docs/telegram.bot.pdf")

# Send sticker
bot$sendSticker(chat_id = chat_id,
                sticker = "https://www.gstatic.com/webp/gallery/1.webp")

# Send video
bot$sendVideo(chat_id = chat_id,
              video = "http://techslides.com/demos/sample-videos/small.mp4")

# Send gif
bot$sendAnimation(chat_id = chat_id,
                  animation = "https://media.giphy.com/media/sIIhZliB2McAo/giphy.gif")

# Send location
bot$sendLocation(chat_id = chat_id,
                 latitude = 51.521727,
                 longitude = -0.117255)

# Send chat action
bot$sendChatAction(chat_id = chat_id,
                   action = "typing")

# Get user profile photos
photos <- bot$getUserProfilePhotos(user_id = chat_id)

# Download user profile photo
file_id <- photos$photos[[1L]][[1L]]$file_id
bot$getFile(file_id, destfile = "photo.jpg")
```

Note that you can also send local files by passing their path instead of an URL. Additionaly, all methods accept their equivalent `snake_case` syntax (e.g. `bot$get_me()` is equivalent to `bot$getMe()`).

## Generating an Access Token

To make it work, you'll need an access `TOKEN` (it should look something like `123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`). If you don't have it, you have to talk to [*@BotFather*](https://telegram.me/botfather) and follow a few simple steps (described [here](https://core.telegram.org/bots#6-botfather)).

**Recommendation:** Following [Hadley's API
guidelines](http://github.com/hadley/httr/blob/master/vignettes/api-packages.Rmd#appendix-api-key-best-practices)
it's unsafe to type the `TOKEN` just in the R script. It's better to use
enviroment variables set in `.Renviron` file.

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
