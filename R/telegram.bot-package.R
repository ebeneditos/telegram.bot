#' telegram.bot
#'
#' Provides a pure interface for the \href{http://core.telegram.org/bots/api}{Telegram Bot API}.
#' In addition to the pure API implementation, it features a number of
#' tools to make the development of Telegram bots with R easy and
#' straightforward, providing an easy-to-use interface that takes some
#' work off the programmer.
#' 
#' In \href{https://ebeneditos.github.io/telegram.bot/}{this page}
#' you can learn how to build a Bot quickly with this package.
#' 
#' @section Main Classes: \describe{
#'     \item{\code{\link{Updater}}}{Package main class. This class,
#'         which employs the class \code{\link{Dispatcher}}, provides a front-end to
#'         class \code{\link{Bot}} to the programmer, so they can focus on coding the bot.
#'         Its purpose is to receive the updates from Telegram and to deliver them to said
#'         dispatcher.}
#'     \item{\code{\link{Dispatcher}}}{This class dispatches all kinds of updates to its
#'         registered handlers.}
#'     \item{\code{\link{Handler}}}{The base class for all update handlers.}
#'     \item{\code{\link{Bot}}}{This object represents a Telegram Bot.}
#' }
#' 
#' @name telegram.bot
#' @docType package
#' @importFrom R6 R6Class
#' @importFrom httr POST
#' @importFrom httr content
#' @importFrom httr stop_for_status
#' @importFrom httr upload_file
#' @importFrom jsonlite toJSON
NULL
