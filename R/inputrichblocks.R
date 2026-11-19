#' Create an input paragraph block
#'
#' A text paragraph, corresponding to the HTML tag `<p>`.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @export
InputRichBlockParagraph <- function(text) {
  structure(list(
    type = "paragraph",
    text = text
  ), class = c("InputRichBlock", "InputRichBlockParagraph"))
}

#' @rdname InputRichBlockParagraph
#' @param x Object to be tested
#' @export
is.InputRichBlockParagraph <- function(x) inherits(x, "InputRichBlockParagraph")


#' Create an input section heading block
#'
#' A section heading, corresponding to the HTML tags `<h1>`...`<h6>`.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @param size Relative size of the text font; 1-6, 1 is the largest
#' @export
InputRichBlockSectionHeading <- function(text, size = 1L) {
  if (size < 1L || size > 6L) {
    stop("`size` must be between 1 and 6.")
  }
  structure(list(
    type = "heading",
    text = text,
    size = size
  ), class = c("InputRichBlock", "InputRichBlockSectionHeading"))
}

#' @rdname InputRichBlockSectionHeading
#' @param x Object to be tested
#' @export
is.InputRichBlockSectionHeading <- function(x) inherits(x, "InputRichBlockSectionHeading")


#' Create an input preformatted text block
#'
#' A preformatted text block, corresponding to `<pre><code>`.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @param language (Optional). The programming language of the text
#' @export
InputRichBlockPreformatted <- function(text, language = NULL) {
  InputRichBlockPreformatted <- list(
    type = "pre",
    text = text,
    language = language
  )
  InputRichBlockPreformatted <- InputRichBlockPreformatted[!unlist(lapply(
    InputRichBlockPreformatted, is.null
  ))]

  structure(InputRichBlockPreformatted,
    class = c("InputRichBlock", "InputRichBlockPreformatted")
  )
}

#' @rdname InputRichBlockPreformatted
#' @param x Object to be tested
#' @export
is.InputRichBlockPreformatted <- function(x) inherits(x, "InputRichBlockPreformatted")


#' Create an input footer block
#'
#' A footer, corresponding to the HTML tag `<footer>`.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @export
InputRichBlockFooter <- function(text) {
  structure(list(
    type = "footer",
    text = text
  ), class = c("InputRichBlock", "InputRichBlockFooter"))
}

#' @rdname InputRichBlockFooter
#' @param x Object to be tested
#' @export
is.InputRichBlockFooter <- function(x) inherits(x, "InputRichBlockFooter")


#' Create an input divider block
#'
#' A divider, corresponding to the HTML tag `<hr/>`.
#'
#' @export
InputRichBlockDivider <- function() {
  structure(list(
    type = "divider"
  ), class = c("InputRichBlock", "InputRichBlockDivider"))
}

#' @rdname InputRichBlockDivider
#' @param x Object to be tested
#' @export
is.InputRichBlockDivider <- function(x) inherits(x, "InputRichBlockDivider")


#' Create an input mathematical expression block
#'
#' A block with a mathematical expression in LaTeX format.
#'
#' @param expression The mathematical expression in LaTeX format
#' @export
InputRichBlockMathematicalExpression <- function(expression) {
  structure(list(
    type = "mathematical_expression",
    expression = expression
  ), class = c("InputRichBlock", "InputRichBlockMathematicalExpression"))
}

#' @rdname InputRichBlockMathematicalExpression
#' @param x Object to be tested
#' @export
is.InputRichBlockMathematicalExpression <- function(x) inherits(x, "InputRichBlockMathematicalExpression")


#' Create an input anchor block
#'
#' A block with an anchor, corresponding to `<a name="...">`.
#'
#' @param name The name of the anchor
#' @export
InputRichBlockAnchor <- function(name) {
  structure(list(
    type = "anchor",
    name = name
  ), class = c("InputRichBlock", "InputRichBlockAnchor"))
}

#' @rdname InputRichBlockAnchor
#' @param x Object to be tested
#' @export
is.InputRichBlockAnchor <- function(x) inherits(x, "InputRichBlockAnchor")


