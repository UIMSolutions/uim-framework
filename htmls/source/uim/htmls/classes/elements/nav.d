/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.nav;

import uim.htmls;

@safe:

class DNav : DHtmlElement {
  this() {
    super("nav");
    this.selfClosing(false);
  }
}

auto Nav() {
  return new DNav();
}

auto Nav(string content) {
  auto element = new DNav();
  element.text(content);
  return element;
}

unittest {
  auto nav = Nav();
  assert(nav.toString() == "<nav></nav>");

  auto navWithContent = Nav("Hello");
  assert(navWithContent.toString() == "<nav>Hello</nav>");
}
