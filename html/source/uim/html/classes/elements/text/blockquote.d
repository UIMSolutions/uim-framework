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
@UDAStringAttribute("cite")
class H5Blockquote : HtmlElement {
  mixin(HtmlTemplate!(H5Blockquote, "Blockquote", "blockquote", false));
}
///
unittest {
  assert(H5Blockquote() == `<blockquote></blockquote>`);
  assert(H5Blockquote(["testclass"]) == `<blockquote class="testclass"></blockquote>`);
  assert(H5Blockquote(["a": "b"]) == `<blockquote a="b"></blockquote>`);
  assert(H5Blockquote(["testclass"], ["a": "b"]) == `<blockquote class="testclass" a="b"></blockquote>`);

  assert(H5Blockquote("Hello") == `<blockquote>Hello</blockquote>`);
  assert(H5Blockquote(["testclass"], "Hello") == `<blockquote class="testclass">Hello</blockquote>`);
  assert(H5Blockquote(["a": "b"], "Hello") == `<blockquote a="b">Hello</blockquote>`);

  assert(H5Blockquote(["testclass"], ["a": "b"], "Hello") == `<blockquote class="testclass" a="b">Hello</blockquote>`);

  assert(H5Blockquote()
      .cite("https://example.com") == `<blockquote cite="https://example.com"></blockquote>`);
}
