/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.s;

import uim.html;

mixin(ShowModule!());

@safe:

class H5S : HtmlElement {
  this() {
    super("s");
    this.selfClosing(false);
  }

  static H5S opCall() {
    return new H5S();
  }

  static H5S opCall(string content) {
    auto element = new H5S();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(H5S() == "<s></s>");
  assert(H5S("Hello") == "<s>Hello</s>");
}
