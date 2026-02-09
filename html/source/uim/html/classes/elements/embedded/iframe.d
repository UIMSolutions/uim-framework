/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.iframe;

import uim.html;

mixin(ShowModule!());

@safe:

class Iframe : HtmlElement {
  this() {
    super("iframe");
    this.selfClosing(false);
  }

  static Iframe opCall() {
    return new Iframe();
  }

  static Iframe opCall(string content) {
    auto element = new Iframe();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Iframe() == "<iframe></iframe>");
  assert(Iframe("Hello") == "<iframe>Hello</iframe>");
}
