/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.bdi;

import uim.html;

mixin(ShowModule!());

@safe:

class Bdi : HtmlElement {
  this() {
    super("bdi");
    this.selfClosing(false);
  }

  static Bdi opCall() {
    return new Bdi();
  }

  static Bdi opCall(string content) {
    auto element = new Bdi();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Bdi() == "<bdi></bdi>");
  assert(Bdi("Hello") == "<bdi>Hello</bdi>");
}
