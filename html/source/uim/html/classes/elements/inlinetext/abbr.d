/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.abbr;

import uim.html;

mixin(ShowModule!());

@safe:

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
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Abbr() == "<abbr></abbr>");
  assert(Abbr("Hello") == "<abbr>Hello</abbr>");
}
