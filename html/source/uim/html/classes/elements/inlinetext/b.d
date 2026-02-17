/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.b;

import uim.html;

mixin(ShowModule!());

@safe:

class H5B : HtmlElement {
  mixin H5This!("b", false);

  static H5B opCall() {
    return new H5B();
  }

  static H5B opCall(string content) {
    auto element = new H5B();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(H5B() == "<b></b>");
  assert(H5B("Hello") == "<b>Hello</b>");
}
