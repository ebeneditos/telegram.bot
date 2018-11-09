
context('InlineQueryResult')

test_that("InlineQueryResult", {
  
  expect_is(InlineQueryResult(
      type = "document",
      id = 1,
      title = "Documentation",
      document_url = "https://cran.rstudio.com/web/packages/telegram.bot/telegram.bot.pdf",
      mime_type = "application/pdf"),
    'InlineQueryResult')
  
})
