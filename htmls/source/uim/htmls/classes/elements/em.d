/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.em;

import uim.htmls;

@safe:

class DEm : DHtmlElement {
  this() {
    super("em");
    this.selfClosing(false);
  }
}

auto Em() {
  return new DEm();
}

auto Em(string content) {
  auto element = new DEm();
  element.text(content);
  return element;
}

unittest {
  auto em = Em();
  assert(em.toString() == "<em></em>");

  auto emWithContent = Em("Hello");
  assert(emWithContent.toString() == "<em>Hello</em>");
}
