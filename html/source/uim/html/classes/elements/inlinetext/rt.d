/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.rt;

import uim.html;

mixin(ShowModule!());

@safe:

class Rt : HtmlElement {
  this() {
    super("rt");
    this.selfClosing(false);
  }

  static Rt opCall() {
    return new Rt();
  }

  static Rt opCall(string content) {
    auto element = new Rt();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Rt() == "<rt></rt>");
  assert(Rt("Hello") == "<rt>Hello</rt>");
}
