
#' The base of inline query results
#'
#' Baseclass for the InlineQueryResult* classes.
#'
#' @param type Type of the result. See the
#'   \href{https://core.telegram.org/bots/api#inlinequeryresult}{documentation}
#'   for a list of supported types.
#' @param id Unique identifier for this result, 1-64 Bytes.
#' @param ... Additional parameters for the selected type. See the
#'   \href{https://core.telegram.org/bots/api#inlinequeryresult}{documentation}
#'   for the description of the
#'   parameters depending on the \code{InlineQueryResult} type.
#' @examples
#' \dontrun{
#' document_url <- paste0(
#'   "https://github.com/ebeneditos/telegram.bot/raw/gh-pages/docs/",
#'   "telegram.bot.pdf"
#' )
#' 
#' result <- InlineQueryResult(
#'   type = "document",
#'   id = 1,
#'   title = "Documentation",
#'   document_url = document_url,
#'   mime_type = "application/pdf"
#' )
#' }
#' @export
InlineQueryResult <- function(type,
                              id,
                              ...) {
  params <- list(...)

  InlineQueryResult <- c(
    list(
      type = as.character(type),
      id = as.character(id)
    ),
    params
  )

  structure(InlineQueryResult, class = "InlineQueryResult")
}

#' @rdname InlineQueryResult
#' @param x Object to be tested.
#' @export
is.InlineQueryResult <- function(x) {
  inherits(x, "InlineQueryResult")
}
