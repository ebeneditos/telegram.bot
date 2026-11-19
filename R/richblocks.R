#' Create a text paragraph
#'
#' A text paragraph, corresponding to the HTML tag `<p>`.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @export
RichBlockParagraph <- function(text) {
  structure(list(
    type = "paragraph",
    text = text
  ), class = c("RichBlock", "RichBlockParagraph"))
}

#' @rdname RichBlockParagraph
#' @param x Object to be tested
#' @export
is.RichBlockParagraph <- function(x) inherits(x, "RichBlockParagraph")


#' Create a section heading
#'
#' A section heading, corresponding to the HTML tags `<h1>`...`<h6>`.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @param size Relative size of the text font; 1-6, 1 is the largest
#' @export
RichBlockSectionHeading <- function(text, size = 1L) {
  if (size < 1L || size > 6L) {
    stop("`size` must be between 1 and 6.")
  }
  structure(list(
    type = "heading",
    text = text,
    size = size
  ), class = c("RichBlock", "RichBlockSectionHeading"))
}

#' @rdname RichBlockSectionHeading
#' @param x Object to be tested
#' @export
is.RichBlockSectionHeading <- function(x) inherits(x, "RichBlockSectionHeading")


#' Create a preformatted text block
#'
#' A preformatted text block, corresponding to `<pre><code>`.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @param language (Optional). The programming language of the text
#' @export
RichBlockPreformatted <- function(text, language = NULL) {
  RichBlockPreformatted <- list(
    type = "pre",
    text = text,
    language = language
  )
  RichBlockPreformatted <- RichBlockPreformatted[!unlist(lapply(
    RichBlockPreformatted, is.null
  ))]

  structure(RichBlockPreformatted,
    class = c("RichBlock", "RichBlockPreformatted")
  )
}

#' @rdname RichBlockPreformatted
#' @param x Object to be tested
#' @export
is.RichBlockPreformatted <- function(x) inherits(x, "RichBlockPreformatted")


#' Create a footer
#'
#' A footer, corresponding to the HTML tag `<footer>`.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @export
RichBlockFooter <- function(text) {
  structure(list(
    type = "footer",
    text = text
  ), class = c("RichBlock", "RichBlockFooter"))
}

#' @rdname RichBlockFooter
#' @param x Object to be tested
#' @export
is.RichBlockFooter <- function(x) inherits(x, "RichBlockFooter")


#' Create a divider
#'
#' A divider, corresponding to the HTML tag `<hr/>`.
#'
#' @export
RichBlockDivider <- function() {
  structure(list(
    type = "divider"
  ), class = c("RichBlock", "RichBlockDivider"))
}

#' @rdname RichBlockDivider
#' @param x Object to be tested
#' @export
is.RichBlockDivider <- function(x) inherits(x, "RichBlockDivider")


#' Create a mathematical expression block
#'
#' A block with a mathematical expression in LaTeX format.
#'
#' @param expression The mathematical expression in LaTeX format
#' @export
RichBlockMathematicalExpression <- function(expression) {
  structure(list(
    type = "mathematical_expression",
    expression = expression
  ), class = c("RichBlock", "RichBlockMathematicalExpression"))
}

#' @rdname RichBlockMathematicalExpression
#' @param x Object to be tested
#' @export
is.RichBlockMathematicalExpression <- function(x) inherits(x, "RichBlockMathematicalExpression")


#' Create an anchor block
#'
#' A block with an anchor, corresponding to `<a name="...">`.
#'
#' @param name The name of the anchor
#' @export
RichBlockAnchor <- function(name) {
  structure(list(
    type = "anchor",
    name = name
  ), class = c("RichBlock", "RichBlockAnchor"))
}

#' @rdname RichBlockAnchor
#' @param x Object to be tested
#' @export
is.RichBlockAnchor <- function(x) inherits(x, "RichBlockAnchor")


#' Create a list block
#'
#' A list of blocks, corresponding to `<ul>` or `<ol>`.
#'
#' @param items List of \code{\link{RichBlockListItem}} objects
#' @export
RichBlockList <- function(items) {
  if (!is.list(items) || !all(unlist(lapply(items, is.RichBlockListItem)))) {
    stop("`items` must be a list of `RichBlockListItem` objects.")
  }

  structure(list(
    type = "list",
    items = items
  ), class = c("RichBlock", "RichBlockList"))
}

