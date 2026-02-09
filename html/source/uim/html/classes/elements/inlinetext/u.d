/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.u;

import uim.html;

mixin(ShowModule!());

@safe:

class U : HtmlElement {
  this() {
    super("u");
    this.selfClosing(false);
  }

  static U opCall() {
    return new U();
  }

  static U opCall(string content) {
    auto element = new U();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(U() == "<u></u>");
  assert(U("Hello") == "<u>Hello</u>");
}
