# telegram.ext

> Building a Telegram Bot with R

This package features a number of tools to make the development of Telegram bots with R easy and straightforward.
It is an extension of the 
[`telegram`](https://github.com/lbraglia/telegram) package, an R wrapper around the
[Telegram Bot API](http://core.telegram.org/bots/api); and it is inspired by Python's submodule `telegram.ext` from the
[`python-telegram-bot`](https://github.com/python-telegram-bot/python-telegram-bot) library.

## Installing

It is compatible with `telegram` package's version [`0.6.2-dev`](https://github.com/ebeneditos/telegram), which allows the use of Long Polling.
This version is being revised in order to update the stable version, so for the moment you can download its developers version with:

```r
devtools::install_github('ebeneditos/telegram')
```

Then you can download the `telegram.ext` developers version:

```r
devtools::install_github('ebeneditos/telegram.ext')
```

Make sure you have the `devtools` package updated.

## Getting started

To get started with `telegram.ext`, you can check these resources:

- [Introduction to `telegram`](https://github.com/lbraglia/telegram#telegram).
- Tutorial: [Your first R Bot in 5 steps](https://github.com/ebeneditos/telegram.ext/wiki/Tutorial-–-Your-first-R-Bot-in-5-steps).

## Contributing

The package is in a starting phase, so contributions of all sizes are very welcome. Please:
- Review our [contribution guidelines](https://github.com/ebeneditos/telegram.ext/blob/master/CONTRIBUTING.md) to get started.
- You can also help by [reporting bugs](https://github.com/ebeneditos/telegram.ext/issues/new).

## License

You may copy, distribute and modify the software provided that modifications are described and licensed for free under [LGPL-3](https://www.gnu.org/licenses/lgpl-3.0.html). Derivatives works (including modifications or anything statically linked to the package) can only be redistributed under LGPL-3, but applications that use the library don't have to be.
