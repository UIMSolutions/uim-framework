/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.ruby;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Ruby : HtmlElement {
  this() {
    super("ruby");
    this.selfClosing(false);
  }

  static H5Ruby opCall() {
    return new H5Ruby();
  }

  static H5Ruby opCall(string content) {
    auto element = new H5Ruby();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(H5Ruby() == "<ruby></ruby>");
  assert(H5Ruby("Hello") == "<ruby>Hello</ruby>");
}