#' @rdname RichBlockList
#' @param x Object to be tested
#' @export
is.RichBlockList <- function(x) inherits(x, "RichBlockList")


#' Create a list item
#'
#' An item of a list.
#'
#' @param blocks List of \code{\link{RichBlock}} objects. The content of the item
#' @param label (Optional). Label of the item
#' @param has_checkbox (Optional). TRUE if the item has a checkbox
#' @param is_checked (Optional). TRUE if the item has a checked checkbox
#' @param value (Optional). For ordered lists, the numeric value of the item label
#' @param type (Optional). For ordered lists, the type of the item label; one of
#'     "a", "A", "i", "I", or "1"
#' @export
RichBlockListItem <- function(blocks,
                              label = NULL,
                              has_checkbox = NULL,
                              is_checked = NULL,
                              value = NULL,
                              type = NULL) {
  if (!is.list(blocks) || !all(unlist(lapply(blocks, is.RichBlock)))) {
    stop("`blocks` must be a list of `RichBlock` objects.")
  }

  if (!is.null(type) && !(type %in% c("a", "A", "i", "I", "1"))) {
    stop("`type` must be one of \"a\", \"A\", \"i\", \"I\", or \"1\".")
  }

  RichBlockListItem <- list(
    blocks = blocks,
    label = label,
    has_checkbox = has_checkbox,
    is_checked = is_checked,
    value = value,
    type = type
  )
  RichBlockListItem <- RichBlockListItem[!unlist(lapply(
    RichBlockListItem, is.null
  ))]

  structure(RichBlockListItem, class = "RichBlockListItem")
}

#' @rdname RichBlockListItem
#' @param x Object to be tested
#' @export
is.RichBlockListItem <- function(x) inherits(x, "RichBlockListItem")


#' Create a block quotation
#'
#' A block quotation, corresponding to `<blockquote>`.
#'
#' @param blocks List of \code{\link{RichBlock}} objects. Content of the block
#' @param credit (Optional). \code{\link{RichText}} Credit of the block
#' @export
RichBlockBlockQuotation <- function(blocks, credit = NULL) {
  if (!is.list(blocks) || !all(unlist(lapply(blocks, is.RichBlock)))) {
    stop("`blocks` must be a list of `RichBlock` objects.")
  }

  RichBlockBlockQuotation <- list(
    type = "blockquote",
    blocks = blocks,
    credit = credit
  )
  RichBlockBlockQuotation <- RichBlockBlockQuotation[!unlist(lapply(
    RichBlockBlockQuotation, is.null
  ))]

  structure(RichBlockBlockQuotation,
    class = c("RichBlock", "RichBlockBlockQuotation")
  )
}

#' @rdname RichBlockBlockQuotation
#' @param x Object to be tested
#' @export
is.RichBlockBlockQuotation <- function(x) inherits(x, "RichBlockBlockQuotation")


#' Create an expandable block quotation
#'
#' A block quotation, corresponding to `<blockquote expandable>`.
#'
#' @param text \code{\link{RichText}} Content of the block
#' @param credit (Optional). \code{\link{RichText}} Credit of the block
#' @export
RichBlockExpandableBlockQuotation <- function(text, credit = NULL) {
  RichBlockExpandableBlockQuotation <- list(
    type = "expandable_blockquote",
    text = text,
    credit = credit
  )
  RichBlockExpandableBlockQuotation <- RichBlockExpandableBlockQuotation[!unlist(lapply(
    RichBlockExpandableBlockQuotation, is.null
  ))]

  structure(RichBlockExpandableBlockQuotation,
    class = c("RichBlock", "RichBlockExpandableBlockQuotation")
  )
}

#' @rdname RichBlockExpandableBlockQuotation
#' @param x Object to be tested
#' @export
is.RichBlockExpandableBlockQuotation <- function(x) inherits(x, "RichBlockExpandableBlockQuotation")


