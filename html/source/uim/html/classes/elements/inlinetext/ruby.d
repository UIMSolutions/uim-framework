/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.ruby;

import uim.html;

mixin(ShowModule!());

@safe:

class Ruby : HtmlElement {
  this() {
    super("ruby");
    this.selfClosing(false);
  }

  static Ruby opCall() {
    return new Ruby();
  }

  static Ruby opCall(string content) {
    auto element = new Ruby();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Ruby() == "<ruby></ruby>");
  assert(Ruby("Hello") == "<ruby>Hello</ruby>");
}
