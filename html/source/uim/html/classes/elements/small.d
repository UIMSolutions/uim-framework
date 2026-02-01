/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.small;

import uim.html;

mixin(ShowModule!());

@safe:

class Small : HtmlElement {
  this() {
    super("small");
    this.selfClosing(false);
  }

  static Small opCall() {
    return new Small();
  }

  static Small opCall(string content) {
    auto element = new Small();
    element.text(content);
    return element;
  }
}
///
unittest {
  auto small = Small();
  assert(small == "<small></small>");

  auto smallWithContent = Small("Hello");
  assert(smallWithContent == "<small>Hello</small>");
}
