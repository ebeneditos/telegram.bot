
context("InlineQueryResult")

test_that("InlineQueryResult", {
  expect_true(is.InlineQueryResult(
    InlineQueryResult(
      type = "document",
      id = 1,
      title = "Documentation",
      document_url = paste0(
        "https://github.com/ebeneditos/telegram.bot/raw/",
        "gh-pages/docs/telegram.bot.pdf"
      ),
      mime_type = "application/pdf"
    )
  ))
})
