# telegram.bot

> Develop a Telegram Bot with R

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![CRAN](http://www.r-pkg.org/badges/version/telegram.bot)](https://cran.r-project.org/package=telegram.bot)
[![Travis CI Status](https://travis-ci.org/ebeneditos/telegram.bot.svg?branch=master)](https://travis-ci.org/ebeneditos/telegram.bot)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ebeneditos/telegram.bot?svg=true)](https://ci.appveyor.com/project/ebeneditos/telegram-bot)
[![Codecov](https://img.shields.io/codecov/c/github/ebeneditos/telegram.bot.svg)](https://codecov.io/gh/ebeneditos/telegram.bot)
[![License](https://img.shields.io/cran/l/telegram.bot.svg)](https://www.gnu.org/licenses/lgpl-3.0.html)
<!-- [![GitHub package version](https://img.shields.io/badge/dynamic/json.svg?label=dev&colorB=FFA500&prefix=&suffix=&query=$.version&uri=https://raw.githubusercontent.com/ebeneditos/telegram.bot/master/docs/codemeta.json)](http://www.r-pkg.org/pkg/telegram.bot) -->

This package features a number of tools to make the development of Telegram bots with R easy and straightforward, providing an easy-to-use interface that takes some work off the programmer. It is built on top of the pure API implementation, being an extension of the
[`telegram`](https://github.com/lbraglia/telegram) package, an R wrapper around the
[Telegram Bot API](http://core.telegram.org/bots/api).

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

Make sure you have the `devtools` package updated.

## Usage

The `telegram.bot` package is easy, fun and free to use! You can quickly build a chatbot with a few lines:

```r
library(telegram.bot)

hello <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = sprintf("Hello %s!", update$message$from$first_name))
}

updater <- Updater('YOUR TOKEN HERE')

updater$dispatcher$add_handler(CommandHandler('hello', hello))

updater$start_polling()
```

## Getting Started

To get you started with `telegram.bot`, we recommend to take a look at its [Wiki](https://github.com/ebeneditos/telegram.bot/wiki):

- [Introduction to the API](https://github.com/ebeneditos/telegram.bot/wiki/Introduction-to-the-API).
- Tutorial: [Building an R Bot in 3 steps](https://github.com/ebeneditos/telegram.bot/wiki/Tutorial-–-Building-an-R-Bot-in-3-steps).

You can also check these other resources:

- [Telegram Bot API Documentation](https://core.telegram.org/bots/api)
- [telegram.bot CRAN Documentation](https://cran.r-project.org/web/packages/telegram.bot/telegram.bot.pdf)

## Contributing

The package is in a starting phase, so contributions of all sizes are very welcome. Please:
- Review our [contribution guidelines](https://github.com/ebeneditos/telegram.bot/blob/master/.github/CONTRIBUTING.md) to get started.
- You can also help by [reporting bugs](https://github.com/ebeneditos/telegram.bot/issues/new).

## License

You may copy, distribute and modify the software provided that modifications are described and licensed for free under [LGPL-3](https://www.gnu.org/licenses/lgpl-3.0.html). Derivatives works (including modifications or anything statically linked to the package) can only be redistributed under LGPL-3, but applications that use the library don't have to be.

## Attribution

This package is inspired by Python's library
[`python-telegram-bot`](https://github.com/python-telegram-bot/python-telegram-bot), specially by its submodule `telegram.ext`.

