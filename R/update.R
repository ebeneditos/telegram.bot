
#### METHODS ####

#' Get an update's chat ID
#'
#' Get the \code{id} from the \code{\link{Update}}'s effective chat.
from_chat_id <- function() {
  if (!is.null(private$.from_chat_id)) {
    return(private$.from_chat_id)
  }

  from_chat_id <- self$effective_chat()$id

  private$.from_chat_id <- from_chat_id

  from_chat_id
}


#' Get an update's user ID
#'
#' Get the \code{id} from the \code{\link{Update}}'s effective user.
from_user_id <- function() {
  if (!is.null(private$.from_user_id)) {
    return(private$.from_user_id)
  }

  from_user_id <- self$effective_user()$id

  private$.from_user_id <- from_user_id

  from_user_id
}


#' Get the effective chat
#'
#' The chat that this update was sent in, no matter what kind of
#' update this is. Will be \code{None} for \code{inline_query},
#' \code{chosen_inline_result}, \code{callback_query} from inline messages,
#' \code{shipping_query} and \code{pre_checkout_query}.
effective_chat <- function() { # nocov start

  if (!is.null(private$.effective_chat)) {
    return(private$.effective_chat)
  }

  chat <- NULL

  if (!is.null(self$message)) {
    chat <- self$message$chat
  } else if (!is.null(self$edited_message)) {
    chat <- self$edited_message$chat
  } else if (!is.null(self$callback_query) &&
    !is.null(self$callback_query$message)) {
    chat <- self$callback_query$message$chat
  } else if (!is.null(self$channel_post)) {
    chat <- self$channel_post$chat
  } else if (!is.null(self$edited_channel_post)) {
    chat <- self$edited_channel_post$chat
  }

  private$.effective_chat <- chat

  chat
} # nocov end


#' Get the effective user
#'
#' The user that sent this update, no matter what kind of update this
#' is. Will be \code{NULL} for \code{channel_post}.
effective_user <- function() { # nocov start

  if (!is.null(private$.effective_user)) {
    return(private$.effective_user)
  }

  user <- NULL

  if (!is.null(self$message)) {
    user <- self$message$from
  } else if (!is.null(self$edited_message)) {
    user <- self$edited_message$from
  } else if (!is.null(self$inline_query)) {
    user <- self$inline_query$from
  } else if (!is.null(self$chosen_inline_result)) {
    user <- self$chosen_inline_result$from
  } else if (!is.null(self$callback_query)) {
    user <- self$callback_query$from
  } else if (!is.null(self$shipping_query)) {
    user <- self$shipping_query$from
  } else if (!is.null(self$pre_checkout_query)) {
    user <- self$pre_checkout_query$from
  }

  private$.effective_user <- user

  user
} # nocov end


#' Get the effective message
#'
#' The message included in this update, no matter what kind of
#' update this is. Will be \code{None} for \code{inline_query},
#' \code{chosen_inline_result}, \code{callback_query} from inline messages,
#' \code{shipping_query} and \code{pre_checkout_query}.
effective_message <- function() { # nocov start

  if (!is.null(private$.effective_message)) {
    return(private$.effective_message)
  }

  message <- NULL

  if (!is.null(self$message)) {
    message <- self$message
  } else if (!is.null(self$edited_message)) {
    message <- self$edited_message
  } else if (!is.null(self$callback_query)) {
    message <- self$callback_query$message
  } else if (!is.null(self$channel_post)) {
    message <- self$channel_post
  } else if (!is.null(self$edited_channel_post)) {
    message <- self$edited_channel_post
  }

  private$.effective_message <- message

  message
} # nocov end


### CLASS ####

#' Represent an update
#'
#' This object represents an incoming
#' \href{https://core.telegram.org/bots/api#update}{Update}.
#'
#' @docType class
#' @format An \code{\link{R6Class}} object.
#' @param data Data of the update.
#' @section Methods: \describe{
#'     \item{\code{\link{from_chat_id}}}{To get the \code{id} from the update's
#'     effective chat.}
#'     \item{\code{\link{from_user_id}}}{To get the \code{id} from the update's
#'     effective user.}
#'     \item{\code{\link{effective_chat}}}{To get the chat that this
#'     update was sent in, no matter what kind of update this is.}
#'     \item{\code{\link{effective_user}}}{To get the user that sent
#'     this update, no matter what kind of update this is.}
#'     \item{\code{\link{effective_message}}}{To get the message
#'     included in this update, no matter what kind of  update this is.}}
#' @export
Update <- function(data) {
  UpdateClass$new(data)
}


UpdateClass <- R6::R6Class("Update",
  public = list(
    initialize = function(data) {
      self$update_id <- as.numeric(data$update_id)
      self$message <- data$message
      self$edited_message <- data$edited_message
      self$inline_query <- data$inline_query
      self$chosen_inline_result <- data$chosen_inline_result
      self$callback_query <- data$callback_query
      self$shipping_query <- data$shipping_query
      self$pre_checkout_query <- data$pre_checkout_query
      self$channel_post <- data$channel_post
      self$edited_channel_post <- data$edited_channel_post
      if (!is.null(self$message)) {
        self$message$chat_id <- self$message$chat$id
        self$message$from_user <- self$message$from$id
      }
    },

    # Methods
    effective_user = effective_user,
    effective_chat = effective_chat,
    effective_message = effective_message,
    from_chat_id = from_chat_id,
    from_user_id = from_user_id,

    # Params
    update_id = NULL,
    message = NULL,
    edited_message = NULL,
    inline_query = NULL,
    chosen_inline_result = NULL,
    callback_query = NULL,
    shipping_query = NULL,
    pre_checkout_query = NULL,
    channel_post = NULL,
    edited_channel_post = NULL
  ),
  private = list(
    .effective_user = NULL,
    .effective_chat = NULL,
    .effective_message = NULL,
    .from_chat_id = NULL,
    .from_user_id = NULL
  )
)

#' @rdname Update
#' @param x Object to be tested.
#' @export
is.Update <- function(x) {
  inherits(x, "Update")
}
