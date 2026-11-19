context("Rich messages")

test_that("RichText constructors", {
  expect_type(RichText("plain text"), "character")
  expect_true(is.RichText(RichText("plain text")))

  expect_type(RichTextBold(RichText("bold")), "list")
  expect_true(is.RichTextBold(RichTextBold(RichText("bold"))))

  expect_type(RichTextItalic(RichText("italic")), "list")
  expect_true(is.RichTextItalic(RichTextItalic(RichText("italic"))))

  expect_type(RichTextUnderline(RichText("underline")), "list")
  expect_true(is.RichTextUnderline(RichTextUnderline(RichText("underline"))))

  expect_type(RichTextStrikethrough(RichText("strike")), "list")
  expect_true(is.RichTextStrikethrough(RichTextStrikethrough(RichText("strike"))))

  expect_type(RichTextSpoiler(RichText("spoiler")), "list")
  expect_true(is.RichTextSpoiler(RichTextSpoiler(RichText("spoiler"))))

  expect_type(RichTextCode(RichText("code")), "list")
  expect_true(is.RichTextCode(RichTextCode(RichText("code"))))

  expect_type(RichTextMarked(RichText("marked")), "list")
  expect_true(is.RichTextMarked(RichTextMarked(RichText("marked"))))

  expect_type(RichTextSubscript(RichText("sub")), "list")
  expect_true(is.RichTextSubscript(RichTextSubscript(RichText("sub"))))

  expect_type(RichTextSuperscript(RichText("sup")), "list")
  expect_true(is.RichTextSuperscript(RichTextSuperscript(RichText("sup"))))

  expect_type(RichTextDateTime(RichText("time"), 1647531900L, "wDT"), "list")
  expect_true(is.RichTextDateTime(RichTextDateTime(RichText("time"), 1647531900L, "wDT")))

  expect_type(RichTextUrl(RichText("url"), "https://t.me/"), "list")
  expect_true(is.RichTextUrl(RichTextUrl(RichText("url"), "https://t.me/")))

  expect_type(RichTextEmailAddress(RichText("mail"), "a@t.me"), "list")
  expect_true(is.RichTextEmailAddress(RichTextEmailAddress(RichText("mail"), "a@t.me")))

  expect_type(RichTextPhoneNumber(RichText("tel"), "+123456789"), "list")
  expect_true(is.RichTextPhoneNumber(RichTextPhoneNumber(RichText("tel"), "+123456789")))

  expect_type(RichTextBankCardNumber(RichText("card"), "4242 4242 4242 4242"), "list")
  expect_true(is.RichTextBankCardNumber(RichTextBankCardNumber(RichText("card"), "4242 4242 4242 4242")))

  expect_type(RichTextMention(RichText("user"), "username"), "list")
  expect_true(is.RichTextMention(RichTextMention(RichText("user"), "username")))

  expect_type(RichTextHashtag(RichText("#tag")), "list")
  expect_true(is.RichTextHashtag(RichTextHashtag(RichText("#tag"))))

  expect_type(RichTextCashtag(RichText("$USD")), "list")
  expect_true(is.RichTextCashtag(RichTextCashtag(RichText("$USD"))))

  expect_type(RichTextBotCommand(RichText("/start")), "list")
  expect_true(is.RichTextBotCommand(RichTextBotCommand(RichText("/start"))))

  expect_type(RichTextCustomEmoji("5368324170671202286", "👍"), "list")
  expect_true(is.RichTextCustomEmoji(RichTextCustomEmoji("5368324170671202286", "👍")))

  expect_type(RichTextMathematicalExpression(RichText("x^2")), "list")
  expect_true(is.RichTextMathematicalExpression(RichTextMathematicalExpression(RichText("x^2"))))

  expect_type(RichTextAnchor("chapter-1"), "list")
  expect_true(is.RichTextAnchor(RichTextAnchor("chapter-1")))

  expect_type(RichTextAnchorLink(RichText("link"), "chapter-1"), "list")
  expect_true(is.RichTextAnchorLink(RichTextAnchorLink(RichText("link"), "chapter-1")))

  expect_type(RichTextReference(RichText("ref"), "note-1"), "list")
  expect_true(is.RichTextReference(RichTextReference(RichText("ref"), "note-1")))

  expect_type(RichTextReferenceLink(RichText("ref-link"), "note-1"), "list")
  expect_true(is.RichTextReferenceLink(RichTextReferenceLink(RichText("ref-link"), "note-1")))

  button <- RichMessageButton(RichText("Click"), url = "https://t.me")
  expect_type(RichTextButton(button), "list")
  expect_true(is.RichTextButton(RichTextButton(button)))

  expect_error(RichText(1), "`text` must be a string or a list")
})

