/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.del;

import uim.html;

mixin(ShowModule!());

@safe:

class Del : HtmlElement {
  this() {
    super("del");
    this.selfClosing(false);
  }

  // Factory methods
  static Del opCall() {
    return new Del();
  }

  // Factory methods
  static Del opCall(string content) {
    auto element = new Del();
    element.content(content);
    return element;
  }

}
///
unittest {
  assert(Del() == "<del></del>");
  assert(Del("Hello") == "<del>Hello</del>");
}
