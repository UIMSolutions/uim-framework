/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.small;

import uim.htmls;

@safe:

class DSmall : DHtmlElement {
  this() {
    super("small");
    this.selfClosing(false);
  }
}

auto Small() {
  return new DSmall();
}

auto Small(string content) {
  auto element = new DSmall();
  element.text(content);
  return element;
}

unittest {
  auto small = Small();
  assert(small.toString() == "<small></small>");

  auto smallWithContent = Small("Hello");
  assert(smallWithContent.toString() == "<small>Hello</small>");
}
