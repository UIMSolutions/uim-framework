/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.fencedframe;

import uim.html;

mixin(ShowModule!());

@safe:

class Fencedframe : HtmlElement {
  this() {
    super("fencedframe");
    this.selfClosing(false);
  }

  static Fencedframe opCall() {
    return new Fencedframe();
  }

  static Fencedframe opCall(string content) {
    auto element = new Fencedframe();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Fencedframe() == "<fencedframe></fencedframe>");
  assert(Fencedframe("Hello") == "<fencedframe>Hello</fencedframe>");
}