test_that("RichMessage and RichMessageButton", {
  blocks <- list(RichBlockParagraph(RichText("Hello")))
  expect_type(RichMessage(blocks), "list")
  expect_true(is.RichMessage(RichMessage(blocks)))

  btn <- RichMessageButton(RichText("Click"), url = "https://t.me")
  expect_type(btn, "list")
  expect_true(is.RichMessageButton(btn))

  expect_error(
    RichMessageButton(RichText("x"), style = "invalid"),
    "`style` must be one of"
  )
})

test_that("RichBlock constructors", {
  expect_type(RichBlockParagraph(RichText("p")), "list")
  expect_true(is.RichBlockParagraph(RichBlockParagraph(RichText("p"))))

  expect_type(RichBlockSectionHeading(RichText("h"), 2L), "list")
  expect_true(is.RichBlockSectionHeading(RichBlockSectionHeading(RichText("h"), 2L)))
  expect_error(
    RichBlockSectionHeading(RichText("h"), 7L),
    "`size` must be between 1 and 6."
  )

  expect_type(RichBlockPreformatted(RichText("code"), "python"), "list")
  expect_true(is.RichBlockPreformatted(RichBlockPreformatted(RichText("code"), "python")))

  expect_type(RichBlockFooter(RichText("footer")), "list")
  expect_true(is.RichBlockFooter(RichBlockFooter(RichText("footer"))))

  expect_type(RichBlockDivider(), "list")
  expect_true(is.RichBlockDivider(RichBlockDivider()))

  expect_type(RichBlockMathematicalExpression("E = mc^2"), "list")
  expect_true(is.RichBlockMathematicalExpression(RichBlockMathematicalExpression("E = mc^2")))

  expect_type(RichBlockAnchor("chapter-2"), "list")
  expect_true(is.RichBlockAnchor(RichBlockAnchor("chapter-2")))

  item <- RichBlockListItem(
    blocks = list(RichBlockParagraph(RichText("item"))),
    label = "Item 1"
  )
  expect_type(item, "list")
  expect_true(is.RichBlockListItem(item))

  lst <- RichBlockList(list(item))
  expect_type(lst, "list")
  expect_true(is.RichBlockList(lst))

  expect_type(
    RichBlockBlockQuotation(list(RichBlockParagraph(RichText("quote")))),
    "list"
  )
  expect_true(is.RichBlockBlockQuotation(
    RichBlockBlockQuotation(list(RichBlockParagraph(RichText("quote"))))
  ))

  expect_type(
    RichBlockExpandableBlockQuotation(RichText("quote")),
    "list"
  )
  expect_true(is.RichBlockExpandableBlockQuotation(
    RichBlockExpandableBlockQuotation(RichText("quote"))
  ))

  expect_type(RichBlockPullQuotation(RichText("pull")), "list")
  expect_true(is.RichBlockPullQuotation(RichBlockPullQuotation(RichText("pull"))))

  expect_type(
    RichBlockCollage(list(RichBlockPhoto(list()))),
    "list"
  )
  expect_true(is.RichBlockCollage(
    RichBlockCollage(list(RichBlockPhoto(list())))
  ))

  expect_type(
    RichBlockSlideshow(list(RichBlockPhoto(list()))),
    "list"
  )
  expect_true(is.RichBlockSlideshow(
    RichBlockSlideshow(list(RichBlockPhoto(list())))
  ))

  cell <- RichBlockTableCell(RichText("cell"))
  expect_type(cell, "list")
  expect_true(is.RichBlockTableCell(cell))

  table <- RichBlockTable(list(list(cell)))
  expect_type(table, "list")
  expect_true(is.RichBlockTable(table))

  caption <- RichBlockCaption(RichText("caption"))
  expect_type(caption, "list")
  expect_true(is.RichBlockCaption(caption))

  details <- RichBlockDetails(
    summary = RichText("summary"),
    blocks = list(RichBlockParagraph(RichText("content")))
  )
  expect_type(details, "list")
  expect_true(is.RichBlockDetails(details))

  expect_type(
    RichBlockDetails(
      summary = RichText("summary"),
      blocks = list(RichBlockParagraph(RichText("content")))
    ),
    "list"
  )

  map <- RichBlockMap(
    location = list(longitude = 12.5, latitude = 41.9),
    zoom = 14L,
    width = 300L,
    height = 200L
  )
  expect_type(map, "list")
  expect_true(is.RichBlockMap(map))

  buttons <- RichBlockButtons(list(RichMessageButton(RichText("b"), url = "https://t.me")))
  expect_type(buttons, "list")
  expect_true(is.RichBlockButtons(buttons))

  expect_type(RichBlockDivider(), "list")
  expect_true(is.RichBlock(RichBlockParagraph(RichText("p"))))
})

