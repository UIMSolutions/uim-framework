/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.p;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML paragraph element
class P : HtmlElement {
  this() {
    super("p");
  }

  static P opCall() {
    return new P();
  }

  static P opCall(string content) {
    auto element = new P();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(P() == "<p></p>");
  assert(P("Paragraph text") == "<p>Paragraph text</p>");
}
