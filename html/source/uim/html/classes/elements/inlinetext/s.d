/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.s;

import uim.html;

mixin(ShowModule!());

@safe:

class S : HtmlElement {
  this() {
    super("s");
    this.selfClosing(false);
  }

  static S opCall() {
    return new S();
  }

  static S opCall(string content) {
    auto element = new S();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(S() == "<s></s>");
  assert(S("Hello") == "<s>Hello</s>");
}
