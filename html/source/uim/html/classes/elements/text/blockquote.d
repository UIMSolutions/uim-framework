/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.blockquote;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * Represents the HTML `<blockquote>` element, which is used to indicate that the enclosed text is an extended quotation. The content inside a `<blockquote>` element is typically indented from the left and right margins to visually distinguish it from the surrounding text.
  * 
  * The `<blockquote>` element can also include a `cite` attribute that specifies the source of the quotation, such as a URL or a reference to a document. This attribute provides additional context about the origin of the quoted material.
  * 
  * Browser support: All major browsers support the `<blockquote>` element.
  *
  * Examples:
  * ```html
  * <blockquote cite="https://example.com">
  *   This is a blockquote example.
  * </blockquote>
  * ```
  */
class H5Blockquote : HtmlElement {
  mixin H5This!("blockquote", false);

  H5Blockquote cite(string url) {
    attribute("cite", url);
    return this;
  }

  IHtmlAttribute cite() {
    return attribute("cite");
  }

  mixin(H5Calls!("blockquote"));
}
///
unittest {
  assert(H5Blockquote() == `<blockquote></blockquote>`);
   assert(H5Blockquote("Hello") == `<blockquote>Hello</blockquote>`);
    assert(H5Blockquote().cite("https://example.com") == `<blockquote cite="https://example.com"></blockquote>`);
}
