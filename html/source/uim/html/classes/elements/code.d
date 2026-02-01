/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.code;

import uim.html;

mixin(ShowModule!());

@safe:

class Code : HtmlElement {
  this() {
    super("code");
    this.selfClosing(false);
  }

  static Code opCall() {
    return new Code();
  }

  static Code opCall(string content) {
    auto element = new Code();
    element.text(content);
    return element;
  }
}
///
unittest {
  auto code = Code();
  assert(code.toString() == "<code></code>");

  auto codeWithContent = Code("Hello");
  assert(codeWithContent == "<code>Hello</code>");
}
