/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.ins;

import uim.html;

mixin(ShowModule!());

@safe:

class Ins : HtmlElement {
  this() {
    super("ins");
    this.selfClosing(false);
  }

  // Factory methods
  static Ins opCall() {
    return new Ins();
  }

  // Factory methods
  static Ins opCall(string content) {
    auto element = new Ins();
    element.content(content);
    return element;
  }

}
///
unittest {
  assert(Ins() == "<ins></ins>");
  assert(Ins("Hello") == "<ins>Hello</ins>");
}
