/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.main;

import uim.htmls;

@safe:

class DMain : DHtmlElement {
  this() {
    super("main");
    this.selfClosing(false);
  }
}

auto Main() {
  return new DMain();
}

auto Main(string content) {
  auto element = new DMain();
  element.text(content);
  return element;
}

unittest {
  auto main = Main();
  assert(main.toString() == "<main></main>");

  auto mainWithContent = Main("Hello");
  assert(mainWithContent.toString() == "<main>Hello</main>");
}
