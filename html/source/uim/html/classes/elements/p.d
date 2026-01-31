/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
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
  auto p = P("Paragraph text");
  assert(p.toString() == "<p>Paragraph text</p>");
}
