/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.sub;

import uim.html;

mixin(ShowModule!());

@safe:

// The <sub> HTML element defines subscript text. Subscripts are typically used for chemical formulas, like this: "H<sub>2</sub>O".
class Abbr : HtmlElement {
  this() {
    super("abbr");
    this.selfClosing(false);
  }

  static Abbr opCall() {
    return new Abbr();
  }

  static Abbr opCall(string content) {
    auto element = new Abbr();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Abbr() == "<abbr></abbr>");
  assert(Abbr("Hello") == "<abbr>Hello</abbr>");
}
