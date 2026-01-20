/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.aside;

import uim.htmls;

@safe:

class DAside : DHtmlElement {
  this() {
    super("aside");
    this.selfClosing(false);
  }
}

auto Aside() {
  return new DAside();
}

auto Aside(string content) {
  auto element = new DAside();
  element.text(content);
  return element;
}

unittest {
  auto aside = Aside();
  assert(aside.toString() == "<aside></aside>");

  auto asideWithContent = Aside("Hello");
  assert(asideWithContent.toString() == "<aside>Hello</aside>");
}
