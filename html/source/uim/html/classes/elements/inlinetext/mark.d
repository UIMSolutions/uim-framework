/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.mark;

import uim.html;

mixin(ShowModule!());

@safe:

class Mark : HtmlElement {
  this() {
    super("mark");
    this.selfClosing(false);
  }

  static Mark opCall() {
    return new Mark();
  }

  static Mark opCall(string content) {
    auto element = new Mark();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Mark() == "<mark></mark>");
  assert(Mark("Hello") == "<mark>Hello</mark>");
}
