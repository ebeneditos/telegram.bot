
context("Bot")

bot <- Bot(token = token)

test_that("Initialize", {
  
  skip_if_offline(bot)
  
  # invalid token 1
  expect_error(Bot(token = ' '), 'invalid token.')
  
  # invalid token 2
  expect_error(Bot(token = '123456ABCDEF'), 'invalid token.')
  
  # print
  expect_error(print(bot), NA)
  
  # get_updates
  expect_is(bot$get_updates(offset = 0, limit = 100, allowed_updates = ''), 'list')
  
  # set_webhook
  expect_true(bot$set_webhook(url = '', max_connections = 40, allowed_updates = ''))
  
  # get_webhook_info
  expect_is(bot$get_webhook_info(), 'list')
  
  # delete_webhook
  expect_true(bot$delete_webhook())
  
  # finish webhook
  expect_true(bot$set_webhook())
  
})

test_that("Get Updates", {
  
  skip_if_offline(bot)
  
  expect_is(bot$get_updates(offset = 0, limit = 100, allowed_updates = ''), 'list')
  
})

test_that("Clean Updates", {
  
  skip_if_offline(bot)
  
  expect_null(bot$clean_updates())
  
})

test_that("Webhooks", {
  
  skip_if_offline(bot)
  
  # set_webhook
  expect_true(bot$set_webhook())
  
  # get_webhook_info
  expect_is(bot$get_webhook_info(), 'list')
  
  # delete_webhook
  expect_true(bot$delete_webhook())

})
