
context("Update")

update <- Update(foo_update)

test_that("Effective User", {
  
  expect_equal(update$effective_user(), foo_update$message$from_user)
  
})

test_that("Effective Chat", {
  
  expect_equal(update$effective_chat(), foo_update$message$chat)
  
})

test_that("Effective Message", {
  
  expect_equal(update$effective_message()[names(foo_update$message)], foo_update$message)
  
})