#' Create an input list block
#'
#' A list of blocks, corresponding to `<ul>` or `<ol>`.
#'
#' @param items List of \code{\link{InputRichBlockListItem}} objects
#' @export
InputRichBlockList <- function(items) {
  if (!is.list(items) || !all(unlist(lapply(items, is.InputRichBlockListItem)))) {
    stop("`items` must be a list of `InputRichBlockListItem` objects.")
  }

  structure(list(
    type = "list",
    items = items
  ), class = c("InputRichBlock", "InputRichBlockList"))
}

#' @rdname InputRichBlockList
#' @param x Object to be tested
#' @export
is.InputRichBlockList <- function(x) inherits(x, "InputRichBlockList")


#' Create an input list item
#'
#' An item of a list to be sent.
#'
#' @param blocks List of \code{\link{InputRichBlock}} objects. The content of the item
#' @param label (Optional). Label of the item
#' @param has_checkbox (Optional). TRUE if the item has a checkbox
#' @param is_checked (Optional). TRUE if the item has a checked checkbox
#' @param value (Optional). For ordered lists, the numeric value of the item label
#' @param type (Optional). For ordered lists, the type of the item label; one of
#'     "a", "A", "i", "I", or "1"
#' @export
InputRichBlockListItem <- function(blocks,
                                   label = NULL,
                                   has_checkbox = NULL,
                                   is_checked = NULL,
                                   value = NULL,
                                   type = NULL) {
  if (!is.list(blocks) || !all(unlist(lapply(blocks, is.InputRichBlock)))) {
    stop("`blocks` must be a list of `InputRichBlock` objects.")
  }

  if (!is.null(type) && !(type %in% c("a", "A", "i", "I", "1"))) {
    stop("`type` must be one of \"a\", \"A\", \"i\", \"I\", or \"1\".")
  }

  InputRichBlockListItem <- list(
    blocks = blocks,
    label = label,
    has_checkbox = has_checkbox,
    is_checked = is_checked,
    value = value,
    type = type
  )
  InputRichBlockListItem <- InputRichBlockListItem[!unlist(lapply(
    InputRichBlockListItem, is.null
  ))]

  structure(InputRichBlockListItem, class = "InputRichBlockListItem")
}

#' @rdname InputRichBlockListItem
#' @param x Object to be tested
#' @export
is.InputRichBlockListItem <- function(x) inherits(x, "InputRichBlockListItem")


#' Create an input block quotation
#'
#' A block quotation, corresponding to `<blockquote>`.
#'
#' @param blocks List of \code{\link{InputRichBlock}} objects. Content of the block
#' @param credit (Optional). \code{\link{RichText}} Credit of the block
#' @export
InputRichBlockBlockQuotation <- function(blocks, credit = NULL) {
  if (!is.list(blocks) || !all(unlist(lapply(blocks, is.InputRichBlock)))) {
    stop("`blocks` must be a list of `InputRichBlock` objects.")
  }

  InputRichBlockBlockQuotation <- list(
    type = "blockquote",
    blocks = blocks,
    credit = credit
  )
  InputRichBlockBlockQuotation <- InputRichBlockBlockQuotation[!unlist(lapply(
    InputRichBlockBlockQuotation, is.null
  ))]

  structure(InputRichBlockBlockQuotation,
    class = c("InputRichBlock", "InputRichBlockBlockQuotation")
  )
}

#' @rdname InputRichBlockBlockQuotation
#' @param x Object to be tested
#' @export
is.InputRichBlockBlockQuotation <- function(x) inherits(x, "InputRichBlockBlockQuotation")


#' Create an input expandable block quotation
#'
#' A block quotation, corresponding to `<blockquote expandable>`.
#'
#' @param text \code{\link{RichText}} Content of the block
#' @param credit (Optional). \code{\link{RichText}} Credit of the block
#' @export
InputRichBlockExpandableBlockQuotation <- function(text, credit = NULL) {
  InputRichBlockExpandableBlockQuotation <- list(
    type = "expandable_blockquote",
    text = text,
    credit = credit
  )
  InputRichBlockExpandableBlockQuotation <- InputRichBlockExpandableBlockQuotation[!unlist(lapply(
    InputRichBlockExpandableBlockQuotation, is.null
  ))]

  structure(InputRichBlockExpandableBlockQuotation,
    class = c("InputRichBlock", "InputRichBlockExpandableBlockQuotation")
  )
}