#' Create a pull quotation
#'
#' A quotation with centered text, loosely corresponding to `<aside>`.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @param credit (Optional). \code{\link{RichText}} Credit of the block
#' @export
RichBlockPullQuotation <- function(text, credit = NULL) {
  RichBlockPullQuotation <- list(
    type = "pullquote",
    text = text,
    credit = credit
  )
  RichBlockPullQuotation <- RichBlockPullQuotation[!unlist(lapply(
    RichBlockPullQuotation, is.null
  ))]

  structure(RichBlockPullQuotation,
    class = c("RichBlock", "RichBlockPullQuotation")
  )
}

#' @rdname RichBlockPullQuotation
#' @param x Object to be tested
#' @export
is.RichBlockPullQuotation <- function(x) inherits(x, "RichBlockPullQuotation")


#' Create a collage
#'
#' A collage, corresponding to `<tg-collage>`.
#'
#' @param blocks List of \code{\link{RichBlock}} objects. Elements of the collage
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
RichBlockCollage <- function(blocks, caption = NULL) {
  if (!is.list(blocks) || !all(unlist(lapply(blocks, is.RichBlock)))) {
    stop("`blocks` must be a list of `RichBlock` objects.")
  }

  RichBlockCollage <- list(
    type = "collage",
    blocks = blocks,
    caption = caption
  )
  RichBlockCollage <- RichBlockCollage[!unlist(lapply(
    RichBlockCollage, is.null
  ))]

  structure(RichBlockCollage, class = c("RichBlock", "RichBlockCollage"))
}

#' @rdname RichBlockCollage
#' @param x Object to be tested
#' @export
is.RichBlockCollage <- function(x) inherits(x, "RichBlockCollage")


#' Create a slideshow
#'
#' A slideshow, corresponding to `<tg-slideshow>`.
#'
#' @param blocks List of \code{\link{RichBlock}} objects. Elements of the slideshow
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
RichBlockSlideshow <- function(blocks, caption = NULL) {
  if (!is.list(blocks) || !all(unlist(lapply(blocks, is.RichBlock)))) {
    stop("`blocks` must be a list of `RichBlock` objects.")
  }

  RichBlockSlideshow <- list(
    type = "slideshow",
    blocks = blocks,
    caption = caption
  )
  RichBlockSlideshow <- RichBlockSlideshow[!unlist(lapply(
    RichBlockSlideshow, is.null
  ))]

  structure(RichBlockSlideshow, class = c("RichBlock", "RichBlockSlideshow"))
}

#' @rdname RichBlockSlideshow
#' @param x Object to be tested
#' @export
is.RichBlockSlideshow <- function(x) inherits(x, "RichBlockSlideshow")


#' Create a table
#'
#' A table, corresponding to `<table>`.
#'
#' @param cells Matrix of \code{\link{RichBlockTableCell}} objects. Cells of the table
#' @param is_bordered (Optional). TRUE if the table has borders
#' @param is_striped (Optional). TRUE if the table is striped
#' @param is_compact (Optional). TRUE if table cells have smaller indents
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
RichBlockTable <- function(cells,
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

  RichBlockTable <- list(
    type = "table",
    cells = cells,
    is_bordered = is_bordered,
    is_striped = is_striped,
    is_compact = is_compact,
    caption = caption
  )
  RichBlockTable <- RichBlockTable[!unlist(lapply(
    RichBlockTable, is.null
  ))]

  structure(RichBlockTable, class = c("RichBlock", "RichBlockTable"))
}

#' @rdname RichBlockTable
#' @param x Object to be tested
#' @export
is.RichBlockTable <- function(x) inherits(x, "RichBlockTable")


