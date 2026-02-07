/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.header;

import uim.html;

mixin(ShowModule!());

@safe:

class Header : HtmlElement {
  this() {
    super("header");
    this.selfClosing(false);
  }

  static Header opCall() {
    return new Header();
  }

  static Header opCall(string content) {
    auto element = new Header();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Header() == "<header></header>");
  assert(Header("Hello") == "<header>Hello</header>");
}
