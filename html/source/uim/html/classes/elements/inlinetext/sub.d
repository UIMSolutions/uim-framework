/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.sub;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <sub> HTML element specifies inline text which should be displayed as subscript for solely typographical reasons. 
  * It is typically used for chemical formulas, mathematical expressions, and other notations that require subscript formatting. 
  * The <sub> element does not affect the meaning of the text it contains, but it indicates that the text should be displayed in a smaller font size and positioned lower than the surrounding text.
  */
class Sub : HtmlElement {
  this() {
    super("sub");
    this.selfClosing(false);
  }

  static Sub opCall() {
    return new Sub();
  }

  static Sub opCall(string content) {
    auto element = new Sub();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Sub() == "<sub></sub>");
  assert(Sub("Hello") == "<sub>Hello</sub>");
}
