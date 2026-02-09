/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.source;

import uim.html;

mixin(ShowModule!());

@safe:

class Source : HtmlElement {
  this() {
    super("source");
    this.selfClosing(false);
  }

  static Source opCall() {
    return new Source();
  }

  static Source opCall(string content) {
    auto element = new Source();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Source() == "<source></source>");
  assert(Source("Hello") == "<source>Hello</source>");
}
