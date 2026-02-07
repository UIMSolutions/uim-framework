/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.caption;

import uim.html;

mixin(ShowModule!());

@safe:

class Caption : HtmlElement {
  this() {
    super("caption");
    this.selfClosing(false);
  }

  static Caption opCall() {
    return new Caption();
  }

  static Caption opCall(string content) {
    auto element = new Caption();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Caption() == "<caption></caption>");
  assert(Caption() == "<caption>Hello</caption>");
}