#' Create a table cell
#'
#' Cell in a table.
#'
#' @param text \code{\link{RichText}} Text in the cell
#' @param is_header (Optional). TRUE if the cell is a header cell
#' @param colspan (Optional). The number of columns the cell spans
#' @param rowspan (Optional). The number of rows the cell spans
#' @param align (Optional). Horizontal cell content alignment: "left", "center", or "right"
#' @param valign (Optional). Vertical cell content alignment: "top", "middle", or "bottom"
#' @export
RichBlockTableCell <- function(text,
                               is_header = NULL,
                               colspan = NULL,
                               rowspan = NULL,
                               align = NULL,
                               valign = NULL) {
  if (!is.null(align) && !(align %in% c("left", "center", "right"))) {
    stop("`align` must be one of \"left\", \"center\", or \"right\".")
  }

  if (!is.null(valign) && !(valign %in% c("top", "middle", "bottom"))) {
    stop("`valign` must be one of \"top\", \"middle\", or \"bottom\".")
  }

  RichBlockTableCell <- list(
    text = text,
    is_header = is_header,
    colspan = colspan,
    rowspan = rowspan,
    align = align,
    valign = valign
  )
  RichBlockTableCell <- RichBlockTableCell[!unlist(lapply(
    RichBlockTableCell, is.null
  ))]

  structure(RichBlockTableCell, class = "RichBlockTableCell")
}

#' @rdname RichBlockTableCell
#' @param x Object to be tested
#' @export
is.RichBlockTableCell <- function(x) inherits(x, "RichBlockTableCell")


#' Create a caption for a rich block
#'
#' Caption of a rich formatted block.
#'
#' @param text \code{\link{RichText}} Block caption
#' @param credit (Optional). \code{\link{RichText}} Block credit
#' @export
RichBlockCaption <- function(text, credit = NULL) {
  RichBlockCaption <- list(
    text = text,
    credit = credit
  )
  RichBlockCaption <- RichBlockCaption[!unlist(lapply(
    RichBlockCaption, is.null
  ))]

  structure(RichBlockCaption, class = "RichBlockCaption")
}

#' @rdname RichBlockCaption
#' @param x Object to be tested
#' @export
is.RichBlockCaption <- function(x) inherits(x, "RichBlockCaption")


#' Create a details block
#'
#' An expandable block for details disclosure, corresponding to `<details>`.
#'
#' @param summary \code{\link{RichText}} Always shown summary of the block
#' @param blocks List of \code{\link{RichBlock}} objects. Content of the block
#' @param is_open (Optional). TRUE if the content of the block is visible by default
#' @export
RichBlockDetails <- function(summary, blocks, is_open = NULL) {
  if (!is.list(blocks) || !all(unlist(lapply(blocks, is.RichBlock)))) {
    stop("`blocks` must be a list of `RichBlock` objects.")
  }

  RichBlockDetails <- list(
    type = "details",
    summary = summary,
    blocks = blocks,
    is_open = is_open
  )
  RichBlockDetails <- RichBlockDetails[!unlist(lapply(
    RichBlockDetails, is.null
  ))]

  structure(RichBlockDetails, class = c("RichBlock", "RichBlockDetails"))
}

#' @rdname RichBlockDetails
#' @param x Object to be tested
#' @export
is.RichBlockDetails <- function(x) inherits(x, "RichBlockDetails")


#' Create a map block
#'
#' A block with a map, corresponding to `<tg-map>`.
#'
#' @param location \code{\link{Location}} Location of the center of the map
#' @param zoom Map zoom level
#' @param width Expected width of the map
#' @param height Expected height of the map
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
RichBlockMap <- function(location,
                         zoom,
                         width,
                         height,
                         caption = NULL) {
  if (!is.list(location)) {
    stop("`location` must be a `Location` object.")
  }

  RichBlockMap <- list(
    type = "map",
    location = location,
    zoom = zoom,
    width = width,
    height = height,
    caption = caption
  )
  RichBlockMap <- RichBlockMap[!unlist(lapply(
    RichBlockMap, is.null
  ))]

  structure(RichBlockMap, class = c("RichBlock", "RichBlockMap"))
}

#' @rdname RichBlockMap
#' @param x Object to be tested
#' @export
is.RichBlockMap <- function(x) inherits(x, "RichBlockMap")