#' @rdname InputRichBlockExpandableBlockQuotation
#' @param x Object to be tested
#' @export
is.InputRichBlockExpandableBlockQuotation <- function(x) inherits(x, "InputRichBlockExpandableBlockQuotation")


#' Create an input pull quotation
#'
#' A quotation with centered text, loosely corresponding to `<aside>`.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @param credit (Optional). \code{\link{RichText}} Credit of the block
#' @export
InputRichBlockPullQuotation <- function(text, credit = NULL) {
  InputRichBlockPullQuotation <- list(
    type = "pullquote",
    text = text,
    credit = credit
  )
  InputRichBlockPullQuotation <- InputRichBlockPullQuotation[!unlist(lapply(
    InputRichBlockPullQuotation, is.null
  ))]

  structure(InputRichBlockPullQuotation,
    class = c("InputRichBlock", "InputRichBlockPullQuotation")
  )
}

#' @rdname InputRichBlockPullQuotation
#' @param x Object to be tested
#' @export
is.InputRichBlockPullQuotation <- function(x) inherits(x, "InputRichBlockPullQuotation")


#' Create an input collage block
#'
#' A collage, corresponding to `<tg-collage>`.
#'
#' @param blocks List of \code{\link{InputRichBlock}} objects. Elements of the collage
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
InputRichBlockCollage <- function(blocks, caption = NULL) {
  if (!is.list(blocks) || !all(unlist(lapply(blocks, is.InputRichBlock)))) {
    stop("`blocks` must be a list of `InputRichBlock` objects.")
  }

  InputRichBlockCollage <- list(
    type = "collage",
    blocks = blocks,
    caption = caption
  )
  InputRichBlockCollage <- InputRichBlockCollage[!unlist(lapply(
    InputRichBlockCollage, is.null
  ))]

  structure(InputRichBlockCollage, class = c("InputRichBlock", "InputRichBlockCollage"))
}

#' @rdname InputRichBlockCollage
#' @param x Object to be tested
#' @export
is.InputRichBlockCollage <- function(x) inherits(x, "InputRichBlockCollage")


#' Create an input slideshow block
#'
#' A slideshow, corresponding to `<tg-slideshow>`.
#'
#' @param blocks List of \code{\link{InputRichBlock}} objects. Elements of the slideshow
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
InputRichBlockSlideshow <- function(blocks, caption = NULL) {
  if (!is.list(blocks) || !all(unlist(lapply(blocks, is.InputRichBlock)))) {
    stop("`blocks` must be a list of `InputRichBlock` objects.")
  }

  InputRichBlockSlideshow <- list(
    type = "slideshow",
    blocks = blocks,
    caption = caption
  )
  InputRichBlockSlideshow <- InputRichBlockSlideshow[!unlist(lapply(
    InputRichBlockSlideshow, is.null
  ))]

  structure(InputRichBlockSlideshow, class = c("InputRichBlock", "InputRichBlockSlideshow"))
}

#' @rdname InputRichBlockSlideshow
#' @param x Object to be tested
#' @export
is.InputRichBlockSlideshow <- function(x) inherits(x, "InputRichBlockSlideshow")


