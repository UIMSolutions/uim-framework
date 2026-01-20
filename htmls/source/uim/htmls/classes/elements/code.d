/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.code;

import uim.htmls;

@safe:

class DCode : DHtmlElement {
  this() {
    super("code");
    this.selfClosing(false);
  }
}

auto Code() {
  return new DCode();
}

auto Code(string content) {
  auto element = new DCode();
  element.text(content);
  return element;
}

unittest {
  auto code = Code();
  assert(code.toString() == "<code></code>");

  auto codeWithContent = Code("Hello");
  assert(codeWithContent.toString() == "<code>Hello</code>");
}