test_that("InputRichMessage and InputRichBlock constructors", {
  expect_type(InputRichMessage(blocks = list()), "list")
  expect_true(is.InputRichMessage(InputRichMessage(blocks = list())))

  expect_type(InputRichMessage(html = "<p>hi</p>"), "list")
  expect_true(is.InputRichMessage(InputRichMessage(html = "<p>hi</p>")))

  expect_type(InputRichMessageMedia("id1", list()), "list")
  expect_true(is.InputRichMessageMedia(InputRichMessageMedia("id1", list())))

  expect_type(InputRichBlockParagraph(RichText("p")), "list")
  expect_true(is.InputRichBlockParagraph(InputRichBlockParagraph(RichText("p"))))

  expect_type(InputRichBlockSectionHeading(RichText("h"), 2L), "list")
  expect_true(is.InputRichBlockSectionHeading(InputRichBlockSectionHeading(RichText("h"), 2L)))

  expect_type(InputRichBlockPreformatted(RichText("code"), "python"), "list")
  expect_true(is.InputRichBlockPreformatted(InputRichBlockPreformatted(RichText("code"), "python")))

  expect_type(InputRichBlockFooter(RichText("footer")), "list")
  expect_true(is.InputRichBlockFooter(InputRichBlockFooter(RichText("footer"))))

  expect_type(InputRichBlockDivider(), "list")
  expect_true(is.InputRichBlockDivider(InputRichBlockDivider()))

  expect_type(InputRichBlockMathematicalExpression("E = mc^2"), "list")
  expect_true(is.InputRichBlockMathematicalExpression(
    InputRichBlockMathematicalExpression("E = mc^2")
  ))

  expect_type(InputRichBlockAnchor("chapter-2"), "list")
  expect_true(is.InputRichBlockAnchor(InputRichBlockAnchor("chapter-2")))

  item <- InputRichBlockListItem(
    blocks = list(InputRichBlockParagraph(RichText("item")))
  )
  expect_type(item, "list")
  expect_true(is.InputRichBlockListItem(item))

  lst <- InputRichBlockList(list(item))
  expect_type(lst, "list")
  expect_true(is.InputRichBlockList(lst))

  expect_type(
    InputRichBlockBlockQuotation(list(InputRichBlockParagraph(RichText("quote")))),
    "list"
  )
  expect_true(is.InputRichBlockBlockQuotation(
    InputRichBlockBlockQuotation(list(InputRichBlockParagraph(RichText("quote"))))
  ))

  expect_type(
    InputRichBlockExpandableBlockQuotation(RichText("quote")),
    "list"
  )
  expect_true(is.InputRichBlockExpandableBlockQuotation(
    InputRichBlockExpandableBlockQuotation(RichText("quote"))
  ))

  expect_type(InputRichBlockPullQuotation(RichText("pull")), "list")
  expect_true(is.InputRichBlockPullQuotation(InputRichBlockPullQuotation(RichText("pull"))))

  expect_type(
    InputRichBlockCollage(list(InputRichBlockPhoto(list()))),
    "list"
  )
  expect_true(is.InputRichBlockCollage(
    InputRichBlockCollage(list(InputRichBlockPhoto(list())))
  ))

  expect_type(
    InputRichBlockSlideshow(list(InputRichBlockPhoto(list()))),
    "list"
  )
  expect_true(is.InputRichBlockSlideshow(
    InputRichBlockSlideshow(list(InputRichBlockPhoto(list())))
  ))

  expect_type(
    InputRichBlockTable(list(list(RichBlockTableCell(RichText("c"))))),
    "list"
  )
  expect_true(is.InputRichBlockTable(
    InputRichBlockTable(list(list(RichBlockTableCell(RichText("c")))))
  ))

  expect_type(
    InputRichBlockDetails(
      summary = RichText("summary"),
      blocks = list(InputRichBlockParagraph(RichText("content")))
    ),
    "list"
  )
  expect_true(is.InputRichBlockDetails(
    InputRichBlockDetails(
      summary = RichText("summary"),
      blocks = list(InputRichBlockParagraph(RichText("content")))
    )
  ))

  expect_type(
    InputRichBlockMap(
      location = list(longitude = 12.5, latitude = 41.9),
      zoom = 14L,
      width = 300L,
      height = 200L
    ),
    "list"
  )
  expect_true(is.InputRichBlockMap(
    InputRichBlockMap(
      location = list(longitude = 12.5, latitude = 41.9),
      zoom = 14L,
      width = 300L,
      height = 200L
    )
  ))

  expect_type(
    InputRichBlockButtons(list(RichMessageButton(RichText("b"), url = "https://t.me"))),
    "list"
  )
  expect_true(is.InputRichBlockButtons(
    InputRichBlockButtons(list(RichMessageButton(RichText("b"), url = "https://t.me")))
  ))

  expect_type(InputRichBlockThinking(RichText("Thinking...")), "list")
  expect_true(is.InputRichBlockThinking(InputRichBlockThinking(RichText("Thinking..."))))

  expect_true(is.InputRichBlock(InputRichBlockParagraph(RichText("p"))))
})