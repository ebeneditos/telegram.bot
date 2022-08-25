

#### METHODS ####

#' Start the webhook server.
#'
#' Starts the webhook for updates from Telegram. You can stop listening either by
#' using the RStudio's \code{interrupt R} command in the session menu or with the
#' \code{\link{stop_server}} method.
#'
#' @param host a string that is a valid IPv4 or IPv6 address that is owned by
#'     this server, which the application will listen on. "0.0.0.0" represents
#'     all IPv4 addresses and "::/0" represents all IPv6 addresses.
#'     Default is "127.0.0.1".
#' @param port a number or integer that indicates the server port that should
#'     be listened on. Note that on most Unix-like systems including Linux and
#'     Mac OS X, port numbers smaller than 1025 require root privileges.
#'     Default is 5001.
#' @param clean (Optional). Whether to clean any pending updates on Telegram
#'     servers before actually starting to poll. Default is \code{FALSE}.
#' @param blocking (Optional). Determines whether the method blocks whilst listening
#'     for updates from Telegram.
#'     Default is \code{TRUE}.
#'
#' @examples
#' \dontrun{
#' # Start webhook example
#' start <- function(bot, update) {
#'   bot$sendMessage(
#'     chat_id = update$message$chat_id,
#'     text = sprintf(
#'       "Hello %s!",
#'       update$message$from$first_name
#'     )
#'   )
#' }
#'
#' webhook <- Webhook("https://example.com/webhook", "TOKEN") + CommandHandler("start", start)
#'
#' webhook$start_server()
#' }
start_server <- function(host = "127.0.0.1",
                         port = 5001,
                         clean = FALSE,
                         blocking = TRUE) {
  if (!is.null(private$server)) {
    if (self$verbose) {
      cat("Webhook server already running.", fill = TRUE)
    }
    return(FALSE)
  }

  if (self$verbose) {
    cat("Starting webhook server...", fill = TRUE)
  }

  if (clean) {
    if (self$verbose) {
      cat("Cleaning updates from Telegram server", fill = TRUE)
    }
    self$bot$clean_updates()
  }

  # request handler
  handler <- function(req) {
    # NOTE: ignores path, querystring, etc...

    if (req$REQUEST_METHOD != "POST") {
      return(list(status = 400L, body = "Bad request"))
    }

    if (is.null(req$HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN)) {
      return(list(status = 400L, body = "Bad request"))
    }

    if (req$HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN != self$secret_token) {
      return(list(status = 401L, body = "Unauthorized"))
    }

    bodyRaw = req$rook.input$read()
    if (is.null(bodyRaw)) {
      return(list(status = 400L, body = "Bad request"))
    }

    bodyText <- rawToChar(bodyRaw)
    if (length(bodyText) != 0) {
      json <- tryCatch({
        jsonlite::parse_json(bodyText, simplifyVector = TRUE)
      },
      error = function(e) {
        if (self$verbose) {
          warning(as.character(e))
        }
        self$dispatcher$dispatch_error(e)
        return(NULL)
      })
      if (length(json) != 0) {
        update <- Update(json)
        if (self$verbose) {
          cat(sprintf("Processing Update %i", update$update_id), fill = TRUE)
        }
        self$dispatcher$process_update(update)
      } else {
        return(list(status = 400L, body = "Bad request"))
      }
    }

    return(list(status = 200L, body = "OK"))
  }

  result <- tryCatch({
    # start the server
    if (self$verbose) {
      cat(sprintf("Listening on '%s:%d'...", host, port), fill = TRUE)
    }
    private$server <-
      httpuv::startServer(host, port, list(call = handler))

    if (self$verbose) {
      cat(sprintf("Configuring webhook '%s'...", self$webhook_url), fill = TRUE)
    }
    self$bot$set_webhook(
      url = self$webhook_url,
      certificate = self$certificate,
      max_connections = self$max_connections,
      allowed_updates = self$allowed_updates,
      ip_address = self$ip_address,
      drop_pending_updates = self$drop_pending_updates,
      secret_token = self$secret_token
    )

    if (blocking) {
      if (self$verbose) {
        cat("Waiting for requests...", fill = TRUE)
      }
      httpuv::service(0)

      self$stop_server()
    }

    return(TRUE)
  },
  error = function(e) {
    if (self$verbose) {
      warning(as.character(e))
    }
    self$dispatcher$dispatch_error(e)
    return(e)
  })

  return(!is.error(result))
}

