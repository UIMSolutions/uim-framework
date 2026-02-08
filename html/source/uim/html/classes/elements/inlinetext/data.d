/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.data;

import uim.html;

mixin(ShowModule!());

@safe:

class Data : HtmlElement {
  this() {
    super("data");
    this.selfClosing(false);
  }

  static Data opCall() {
    return new Data();
  }

  static Data opCall(string content) {
    auto element = new Data();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Data() == "<data></data>");
  assert(Data("Hello") == "<data>Hello</data>");
}
