/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.div;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML div element
class Div : HtmlElement {
  this() {
    super("div");
  }

  bool opEquals(R)(string html) const {
    return this.toString() == html;
  }
  
  static Div opCall() {
    return new Div();
  }

  static Div opCall(string content) {
    auto element = new Div();
    element.text(content);
    return element;
  }
}
///
unittest {
  // TODO: assert(Div() == "<div></div>");
  // TODO: assert(Div("Hello") == "<div>Hello</div>");
}
