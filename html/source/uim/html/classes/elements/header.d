/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.elements.header;

import uim.html;

mixin(ShowModule!());

@safe:

class Header : HtmlElement {
  this() {
    super("header");
    this.selfClosing(false);
  }
}

auto header() {
  return new Header();
}

auto header(string content) {
  auto element = new Header();
  element.text(content);
  return element;
}

unittest {
  auto header = header();
  assert(header.toString() == "<header></header>");

  auto headerWithContent = header("Hello");
  assert(headerWithContent.toString() == "<header>Hello</header>");
}
