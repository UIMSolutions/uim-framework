
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.div;

import uim.htmls;

@safe:

/// HTML div element
class DDiv : DHtmlElement {
  this() {
    super("div");
  }
}

auto Div() {
  return new DDiv();
}

auto Div(string content) {
  auto element = new DDiv();
  element.text(content);
  return element;
}

unittest {
  auto div = Div();
  assert(div.toString() == "<div></div>");

  auto divWithContent = Div("Hello");
  assert(divWithContent.toString() == "<div>Hello</div>");
}