#' Create an input table block
#'
#' A table, corresponding to `<table>`.
#'
#' @param cells Matrix of \code{\link{RichBlockTableCell}} objects. Cells of the table
#' @param is_bordered (Optional). TRUE if the table has borders
#' @param is_striped (Optional). TRUE if the table is striped
#' @param is_compact (Optional). TRUE if table cells have smaller indents
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
InputRichBlockTable <- function(cells,
                                is_bordered = NULL,
                                is_striped = NULL,
                                is_compact = NULL,
                                caption = NULL) {
  if (!is.list(cells) || !all(unlist(lapply(cells, is.list))) ||
    !all(unlist(lapply(cells, function(x) {
      lapply(x, is.RichBlockTableCell)
    })))) {
    stop(
      "`cells` must be a matrix (list of lists) of `RichBlockTableCell` objects."
    )
  }

  InputRichBlockTable <- list(
    type = "table",
    cells = cells,
    is_bordered = is_bordered,
    is_striped = is_striped,
    is_compact = is_compact,
    caption = caption
  )
  InputRichBlockTable <- InputRichBlockTable[!unlist(lapply(
    InputRichBlockTable, is.null
  ))]

  structure(InputRichBlockTable, class = c("InputRichBlock", "InputRichBlockTable"))
}

#' @rdname InputRichBlockTable
#' @param x Object to be tested
#' @export
is.InputRichBlockTable <- function(x) inherits(x, "InputRichBlockTable")


#' Create an input details block
#'
#' An expandable block for details disclosure, corresponding to `<details>`.
#'
#' @param summary \code{\link{RichText}} Always shown summary of the block
#' @param blocks List of \code{\link{InputRichBlock}} objects. Content of the block
#' @param is_open (Optional). TRUE if the content of the block is visible by default
#' @export
InputRichBlockDetails <- function(summary, blocks, is_open = NULL) {
  if (!is.list(blocks) || !all(unlist(lapply(blocks, is.InputRichBlock)))) {
    stop("`blocks` must be a list of `InputRichBlock` objects.")
  }

  InputRichBlockDetails <- list(
    type = "details",
    summary = summary,
    blocks = blocks,
    is_open = is_open
  )
  InputRichBlockDetails <- InputRichBlockDetails[!unlist(lapply(
    InputRichBlockDetails, is.null
  ))]

  structure(InputRichBlockDetails, class = c("InputRichBlock", "InputRichBlockDetails"))
}

#' @rdname InputRichBlockDetails
#' @param x Object to be tested
#' @export
is.InputRichBlockDetails <- function(x) inherits(x, "InputRichBlockDetails")


#' Create an input map block
#'
#' A block with a map, corresponding to `<tg-map>`.
#'
#' @param location \code{\link{Location}} Location of the center of the map
#' @param zoom Map zoom level
#' @param width Expected width of the map
#' @param height Expected height of the map
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
InputRichBlockMap <- function(location,
                              zoom,
                              width,
                              height,
                              caption = NULL) {
  if (!is.list(location)) {
    stop("`location` must be a `Location` object.")
  }

  InputRichBlockMap <- list(
    type = "map",
    location = location,
    zoom = zoom,
    width = width,
    height = height,
    caption = caption
  )
  InputRichBlockMap <- InputRichBlockMap[!unlist(lapply(
    InputRichBlockMap, is.null
  ))]

  structure(InputRichBlockMap, class = c("InputRichBlock", "InputRichBlockMap"))
}

#' @rdname InputRichBlockMap
#' @param x Object to be tested
#' @export
is.InputRichBlockMap <- function(x) inherits(x, "InputRichBlockMap")


#' Create an input buttons block
#'
#' A block containing a list of buttons that are shown in one row.
#'
#' @param buttons List of \code{\link{RichMessageButton}} objects
#' @param align (Optional). Horizontal alignment: "left", "center", or "right"
#' @export
InputRichBlockButtons <- function(buttons, align = NULL) {
  if (!is.list(buttons) || !all(unlist(lapply(buttons, is.RichMessageButton)))) {
    stop("`buttons` must be a list of `RichMessageButton` objects.")
  }

  if (!is.null(align) && !(align %in% c("left", "center", "right"))) {
    stop("`align` must be one of \"left\", \"center\", or \"right\".")
  }

  InputRichBlockButtons <- list(
    type = "buttons",
    buttons = buttons,
    align = align
  )
  InputRichBlockButtons <- InputRichBlockButtons[!unlist(lapply(
    InputRichBlockButtons, is.null
  ))]

  structure(InputRichBlockButtons, class = c("InputRichBlock", "InputRichBlockButtons"))
}

