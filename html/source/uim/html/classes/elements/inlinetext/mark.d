/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.mark;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * The <mark> HTML element represents text that is marked or highlighted for reference or notation purposes. 
  * It is typically used to indicate a portion of text that has been highlighted by the user or to draw attention to specific content within a document.
  * The content inside the <mark> element is usually displayed with a yellow background by browsers, but the exact presentation may vary based on the browser's default styles and any additional CSS applied.
  *
  * Example usage:
  * <p>This is a <mark>highlighted</mark> word.</p>
  */
class H5Mark : HtmlElement {
  mixin H5This!("mark", false);

  mixin(H5Calls!("mark"));
}
///
unittest {
  assert(H5Mark() == "<mark></mark>");
  assert(H5Mark("Hello") == "<mark>Hello</mark>");
}
