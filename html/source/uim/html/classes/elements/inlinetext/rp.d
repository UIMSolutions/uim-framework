/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.rp;

import uim.html;

mixin(ShowModule!());

@safe:

class Rp : HtmlElement {
  this() {
    super("rp");
    this.selfClosing(false);
  }

  static Rp opCall() {
    return new Rp();
  }

  static Rp opCall(string content) {
    auto element = new Rp();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Rp() == "<rp></rp>");
  assert(Rp("Hello") == "<rp>Hello</rp>");
}
