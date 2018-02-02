# telegram.ext

> Develop a Telegram Bot with R

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![GitHub package version](https://img.shields.io/badge/dynamic/json.svg?label=dev&colorB=FFA500&prefix=&suffix=&query=$.version&uri=https://raw.githubusercontent.com/ebeneditos/telegram.ext/master/docs/codemeta.json)](http://www.r-pkg.org/pkg/telegram.ext)
[![Travis CI Status](https://travis-ci.org/ebeneditos/telegram.ext.svg?branch=master)](https://travis-ci.org/ebeneditos/telegram.ext)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ebeneditos/telegram.ext?svg=true)](https://ci.appveyor.com/project/ebeneditos/telegram-ext)
[![Codecov](https://img.shields.io/codecov/c/github/ebeneditos/telegram.ext.svg)](https://codecov.io/gh/ebeneditos/telegram.ext)
[![License](https://img.shields.io/badge/license-LGLP--3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0.html)

This package features a number of tools to make the development of Telegram bots with R easy and straightforward, providing an easy-to-use interface that takes some work off the programmer. It is built on top of the pure API implementation, being an extension of the
[`telegram`](https://github.com/lbraglia/telegram) package, an R wrapper around the
[Telegram Bot API](http://core.telegram.org/bots/api).

## Installation

You can install `telegram.ext` from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("ebeneditos/telegram.ext")
```

Make sure you have the `devtools` package updated.

## Getting started

To get started with `telegram.ext`, you can check these resources:

- [Introduction to the API](https://github.com/ebeneditos/telegram.ext/wiki/Introduction-to-the-API).
- Tutorial: [Building an R Bot in 3 steps](https://github.com/ebeneditos/telegram.ext/wiki/Tutorial-–-Building-an-R-Bot-in-3-steps).

## Contributing

The package is in a starting phase, so contributions of all sizes are very welcome. Please:
- Review our [contribution guidelines](https://github.com/ebeneditos/telegram.ext/blob/master/.github/CONTRIBUTING.md) to get started.
- You can also help by [reporting bugs](https://github.com/ebeneditos/telegram.ext/issues/new).

## License

You may copy, distribute and modify the software provided that modifications are described and licensed for free under [LGPL-3](https://www.gnu.org/licenses/lgpl-3.0.html). Derivatives works (including modifications or anything statically linked to the package) can only be redistributed under LGPL-3, but applications that use the library don't have to be.

## Attribution

This package is inspired by Python's library
[`python-telegram-bot`](https://github.com/python-telegram-bot/python-telegram-bot), specially by its submodule `telegram.ext`.

