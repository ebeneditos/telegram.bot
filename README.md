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
devtools::install_github("ebeneditos/telegram.bot", ref = "dev")
```

Make sure you have the `devtools` package updated.

## Usage

The `telegram.bot` package is easy, fun and free to use! You can quickly build a chatbot with a few lines:

```r
library(telegram.bot)

start <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = sprintf("Hello %s!", update$message$from$first_name))
}

updater <- Updater('YOUR TOKEN HERE')

updater$dispatcher$add_handler(CommandHandler('start', start))

updater$start_polling()
```

## Getting Started

To get you started with `telegram.bot`, we recommend to take a look at its [Wiki](https://github.com/ebeneditos/telegram.bot/wiki):

- [Introduction to the API](https://github.com/ebeneditos/telegram.bot/wiki/Introduction-to-the-API).
- Tutorial: [Building an R Bot in 3 steps](https://github.com/ebeneditos/telegram.bot/wiki/Tutorial-–-Building-an-R-Bot-in-3-steps).

You can also check these other resources:

- [Telegram Bot API Documentation](https://core.telegram.org/bots/api)
- ['telegram.bot' CRAN Documentation](https://cran.r-project.org/web/packages/telegram.bot/telegram.bot.pdf)

## Contributing

The package is in a starting phase, so contributions of all sizes are very welcome. Please:
- Review our [contribution guidelines](https://github.com/ebeneditos/telegram.bot/blob/master/.github/CONTRIBUTING.md) to get started.
- You can also help by [reporting bugs](https://github.com/ebeneditos/telegram.bot/issues/new).

## Attribution

This package is inspired by Python's library
[`python-telegram-bot`](https://github.com/python-telegram-bot/python-telegram-bot), specially by its submodule `telegram.ext`.

