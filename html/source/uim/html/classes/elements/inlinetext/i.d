/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.i;

import uim.html;

mixin(ShowModule!());

@safe:

class I : HtmlElement {
  this() {
    super("i");
    this.selfClosing(false);
  }

  static I opCall() {
    return new I();
  }

  static I opCall(string content) {
    auto element = new I();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(I() == "<i></i>");
  assert(I("Hello") == "<i>Hello</i>");
}
