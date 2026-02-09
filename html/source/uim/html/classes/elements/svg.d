/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.svg;

import uim.html;

mixin(ShowModule!());

@safe:

class Svg : HtmlElement {
  this() {
    super("svg");
    this.selfClosing(false);
  }

  // Factory methods
  static Svg opCall() {
    return new Svg();
  }

  // Factory methods
  static Svg opCall(string content) {
    auto element = new Svg();
    element.content(content);
    return element;
  }

}
///
unittest {
  assert(Svg() == "<svg></svg>");
  assert(Svg("Hello") == "<svg>Hello</svg>");
}
