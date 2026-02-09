/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.object;

import uim.html;

mixin(ShowModule!());

@safe:

class Object : HtmlElement {
  this() {
    super("object");
    this.selfClosing(false);
  }

  static Object opCall() {
    return new Object();
  }

  static Object opCall(string content) {
    auto element = new Object();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Object() == "<object></object>");
  assert(Object("Hello") == "<object>Hello</object>");
}
