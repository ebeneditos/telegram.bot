
#### METHODS ####

#' get_updates
#'
#' Use this method to receive incoming updates using long polling.
#'
#' 1. This method will not work if an outgoing webhook is set up.
#' 
#' 2. In order to avoid getting duplicate updates, recalculate offset after each
#' server response.
#' 
#' 3. To take full advantage of this library take a look at \code{\link{Updater}}.
#' 
#' @param offset (Optional). Identifier of the first update to be returned
#'     returned.
#' @param limit (Optional). Limits the number of updates to be retrieved. Values
#'     between 1-100 are accepted. Defaults to 100.
#' @param timeout (Optional). Timeout in seconds for long polling. Defaults to 0,
#'     i.e. usual short polling. Should be positive, short polling should
#'     be used for testing purposes only.
#' @param allowed_updates (Optional). String or vector of strings with the types of
#'     updates you want your bot to receive. For example, specify \code{c("message",
#'     "edited_channel_post", "callback_query")} to only receive updates of these types. See
#'     \href{https://core.telegram.org/bots/api#update}{Update}
#'     for a complete list of available update types. Specify an empty string to receive all
#'     updates regardless of type (default). If not specified, the previous setting will be used.
#'     
#'     Please note that this parameter doesn't affect updates created before the call
#'     to the get_updates, so unwanted updates may be received for a short period of time.
get_updates <- function(offset = NULL,
                       limit = 100,
                       timeout = 0,
                       allowed_updates = NULL)
{
  url <- sprintf('%s/getUpdates', private$base_url)

  data <- list(timeout = timeout)

  if (!missing(offset))
    data[['offset']] <- offset
  if (!missing(limit))
    data[['limit']] <- limit
  if (!missing(allowed_updates) && !is.null(allowed_updates))
    data[['allowed_updates']] <- I(allowed_updates)

  result <- private$request_post(url, data)

  return(lapply(result, function(u) Update(u)))
}


#' clean_updates
#' 
#' Use this method to clean any pending updates on Telegram servers.
#' Requires no parameters.
clean_updates = function(){
  
  updates <- self$get_updates()
  
  if (length(updates))
    updates <- self$get_updates(updates[[length(updates)]]$update_id + 1)
}


#' set_webhook
#'
#' Use this method to specify a url and receive incoming updates via an outgoing webhook.
#' Whenever there is an update for the bot, we will send an HTTPS POST request to the
#' specified url, containing a JSON-serialized
#' \href{https://core.telegram.org/bots/api#update}{Update}.
#'
#' If you'd like to make sure that the Webhook request comes from Telegram, we recommend
#' using a secret path in the URL, e.g. \code{https://www.example.com/<token>}.
#' 
#' @param url HTTPS url to send updates to. Use an empty string to remove webhook
#'     integration.
#' @param certificate (Optional). Upload your public key certificate so that the root
#'     certificate in use can be checked. See Telegram's
#'     \href{https://core.telegram.org/bots/self-signed}{self-signed guide} for details.
#' @param max_connections (Optional). Maximum allowed number of simultaneous HTTPS
#'     connections to the webhook for update delivery, 1-100. Defaults to 40. Use lower
#'     values to limit the load on your bot's server, and higher values to increase your
#'     bot's throughput.
#' @param allowed_updates (Optional). String or vector of strings with the types of
#'     updates you want your bot to receive. For example, specify \code{c("message",
#'     "edited_channel_post", "callback_query")} to only receive updates of these types. See
#'     \href{https://core.telegram.org/bots/api#update}{Update}
#'     for a complete list of available update types. Specify an empty string to receive all
#'     updates regardless of type (default). If not specified, the previous setting will be used.
#'     
#'     Please note that this parameter doesn't affect updates created before the call
#'     to the get_updates, so unwanted updates may be received for a short period of time.
set_webhook <- function(url = NULL,
                        certificate = NULL,
                        max_connections = 40,
                        allowed_updates = NULL)
{
  url_ <- sprintf('%s/setWebhook', private$base_url)
  
  data <- list()
  
  if (!missing(url))
    data[['url']] <- url
  if (!missing(certificate) && check_file(certificate))
    data[['certificate']] <- httr::upload_file(certificate)
  if (!missing(max_connections))
    data[['max_connections']] <- max_connections
  if (!missing(allowed_updates) && !is.null(allowed_updates))
    data[['allowed_updates']] <- I(allowed_updates)
  
  result <- private$request_post(url_, data)
  
  return(result)
}


#' delete_webhook
#'
#' Use this method to remove webhook integration if you decide to switch back to
#' \code{getUpdates}. Requires no parameters.
delete_webhook <- function()
{
  url <- sprintf('%s/deleteWebhook', private$base_url)
  
  data <- list()
  
  result <- private$request_post(url, data)
  
  return(result)
}


#' get_webhook_info
#'
#' Use this method to get current webhook status. Requires no parameters.
#' 
#' If the bot is using \code{getUpdates}, will return an object with the url field empty.
get_webhook_info <- function()
{
  url <- sprintf('%s/getWebhookInfo', private$base_url)
  
  data <- list()
  
  result <- private$request_post(url, data)
  
  return(result)
}


### CLASS ####

#' Bot
#'
#' This object represents a Telegram Bot. It inherits from \code{\link{TGBot}}.
#' Thus, it has implemented all the API methods from that class. It also features
#' the \code{\link{get_updates}} method, which allows the use of long polling; and
#' the \code{\link{set_webhook}}, \code{\link{delete_webhook}} and
#' \code{\link{get_webhook_info}} methods, which allow to manage webhooks.
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
                get_updates  = get_updates,
                clean_updates = clean_updates,
                set_webhook = set_webhook,
                delete_webhook = delete_webhook,
                get_webhook_info = get_webhook_info

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
                  result <- httr::POST(url = url, body = data, encode = 'json')
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
