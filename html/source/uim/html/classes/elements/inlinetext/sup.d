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
class Sup : HtmlElement {
  this() {
    super("sup");
    this.selfClosing(false);
  }

  static Sup opCall() {
    return new Sup();
  }

  static Sup opCall(string content) {
    auto element = new Sup();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Sup() == "<sup></sup>");
  assert(Sup("Hello") == "<sup>Hello</sup>");
}