#' Stop the webhook server.
#'
#' Stops listening on the webhook. Requires no parameters.
#'
#' @examples
#' \dontrun{
#' # Example of a 'kill' command
#' kill <- function(bot, update) {
#'   bot$sendMessage(
#'     chat_id = update$message$chat_id,
#'     text = "Bye!"
#'   )
#'   # Stop the webhook
#'   webhook$stop_server()
#' }
#'
#' webhook <- Webhook("https://example.com/webhook", "TOKEN") + CommandHandler("start", start)
#'
#' webhook$start_server()
#' }
stop_server <- function() {
  if (is.null(private$server)) {
    if (self$verbose) {
      cat("Webhook server not running.", fill = TRUE)
    }
    return(FALSE)
  }

  result <- tryCatch({
    if (self$verbose) {
      cat("Removing webhook configuration...", fill = TRUE)
    }
    self$bot$delete_webhook()

    if (self$verbose) {
      cat("Stopping webhook server...", fill = TRUE)
    }
    private$server$stop()
    private$server <- NULL

    return(TRUE)
  },
  error = function(e) {
    if (self$verbose) {
      warning(as.character(e))
    }
    self$dispatcher$dispatch_error(e)
    e
  })

  return(!is.error(result))
}

#' Retrieve the status of the Webhook.
#'
#' Returns \code{TRUE} when listening for updates.
#'
running <- function() {
  return(!is.null(private$server))
}


#### CLASS ####

#' Building a Telegram Bot with a Webhook
#'
#' This class, which employs the class \code{\link{Dispatcher}}, provides a
#' front-end to class \code{\link{Bot}} to the programmer, so you can focus on
#' coding the bot. Its purpose is to receive updates via webhook from Telegram and
#' to deliver them to said dispatcher. The dispatcher supports
#' \code{\link{Handler}} classes for different kinds of data: Updates from
#' Telegram, basic text commands and even arbitrary types. See
#' \code{\link{add}} (\code{+}) to learn more about building your \code{Webhook}.
#'
#' You \strong{must} supply the \code{webhook_url} and either a \code{bot}
#' or a \code{token} argument.
#'
#' The \code{webhook_url} must be publicly accessible, since Telegram will
#' need to make HTTP \code{POST} requests to the end-point for each update.
#'
#' \strong{Security Note}: \code{Webhook} encapsulates generating a \code{secret_token} which
#' is used to validate that the request comes from a webhook set by you.
#'
#' @format An \code{\link{R6Class}} object.
#' @name Webhook
#' @param webhook_url Webhook HTTPS url to send updates to. The url is conventionally
#'     suffixed with the \code{/webhook} path.
#'
#'     \strong{Note}: The url must be publicly accessible, since Telegram will need to make
#'     HTTP \code{POST} requests to the end-point for each update.
#'
#'     For example, if you are deploying to Heroku, you can use the app's hostname,
#'     such as \code{https://[name of app].herokuapp.com/webhook}, or a
#'     \href{https://devcenter.heroku.com/articles/custom-domains}{custom hostname}
#'     for a domain that belongs to you, such as \code{https://app.yourcustomdomain.com/webhook}.
#' @param token (Optional). The bot's token given by the \emph{BotFather}.
#' @param base_url (Optional). Telegram Bot API service URL.
#' @param base_file_url (Optional). Telegram Bot API file URL.
#' @param request_config (Optional). Additional configuration settings
#'     to be passed to the bot's POST requests. See the \code{config}
#'     parameter from \code{httr::POST} for further details.
#'
#'     The \code{request_config} settings are very
#'     useful for the advanced users who would like to control the
#'     default timeouts and/or control the proxy used for HTTP communication.
#' @param certificate (Optional). Upload your public key certificate so that
#'     the root certificate in use can be checked. See Telegram's
#'     \href{https://core.telegram.org/bots/self-signed}{self-signed guide} for
#'     details.
#' @param max_connections (Optional). Maximum allowed number of simultaneous
#'     HTTPS connections to the webhook for update delivery, 1-100. Defaults to
#'     40. Use lower values to limit the load on your bot's server, and higher
#'     values to increase your bot's throughput.
#' @param allowed_updates (Optional). String or vector of strings with the
#'     types of updates you want your bot to receive. For example, specify
#'     \code{c("message", "edited_channel_post", "callback_query")} to only
#'     receive updates of these types. See
#'     \href{https://core.telegram.org/bots/api#update}{Update}
#'     for a complete list of available update types. Specify an empty string
#'     to receive all updates regardless of type (default). If not specified,
#'     the previous setting will be used.
#'
#'     Please note that this parameter doesn't affect updates created before
#'     the call to the get_updates, so unwanted updates may be received for a
#'     short period of time.
#' @param ip_address (Optional). The fixed IP address which will be used to
#'     send webhook requests instead of the IP address resolved through DNS.
#' @param drop_pending_updates (Optional). Pass True to drop all pending updates.
#' @param verbose (Optional). If \code{TRUE}, prints status of the polling.
#'     Default is \code{FALSE}.
#' @param bot (Optional). A pre-initialized \code{\link{Bot}} instance.
#'
#' @section Methods: \describe{
#'     \item{\code{\link{start_server}}}{Starts listening for updates from
#'       Telegram.}
#'     \item{\code{\link{stop_server}}}{Stops listening for updates.}
#'     \item{\code{\link{running}}}{Returns \code{TRUE} when listening for updates.}
#' }
#' @references \href{https://core.telegram.org/bots}{Bots: An introduction for developers},
#'     \href{https://core.telegram.org/bots/api}{Telegram Bot API} and
#'     \href{https://core.telegram.org/bots/webhooks}{Marvin's Marvellous Guide to All Things Webhook}
#' @examples
#' \dontrun{
#' webhook <- Webhook("https://example.com/webhook", "TOKEN")
#'
#' # In case you want to set a proxy
#' webhook <- Webhook(
#'   webhook_url = "https://example.com/webhook",
#'   token = "TOKEN",
#'   request_config = httr::use_proxy(...),
#'   verbose = TRUE
#' )
#'
#' # Add a handler
#' start <- function(bot, update) {
#'   bot$sendMessage(
#'     chat_id = update$message$chat_id,
#'     text = sprintf(
#'       "Hello %s!",
#'       update$message$from$first_name
#'     )
#'   )
#' }
#' webhook <- webhook + CommandHandler("start", start)
#'
#' # Start polling
#' webhook$start_server() # Send '/start' to the bot
#' }
#' @export
Webhook <- function(webhook_url,
                    token = NULL,
                    base_url = NULL,
                    base_file_url = NULL,
                    request_config = NULL,
                    certificate = NULL,
                    max_connections = NULL,
                    allowed_updates = NULL,
                    ip_address = NULL,
                    drop_pending_updates = FALSE,
                    verbose = FALSE,
                    bot = NULL) {
  WebhookClass$new(
    webhook_url,
    token,
    base_url,
    base_file_url,
    request_config,
    certificate,
    max_connections,
    allowed_updates,
    ip_address,
    drop_pending_updates,
    verbose,
    bot
  )
}


