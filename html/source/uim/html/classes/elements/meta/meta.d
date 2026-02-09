/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.meta.meta;

import uim.html;

mixin(ShowModule!());

@safe:

class Meta : HtmlElement {
  this() {
    super("meta");
    this.selfClosing(true);
  }

  // Factory methods
  static Meta opCall() {
    return new Meta();
  }

  // Factory methods
  static Meta opCall(string content) {
    auto html = new Meta();
    html.content(content);
    return html;
  }

}
///
unittest {
  assert(Meta() == "<meta></meta>");
  assert(Meta("Hello") == "<meta>Hello</meta>");
}
