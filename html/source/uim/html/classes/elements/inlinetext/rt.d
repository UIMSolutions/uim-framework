/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.rt;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Rt : HtmlElement {
  this() {
    super("rt");
    this.selfClosing(false);
  }

  static H5Rt opCall() {
    return new H5Rt();
  }

  static H5Rt opCall(string content) {
    auto element = new H5Rt();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(H5Rt() == "<rt></rt>");
  assert(H5Rt("Hello") == "<rt>Hello</rt>");
}
