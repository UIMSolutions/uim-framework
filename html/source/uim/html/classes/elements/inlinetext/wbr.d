/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.wbr;

import uim.html;

mixin(ShowModule!());

@safe:

// The <wbr> HTML element represents a word break opportunity—a position within text where the browser may optionally break a line, though its line-breaking rules would not otherwise create a break at that location.
class Wbr : HtmlElement {
  this() {
    super("wbr");
    this.selfClosing(true);
  }

  static Wbr opCall() {
    return new Wbr();
  }

  static Wbr opCall(string content) {
    auto element = new Wbr();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Wbr() == "<wbr></wbr>");
  assert(Wbr("Hello") == "<wbr>Hello</wbr>");
}
