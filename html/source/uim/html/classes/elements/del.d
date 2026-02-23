/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.del;

import uim.html;

mixin(ShowModule!());

@safe:

/**   
  * Represents the HTML `<del>` element, which represents a range of text that has been deleted from a document. The content inside a `<del>` element is typically displayed with a strikethrough to indicate that it has been removed.
  * 
  * The `<del>` element is often used in conjunction with the `<ins>` element, which represents inserted text. Together, they can be used to show changes in a document, such as revisions or edits.
  * 
  * Browser support: All major browsers support the `<del>` element.
  *
  * Examples:
  * ```html
  * <p>This is an <del>old</del> sentence.</p>
  * ```
  */
class H5Del : HtmlElement {
  mixin(H5This!("del", false));

  mixin(AttributeMethods!H5Del);

  mixin(H5Calls!("del"));
}
///
unittest {
  assert(H5Del() == "<del></del>");
  assert(H5Del("Hello") == "<del>Hello</del>");
}
