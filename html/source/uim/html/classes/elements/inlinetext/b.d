/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.b;

import uim.html;

mixin(ShowModule!());

@safe:

class B : HtmlElement {
  this() {
    super("b");
    this.selfClosing(false);
  }

  static B opCall() {
    return new B();
  }

  static B opCall(string content) {
    auto element = new B();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(B() == "<b></b>");
  assert(B("Hello") == "<b>Hello</b>");
}
