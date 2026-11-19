#' Create a rich formatted text
#'
#' A rich formatted text can be either a string for plain text, or an array of
#' \code{\link{RichText}} entities.
#'
#' @param text The text (string) or a list of \code{\link{RichText}} entities
#' @export
RichText <- function(text) {
  if (is.character(text)) {
    structure(text, class = "RichText")
  } else if (is.list(text)) {
    structure(text, class = "RichText")
  } else {
    stop("`text` must be a string or a list of RichText entities.")
  }
}

#' @rdname RichText
#' @param x Object to be tested
#' @export
is.RichText <- function(x) inherits(x, "RichText")