WebhookClass <- R6::R6Class(
  "Webhook",
  inherit = TelegramObject,
  cloneable = FALSE,
  public = list(
    initialize = function(webhook_url,
                          token,
                          base_url,
                          base_file_url,
                          request_config,
                          certificate,
                          max_connections,
                          allowed_updates,
                          ip_address,
                          drop_pending_updates,
                          verbose,
                          bot) {
      if (is.null(webhook_url) || webhook_url == "") {
        stop("`webhook_url` must be passed.")
      }
      if (is.null(token) && is.null(bot)) {
        stop("`token` or `bot` must be passed.")
      }
      if (!is.null(token) && !is.null(bot)) {
        stop("`token` and `bot` are mutually exclusive.")
      }

      if (!is.null(bot)) {
        if (is.Bot(bot)) {
          self$bot <- bot
        } else {
          stop("`bot` must be an instance of `Bot`.")
        }
      } else {
        self$bot <- Bot(token, base_url, base_file_url, request_config)
      }

      self$webhook_url <- webhook_url
      self$certificate <- certificate
      self$max_connections <- max_connections
      self$allowed_updates <- allowed_updates
      self$ip_address <- ip_address
      self$drop_pending_updates <- drop_pending_updates
      self$verbose <- verbose

      # generate random secret
      bytes <- openssl::rand_bytes(18)
      self$secret_token <- paste0(bytes, collapse = "")

      self$dispatcher <- Dispatcher(self$bot)
    },

    # Methods
    start_server = start_server,
    stop_server = stop_server,
    running = running,

    # Params
    bot = NULL,
    webhook_url = NULL,
    certificate = NULL,
    max_connections = NULL,
    allowed_updates = NULL,
    ip_address = NULL,
    drop_pending_updates = NULL,
    verbose = FALSE,
    secret_token = NULL,
    dispatcher = NULL
  ),
  private = list(
    server = NULL
  )
)

#' @rdname Webhook
#' @param x Object to be tested.
#' @export
is.Webhook <- function(x) {
  inherits(x, "Webhook")
}
