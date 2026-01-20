/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.header;

import uim.htmls;

@safe:

class DHeader : DHtmlElement {
  this() {
    super("header");
    this.selfClosing(false);
  }
}

auto Header() {
  return new DHeader();
}

auto Header(string content) {
  auto element = new DHeader();
  element.text(content);
  return element;
}

unittest {
  auto header = Header();
  assert(header.toString() == "<header></header>");

  auto headerWithContent = Header("Hello");
  assert(headerWithContent.toString() == "<header>Hello</header>");
}
