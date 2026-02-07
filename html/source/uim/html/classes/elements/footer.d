/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.footer;

import uim.html;

mixin(ShowModule!());

@safe:

class Footer : HtmlElement {
  this() {
    super("footer");
    this.selfClosing(false);
  }

  static Footer opCall() {
    return new Footer();
  }

  static Footer opCall(string content) {
    auto element = new Footer();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Footer() == "<footer></footer>");
  assert(Footer("Hello") == "<footer>Hello</footer>");
}