#' Create a buttons block
#'
#' A block containing a list of buttons that are shown in one row.
#'
#' @param buttons List of \code{\link{RichMessageButton}} objects
#' @param align (Optional). Horizontal alignment: "left", "center", or "right"
#' @export
RichBlockButtons <- function(buttons, align = NULL) {
  if (!is.list(buttons) || !all(unlist(lapply(buttons, is.RichMessageButton)))) {
    stop("`buttons` must be a list of `RichMessageButton` objects.")
  }

  if (!is.null(align) && !(align %in% c("left", "center", "right"))) {
    stop("`align` must be one of \"left\", \"center\", or \"right\".")
  }

  RichBlockButtons <- list(
    type = "buttons",
    buttons = buttons,
    align = align
  )
  RichBlockButtons <- RichBlockButtons[!unlist(lapply(
    RichBlockButtons, is.null
  ))]

  structure(RichBlockButtons, class = c("RichBlock", "RichBlockButtons"))
}

#' @rdname RichBlockButtons
#' @param x Object to be tested
#' @export
is.RichBlockButtons <- function(x) inherits(x, "RichBlockButtons")


#' Create a media block with animation
#'
#' A block with an animation, corresponding to `<video>`.
#'
#' @param animation \code{\link{Animation}} The animation
#' @param has_spoiler (Optional). TRUE if the media preview is covered by a spoiler
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
RichBlockAnimation <- function(animation,
                               has_spoiler = NULL,
                               caption = NULL) {
  if (!is.list(animation)) {
    stop("`animation` must be an `Animation` object.")
  }

  RichBlockAnimation <- list(
    type = "animation",
    animation = animation,
    has_spoiler = has_spoiler,
    caption = caption
  )
  RichBlockAnimation <- RichBlockAnimation[!unlist(lapply(
    RichBlockAnimation, is.null
  ))]

  structure(RichBlockAnimation, class = c("RichBlock", "RichBlockAnimation"))
}

#' @rdname RichBlockAnimation
#' @param x Object to be tested
#' @export
is.RichBlockAnimation <- function(x) inherits(x, "RichBlockAnimation")


#' Create a media block with audio
#'
#' A block with a music file, corresponding to `<audio>`.
#'
#' @param audio \code{\link{Audio}} The audio
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
RichBlockAudio <- function(audio, caption = NULL) {
  if (!is.list(audio)) {
    stop("`audio` must be an `Audio` object.")
  }

  RichBlockAudio <- list(
    type = "audio",
    audio = audio,
    caption = caption
  )
  RichBlockAudio <- RichBlockAudio[!unlist(lapply(
    RichBlockAudio, is.null
  ))]

  structure(RichBlockAudio, class = c("RichBlock", "RichBlockAudio"))
}

#' @rdname RichBlockAudio
#' @param x Object to be tested
#' @export
is.RichBlockAudio <- function(x) inherits(x, "RichBlockAudio")


#' Create a media block with document
#'
#' A block with a general file, corresponding to `<tg-document>`.
#'
#' @param document \code{\link{Document}} The document
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
RichBlockDocument <- function(document, caption = NULL) {
  if (!is.list(document)) {
    stop("`document` must be a `Document` object.")
  }

  RichBlockDocument <- list(
    type = "document",
    document = document,
    caption = caption
  )
  RichBlockDocument <- RichBlockDocument[!unlist(lapply(
    RichBlockDocument, is.null
  ))]

  structure(RichBlockDocument, class = c("RichBlock", "RichBlockDocument"))
}

#' @rdname RichBlockDocument
#' @param x Object to be tested
#' @export
is.RichBlockDocument <- function(x) inherits(x, "RichBlockDocument")


#' Create a media block with photo
#'
#' A block with a photo, corresponding to `<img>`.
#'
#' @param photo List of \code{\link{PhotoSize}} objects. Available sizes of the photo
#' @param has_spoiler (Optional). TRUE if the media preview is covered by a spoiler
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
RichBlockPhoto <- function(photo,
                           has_spoiler = NULL,
                           caption = NULL) {
  if (!is.list(photo)) {
    stop("`photo` must be a list of `PhotoSize` objects.")
  }

  RichBlockPhoto <- list(
    type = "photo",
    photo = photo,
    has_spoiler = has_spoiler,
    caption = caption
  )
  RichBlockPhoto <- RichBlockPhoto[!unlist(lapply(
    RichBlockPhoto, is.null
  ))]

  structure(RichBlockPhoto, class = c("RichBlock", "RichBlockPhoto"))
}

#' @rdname RichBlockPhoto
#' @param x Object to be tested
#' @export
is.RichBlockPhoto <- function(x) inherits(x, "RichBlockPhoto")


