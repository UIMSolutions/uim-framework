/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.area;

import uim.html;

mixin(ShowModule!());

@safe:

class Area : HtmlElement {
  this() {
    super("area");
    this.selfClosing(false);
  }

  static Area opCall() {
    return new Area();
  }

  static Area opCall(string content) {
    auto element = new Area();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Area() == "<area></area>");
  assert(Area("Hello") == "<area>Hello</area>");
}
