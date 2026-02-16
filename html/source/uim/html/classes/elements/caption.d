/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.caption;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Caption : HtmlElement {
  this() {
    super("caption");
    this.selfClosing(false);
  }

  static H5Caption opCall() {
    return new H5Caption();
  }

  static H5Caption opCall(string content) {
    auto element = new H5Caption();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(H5Caption() == "<caption></caption>");
  assert(H5Caption("Hello") == "<caption>Hello</caption>");
}