#' Create a media block with video
#'
#' A block with a video, corresponding to `<video>`.
#'
#' @param video \code{\link{Video}} The video
#' @param has_spoiler (Optional). TRUE if the media preview is covered by a spoiler
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
RichBlockVideo <- function(video,
                           has_spoiler = NULL,
                           caption = NULL) {
  if (!is.list(video)) {
    stop("`video` must be a `Video` object.")
  }

  RichBlockVideo <- list(
    type = "video",
    video = video,
    has_spoiler = has_spoiler,
    caption = caption
  )
  RichBlockVideo <- RichBlockVideo[!unlist(lapply(
    RichBlockVideo, is.null
  ))]

  structure(RichBlockVideo, class = c("RichBlock", "RichBlockVideo"))
}

#' @rdname RichBlockVideo
#' @param x Object to be tested
#' @export
is.RichBlockVideo <- function(x) inherits(x, "RichBlockVideo")


#' Create a media block with voice note
#'
#' A block with a voice note, corresponding to `<audio>`.
#'
#' @param voice_note \code{\link{Voice}} The voice note
#' @param caption (Optional). \code{\link{RichBlockCaption}} Caption of the block
#' @export
RichBlockVoiceNote <- function(voice_note, caption = NULL) {
  if (!is.list(voice_note)) {
    stop("`voice_note` must be a `Voice` object.")
  }

  RichBlockVoiceNote <- list(
    type = "voice_note",
    voice_note = voice_note,
    caption = caption
  )
  RichBlockVoiceNote <- RichBlockVoiceNote[!unlist(lapply(
    RichBlockVoiceNote, is.null
  ))]

  structure(RichBlockVoiceNote, class = c("RichBlock", "RichBlockVoiceNote"))
}

#' @rdname RichBlockVoiceNote
#' @param x Object to be tested
#' @export
is.RichBlockVoiceNote <- function(x) inherits(x, "RichBlockVoiceNote")


#' Create a thinking block
#'
#' A block with a "Thinking..." placeholder.
#' Used only in \code{\link{sendRichMessageDraft}}.
#'
#' @param text \code{\link{RichText}} Text of the block
#' @export
RichBlockThinking <- function(text) {
  structure(list(
    type = "thinking",
    text = text
  ), class = c("RichBlock", "RichBlockThinking"))
}

#' @rdname RichBlockThinking
#' @param x Object to be tested
#' @export
is.RichBlockThinking <- function(x) inherits(x, "RichBlockThinking")


#' Create a rich block
#'
#' This object represents a block in a rich formatted message. Use one of the
#' specific block constructors above.
#'
#' @param block A block object (one of the \code{RichBlock*} classes)
#' @export
RichBlock <- function(block) {
  if (!is.RichBlockList(block) &&
    !is.RichBlockParagraph(block) &&
    !is.RichBlockSectionHeading(block) &&
    !is.RichBlockPreformatted(block) &&
    !is.RichBlockFooter(block) &&
    !is.RichBlockDivider(block) &&
    !is.RichBlockMathematicalExpression(block) &&
    !is.RichBlockAnchor(block) &&
    !is.RichBlockBlockQuotation(block) &&
    !is.RichBlockExpandableBlockQuotation(block) &&
    !is.RichBlockPullQuotation(block) &&
    !is.RichBlockCollage(block) &&
    !is.RichBlockSlideshow(block) &&
    !is.RichBlockTable(block) &&
    !is.RichBlockDetails(block) &&
    !is.RichBlockMap(block) &&
    !is.RichBlockButtons(block) &&
    !is.RichBlockAnimation(block) &&
    !is.RichBlockAudio(block) &&
    !is.RichBlockDocument(block) &&
    !is.RichBlockPhoto(block) &&
    !is.RichBlockVideo(block) &&
    !is.RichBlockVoiceNote(block) &&
    !is.RichBlockThinking(block)) {
    stop("`block` must be a RichBlock object.")
  }

  structure(block, class = unique(class(block)))
}

#' @rdname RichBlock
#' @param x Object to be tested
#' @export
is.RichBlock <- function(x) inherits(x, "RichBlock")