#' @rdname InputRichBlockButtons
#' @param x Object to be tested
#' @export
is.InputRichBlockButtons <- function(x) inherits(x, "InputRichBlockButtons")


#' Create an input media block with animation
#'
#' A block with an animation, corresponding to `<video>`.
#'
#' @param animation \code{\link{Animation}} The animation
#' @param has_spoiler (Optional). TRUE if the media preview is covered by a spoiler
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
InputRichBlockAnimation <- function(animation,
                                    has_spoiler = NULL,
                                    caption = NULL) {
  if (!is.list(animation)) {
    stop("`animation` must be an `Animation` object.")
  }

  InputRichBlockAnimation <- list(
    type = "animation",
    animation = animation,
    has_spoiler = has_spoiler,
    caption = caption
  )
  InputRichBlockAnimation <- InputRichBlockAnimation[!unlist(lapply(
    InputRichBlockAnimation, is.null
  ))]

  structure(InputRichBlockAnimation, class = c("InputRichBlock", "InputRichBlockAnimation"))
}

#' @rdname InputRichBlockAnimation
#' @param x Object to be tested
#' @export
is.InputRichBlockAnimation <- function(x) inherits(x, "InputRichBlockAnimation")


#' Create an input media block with audio
#'
#' A block with a music file, corresponding to `<audio>`.
#'
#' @param audio \code{\link{Audio}} The audio
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
InputRichBlockAudio <- function(audio, caption = NULL) {
  if (!is.list(audio)) {
    stop("`audio` must be an `Audio` object.")
  }

  InputRichBlockAudio <- list(
    type = "audio",
    audio = audio,
    caption = caption
  )
  InputRichBlockAudio <- InputRichBlockAudio[!unlist(lapply(
    InputRichBlockAudio, is.null
  ))]

  structure(InputRichBlockAudio, class = c("InputRichBlock", "InputRichBlockAudio"))
}

#' @rdname InputRichBlockAudio
#' @param x Object to be tested
#' @export
is.InputRichBlockAudio <- function(x) inherits(x, "InputRichBlockAudio")


#' Create an input media block with document
#'
#' A block with a general file, corresponding to `<tg-document>`.
#'
#' @param document \code{\link{Document}} The document
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
InputRichBlockDocument <- function(document, caption = NULL) {
  if (!is.list(document)) {
    stop("`document` must be a `Document` object.")
  }

  InputRichBlockDocument <- list(
    type = "document",
    document = document,
    caption = caption
  )
  InputRichBlockDocument <- InputRichBlockDocument[!unlist(lapply(
    InputRichBlockDocument, is.null
  ))]

  structure(InputRichBlockDocument, class = c("InputRichBlock", "InputRichBlockDocument"))
}

#' @rdname InputRichBlockDocument
#' @param x Object to be tested
#' @export
is.InputRichBlockDocument <- function(x) inherits(x, "InputRichBlockDocument")


#' Create an input media block with photo
#'
#' A block with a photo, corresponding to ``.
#'
#' @param photo List of \code{\link{PhotoSize}} objects. Available sizes of the photo
#' @param has_spoiler (Optional). TRUE if the media preview is covered by a spoiler
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
InputRichBlockPhoto <- function(photo,
                                has_spoiler = NULL,
                                caption = NULL) {
  if (!is.list(photo)) {
    stop("`photo` must be a list of `PhotoSize` objects.")
  }

  InputRichBlockPhoto <- list(
    type = "photo",
    photo = photo,
    has_spoiler = has_spoiler,
    caption = caption
  )
  InputRichBlockPhoto <- InputRichBlockPhoto[!unlist(lapply(
    InputRichBlockPhoto, is.null
  ))]

  structure(InputRichBlockPhoto, class = c("InputRichBlock", "InputRichBlockPhoto"))
}

#' @rdname InputRichBlockPhoto
#' @param x Object to be tested
#' @export
is.InputRichBlockPhoto <- function(x) inherits(x, "InputRichBlockPhoto")


