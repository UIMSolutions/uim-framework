/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.footer;

import uim.htmls;

@safe:

class DFooter : DHtmlElement {
  this() {
    super("footer");
    this.selfClosing(false);
  }
}

auto Footer() {
  return new DFooter();
}

auto Footer(string content) {
  auto element = new DFooter();
  element.text(content);
  return element;
}

unittest {
  auto footer = Footer();
  assert(footer.toString() == "<footer></footer>");

  auto footerWithContent = Footer("Hello");
  assert(footerWithContent.toString() == "<footer>Hello</footer>");
}
