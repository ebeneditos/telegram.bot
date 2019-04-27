
context("Update")

update <- Update(foo_update)

test_that("Effective User", {
  expect_equal(update$effective_user(), foo_update$message$from)
})

test_that("Effective User ID", {
  expect_equal(update$from_user_id(), foo_update$message$from$id)
  expect_equal(update$from_user_id(), foo_update$message$from$id)
})

test_that("Effective Chat", {
  expect_equal(update$effective_chat(), foo_update$message$chat)
})

test_that("Effective Chat ID", {
  expect_equal(update$from_chat_id(), foo_update$message$chat$id)
  expect_equal(update$from_chat_id(), foo_update$message$chat$id)
})

test_that("Effective Message", {
  expect_equal(
    update$effective_message()[names(foo_update$message)],
    foo_update$message
  )
})
