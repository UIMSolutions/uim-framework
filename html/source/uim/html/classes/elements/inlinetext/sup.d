/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.sup;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <sup> HTML element specifies inline text which should be displayed as superscript for solely typographical reasons. 
  * It is typically used for footnotes, mathematical expressions, and other notations that require superscript formatting. 
  * The <sup> element does not affect the meaning of the text it contains, but it indicates that the text should be displayed in a smaller font size and positioned higher than the surrounding text.
  */
class H5Sup : HtmlElement {
  mixin(HtmlTemplate!(H5Sup, "Sup", "sup", false));
}
///
unittest {
  assert(H5Sup() == "<sup></sup>");
  assert(H5Sup("Hello") == "<sup>Hello</sup>");
  assert(H5Sup(["test"], "Hello") == `<sup class="test">Hello</sup>`);
}
