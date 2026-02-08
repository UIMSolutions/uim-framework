/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.dfn;

import uim.html;

mixin(ShowModule!());

@safe:

class Dfn : HtmlElement {
  this() {
    super("dfn");
    this.selfClosing(false);
  }

  static Dfn opCall() {
    return new Dfn ();
  }

  static Dfn opCall(string content) {
    auto element = new Dfn();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Dfn() == "<dfn></dfn>");
  assert(Dfn("Hello") == "<dfn>Hello</dfn>");
}
