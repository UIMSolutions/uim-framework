/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.p;

import uim.htmls;

@safe:

/// HTML paragraph element
class DP : DHtmlElement {
  this() {
    super("p");
  }
}

auto P() {
  return new DP();
}

auto P(string content) {
  auto element = new DP();
  element.text(content);
  return element;
}

unittest {
  auto p = P("Paragraph text");
  assert(p.toString() == "<p>Paragraph text</p>");
}
