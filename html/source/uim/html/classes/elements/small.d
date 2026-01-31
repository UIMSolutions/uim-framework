/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.elements.small;

import uim.html;

mixin(ShowModule!());

@safe:

class Small : HtmlElement {
  this() {
    super("small");
    this.selfClosing(false);
  }
}

auto small() {
  return new Small();
}

auto small(string content) {
  auto element = new Small();
  element.text(content);
  return element;
}

unittest {
  auto small = small();
  assert(small.toString() == "<small></small>");

  auto smallWithContent = small("Hello");
  assert(smallWithContent.toString() == "<small>Hello</small>");
}
