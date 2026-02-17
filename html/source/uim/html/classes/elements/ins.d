/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.ins;

import uim.html;

mixin(ShowModule!());

@safe:

/**   
  * Represents the HTML `<ins>` element, which represents a range of text that has been inserted into a document. The content inside an `<ins>` element is typically displayed with an underline to indicate that it has been added.
  * 
  * The `<ins>` element is often used in conjunction with the `<del>` element, which represents deleted text. Together, they can be used to show changes in a document, such as revisions or edits.
  * 
  * Browser support: All major browsers support the `<ins>` element.
  *
  * Examples:
  * ```html
  * <p>This is an <ins>new</ins> sentence.</p>
  * ```
  */
class H5Ins : HtmlElement {
  this() {
    super("ins");
    this.selfClosing(false);
  }

  // Factory methods
  static H5Ins opCall() {
    return new H5Ins();
  }

  // Factory methods
  static H5Ins opCall(string content) {
    auto element = new H5Ins();
    element.content(content);
    return element;
  }

}
///
unittest {
  assert(H5Ins() == "<ins></ins>");
  assert(H5Ins("Hello") == "<ins>Hello</ins>");
}
