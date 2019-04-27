
context("ReplyMarkup")

test_that("Reply Markup", {
  expect_type(ReplyKeyboardMarkup(
    keyboard = list(
      list(KeyboardButton("Yes, they certainly are!")),
      list(KeyboardButton("I'm not quite sure")),
      list(KeyboardButton("No..."))
    ),
    resize_keyboard = FALSE,
    one_time_keyboard = TRUE
  ), "list")

  expect_error(
    ReplyKeyboardMarkup(foo_text),
    paste(
      "`keyboard` must be a list of button rows, each represented by a list",
      "of `KeyboardButton` objects."
    )
  )

  expect_type(InlineKeyboardMarkup(
    inline_keyboard = list(
      list(
        InlineKeyboardButton(1),
        InlineKeyboardButton(2),
        InlineKeyboardButton(3)
      ),
      list(
        InlineKeyboardButton(4),
        InlineKeyboardButton(5),
        InlineKeyboardButton(6)
      ),
      list(
        InlineKeyboardButton(7),
        InlineKeyboardButton(8),
        InlineKeyboardButton(9)
      ),
      list(
        InlineKeyboardButton("*"),
        InlineKeyboardButton(0),
        InlineKeyboardButton("#")
      )
    )
  ), "list")

  expect_error(
    InlineKeyboardMarkup(foo_text),
    paste(
      "`inline_keyboard` must be a list of button rows, each represented by",
      "a list of `KeyboardButton` objects."
    )
  )

  expect_error(
    InlineKeyboardButton(foo_text, foo_text, foo_text),
    "You must use exactly one of the optional fields."
  )

  expect_type(ReplyKeyboardRemove(), "list")

  expect_type(ForceReply(), "list")
})
