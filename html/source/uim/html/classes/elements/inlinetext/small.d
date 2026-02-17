/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.small;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Small : HtmlElement {
  this() {
    super("small");
    this.selfClosing(false);
  }

  static H5Small opCall() {
    return new H5Small();
  }

  static H5Small opCall(string content) {
    auto element = new H5Small();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(H5Small() == "<small></small>");
  assert(H5Small("Hello") == "<small>Hello</small>");
}
