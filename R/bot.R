
#### METHODS ####

#' get_updates
#'
#' Use this method to receive incoming updates using long polling.
#'
#' 1. This method will not work if an outgoing webhook is set up.
#' 2. In order to avoid getting duplicate updates, recalculate offset after each
#' server response.
#' 3. To take full advantage of this library take a look at \code{\link{Updater}}.
#' @param offset Identifier of the first update to be returned
#'     returned.
#' @param limit Limits the number of updates to be retrieved. Values
#'     between 1-100 are accepted. Defaults to 100.
#' @param timeout Timeout in seconds for long polling. Defaults to 0,
#'     i.e. usual short polling. Should be positive, short polling should
#'     be used for testing purposes only.
get_updates <- function(offset = NULL,
                       limit = 100,
                       timeout = 0)
{
  url <- sprintf('%s/getUpdates', private$base_url)

  data <- list(timeout = timeout)

  if (!missing(offset))
    data[['offset']] <- offset
  if (!missing(limit))
    data[['limit']] <- limit

  result <- private$request_post(url, data)

  return(lapply(result, function(u) Update(u)))
}


### CLASS ####

#' Bot
#'
#' This object represents a Telegram Bot. It inherits from \code{\link{TGBot}}.
#' Thus, it has immplemented all the API methods from that class. It also features
#' the \code{\link{get_updates}} method, which allows the use of long polling.
#'
#' To take full advantage of this library take a look at \code{\link{Updater}}.
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @param token Bot's unique authentication.
#' @param base_url Telegram Bot API service URL.
#' @param base_file_url Telegram Bot API file URL.
#' @examples \dontrun{
#' bot <- Bot(token = 'TOKEN')
#' }
#' @export
Bot <- function(token, base_url = NULL, base_file_url = NULL){
  BotClass$new(token, base_url, base_file_url)
}


BotClass <-
  R6::R6Class("Bot", inherit = TGBot,
              public = list(

                ## initialize
                initialize =
                  function(token, base_url, base_file_url){

                    private$token <- private$validate_token(token)

                    if (is.null(base_url))
                      base_url <- 'https://api.telegram.org/bot'
                    if (is.null(base_file_url))
                      base_file_url <- 'https://api.telegram.org/file/bot'

                    private$base_url <- paste0(as.character(base_url),
                                               as.character(private$token))
                    private$base_file_url <- paste0(as.character(base_file_url),
                                                         as.character(private$token))

                },
                
                print = function(){
                  obj <- objects(self)
                  api_methods <- obj[grepl("[A-Z]", obj)]
                  dont_show <- c("clone", "initialize", "print")
                  avail_methods <- sort(api_methods[api_methods %in% obj])
                  remaining_methods <- sort(obj[! obj %in% avail_methods])
                  remaining_methods <- remaining_methods[!(remaining_methods %in% dont_show)]
                  api_string <- method_summaries(avail_methods, indent = 4)
                  remaining_string <- method_summaries(remaining_methods, indent = 4)
                  
                  ret <- paste0("<", class(self)[1], ">")
                  
                  # If there's another class besides first class and R6
                  classes <- setdiff(class(self), "R6")
                  if (length(classes) >= 2) {
                    ret <- c(ret, paste0("  Inherits from: <", classes[2], ">"))
                  }
                  
                  ret <- c(ret,
                           "  API Methods:",
                           api_string
                  )
                  ret <- c(ret,
                           "  Other Methods:",
                           remaining_string
                  )
                  
                  cat(paste(ret, collapse = "\n"), sep = "\n")
                },

                ## methods
                get_updates  = get_updates

              ),
              private = list(

                ## args
                token = NULL,
                base_url = NULL,
                base_file_url = NULL,

                ## methods

                # A very basic validation on token.
                validate_token = function(token){

                  if (grepl(' ', token))
                    stop('invalid token.')

                  split <- strsplit(token, ':')[[1]]
                  if (length(split) < 2 ||
                      split[2] == '' ||
                      grepl("\\D", split[1]) ||
                      nchar(split[1]) < 3)
                    stop('invalid token.')

                  token
                },

                # Request an URL.
                request_post = function(url, data){
                  result <- httr::POST(url = url, body = data)
                  httr::stop_for_status(result)

                  if (result$status >= 200 && result$status <= 299){
                    # 200-299 range are HTTP success statuses
                    return(private$parse(result))
                  }
                  else
                    stop('HTTPError')
                },

                parse = function(result){

                  data <- try(httr::content(result, as = 'parsed', encoding = 'UTF-8'))

                  if (is.list(data) && data$ok){
                    return(data$result)
                  }
                  else
                    stop('Invalid server response')
                }
              )
)
