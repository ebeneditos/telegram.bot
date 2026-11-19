#' Quick test for rich messages.
#'
#' Usage: Rscript rich_test.R <BOT_TOKEN>

library(telegram.bot)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Usage: Rscript rich_test.R <BOT_TOKEN>", call. = FALSE)
}
token <- args[[1]]

b <- Bot(token)

cat("Bot info:", b$getMe(), "\n")

updates <- b$getUpdates(limit = 5)
if (length(updates) == 0) {
  cat("No updates found yet. Send any message first, then re-run.\n")
  stop("No chat found", call. = FALSE)
}

# Find chat id from the most recent update
chat_id <- NULL
for (u in updates) {
  msg <- u$message
  if (!is.null(msg) && !is.null(msg$edited_message)) {
    chat_id <- msg$edited_message$chat$id
    break
  }
  if (!is.null(msg) && !is.null(msg$channel_post)) {
    chat_id <- msg$channel_post$chat.id
    break
  }
}
if (is.null(chat_id)) {
  # fallback: try channel post
  for (u in updates) {
    if (!is.null(u$channel_post)) {
      chat_id <- u$channel_post$chat.id
      break
    }
  }
}
if (is.null(chat_id)) {
  stop("Could not determine chat id from updates", call. = FALSE)
}
cat("Found chat id:", chat_id, "\n")

# Build a simple rich message
rm <- InputRichMessage(blocks = list(
  InputRichBlockSectionHeading(RichText("Hello from telegram.bot!"), size = 1L),
  InputRichBlockParagraph(RichText("This is a test rich message sent from R."))
))

cat("Sending rich message...\n")
resp <- b$sendRichMessage(chat_id = chat_id, rich_message = rm)
cat("Message sent. Message id:", resp$message_id, "\n")
