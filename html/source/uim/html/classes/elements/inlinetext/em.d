/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.em;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <em> HTML element represents emphasized text. 
  * The content inside is typically displayed in italics by browsers, but the exact presentation may vary based on the browser's default styles and any additional CSS applied. 
  * The <em> element is used to indicate that the text it contains should be emphasized or stressed in some way, which can be important for conveying meaning or tone in written content.
  *
  * Example usage:
  * <p>This is an <em>important</em> message.</p>
  */
class H5Em : HtmlElement {
  mixin(H5This!("em", false));

  mixin(AttributeMethods!H5Em);

  mixin(H5Calls!("em"));
}

unittest {
  assert(H5Em() == "<em></em>");
  assert(H5Em("Hello") == "<em>Hello</em>");
}
