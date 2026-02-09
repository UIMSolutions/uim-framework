/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.samp;

import uim.html;

mixin(ShowModule!());

@safe:

class Samp : HtmlElement {
  this() {
    super("samp");
    this.selfClosing(false);
  }

  static Samp opCall() {
    return new Samp();
  }

  static Samp opCall(string content) {
    auto element = new Samp();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Samp() == "<samp></samp>");
  assert(Samp("Hello") == "<samp>Hello</samp>");
}
