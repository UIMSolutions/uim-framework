/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.header;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Header : HtmlElement {
  mixin H5This!("header", false);

  static H5Header opCall() {
    return new H5Header();
  }

  static H5Header opCall(string content) {
    auto element = new H5Header();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(H5Header() == "<header></header>");
  assert(H5Header("Hello") == "<header>Hello</header>");
}
