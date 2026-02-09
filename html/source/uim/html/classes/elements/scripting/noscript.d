/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.scripting.noscript;

import uim.html;

mixin(ShowModule!());

@safe:

class Noscript : HtmlElement {
  this() {
    super("noscript");
    this.selfClosing(false);
  }

  // Factory methods
  static Noscript opCall() {
    return new Noscript();
  }

  // Factory methods
  static Noscript opCall(string content) {
    auto element = new Noscript();
    element.content(content);
    return element;
  }

}
///
unittest {
  assert(Noscript() == "<noscript></noscript>");
  assert(Noscript("Hello") == "<noscript>Hello</noscript>");
}
