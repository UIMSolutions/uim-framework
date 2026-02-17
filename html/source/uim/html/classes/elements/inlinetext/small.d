/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.small;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <small> HTML element represents side comments and small print, including legal text, independent of its styled presentation. 
  * It is typically used to indicate fine print, disclaimers, or other secondary information that is not essential to the main content. 
  * The <small> element does not affect the meaning of the text it contains, but it indicates that the text should be displayed in a smaller font size than the surrounding text.
  *
  * Example usage:
  * <p>This is some text. <small>This is small print.</small></p>
  */
class H5Small : HtmlElement {
  mixin H5This!("small", false);

  mixin(H5Calls!("small"));
}
///
unittest {
  assert(H5Small() == "<small></small>");
  assert(H5Small("Hello") == "<small>Hello</small>");
  assert(H5Small(["test"], "Hello") == "<small>Hello</small>");
}