#' Create an input media block with video
#'
#' A block with a video, corresponding to `<video>`.
#'
#' @param video \code{\link{Video}} The video
#' @param has_spoiler (Optional). TRUE if the media preview is covered by a spoiler
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
InputRichBlockVideo <- function(video,
                                has_spoiler = NULL,
                                caption = NULL) {
  if (!is.list(video)) {
    stop("`video` must be a `Video` object.")
  }

  InputRichBlockVideo <- list(
    type = "video",
    video = video,
    has_spoiler = has_spoiler,
    caption = caption
  )
  InputRichBlockVideo <- InputRichBlockVideo[!unlist(lapply(
    InputRichBlockVideo, is.null
  ))]

  structure(InputRichBlockVideo, class = c("InputRichBlock", "InputRichBlockVideo"))
}

#' @rdname InputRichBlockVideo
#' @param x Object to be tested
#' @export
is.InputRichBlockVideo <- function(x) inherits(x, "InputRichBlockVideo")


#' Create an input media block with voice note
#'
#' A block with a voice note, corresponding to `<audio>`.
#'
#' @param voice_note \code{\link{Voice}} The voice note
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
InputRichBlockVoiceNote <- function(voice_note, caption = NULL) {
  if (!is.list(voice_note)) {
    stop("`voice_note` must be a `Voice` object.")
  }

  InputRichBlockVoiceNote <- list(
    type = "voice_note",
    voice_note = voice_note,
    caption = caption
  )
  InputRichBlockVoiceNote <- InputRichBlockVoiceNote[!unlist(lapply(
    InputRichBlockVoiceNote, is.null
  ))]

  structure(InputRichBlockVoiceNote, class = c("InputRichBlock", "InputRichBlockVoiceNote"))
}

#' @rdname InputRichBlockVoiceNote
#' @param x Object to be tested
#' @export
is.InputRichBlockVoiceNote <- function(x) inherits(x, "InputRichBlockVoiceNote")


#' Create an input thinking block
#'
#' A block with a "Thinking..." placeholder.
#' Used only in \code{\link{sendRichMessageDraft}}.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @export
InputRichBlockThinking <- function(text) {
  structure(list(
    type = "thinking",
    text = text
  ), class = c("InputRichBlock", "InputRichBlockThinking"))
}

#' @rdname InputRichBlockThinking
#' @param x Object to be tested
#' @export
is.InputRichBlockThinking <- function(x) inherits(x, "InputRichBlockThinking")


#' Create an input rich block
#'
#' This object represents a block in a rich formatted message to be sent. Use one of
#' the specific input block constructors above.
#'
#' @param block A block object (one of the \code{InputRichBlock*} classes)
#' @export
InputRichBlock <- function(block) {
  if (!is.InputRichBlockParagraph(block) &&
    !is.InputRichBlockSectionHeading(block) &&
    !is.InputRichBlockPreformatted(block) &&
    !is.InputRichBlockFooter(block) &&
    !is.InputRichBlockDivider(block) &&
    !is.InputRichBlockMathematicalExpression(block) &&
    !is.InputRichBlockAnchor(block) &&
    !is.InputRichBlockList(block) &&
    !is.InputRichBlockBlockQuotation(block) &&
    !is.InputRichBlockExpandableBlockQuotation(block) &&
    !is.InputRichBlockPullQuotation(block) &&
    !is.InputRichBlockCollage(block) &&
    !is.InputRichBlockSlideshow(block) &&
    !is.InputRichBlockTable(block) &&
    !is.InputRichBlockDetails(block) &&
    !is.InputRichBlockMap(block) &&
    !is.InputRichBlockButtons(block) &&
    !is.InputRichBlockAnimation(block) &&
    !is.InputRichBlockAudio(block) &&
    !is.InputRichBlockDocument(block) &&
    !is.InputRichBlockPhoto(block) &&
    !is.InputRichBlockVideo(block) &&
    !is.InputRichBlockVoiceNote(block) &&
    !is.InputRichBlockThinking(block)) {
    stop("`block` must be an InputRichBlock object.")
  }

  structure(block, class = unique(class(block)))
}

#' @rdname InputRichBlock
#' @param x Object to be tested
#' @export
is.InputRichBlock <- function(x) inherits(x, "InputRichBlock")