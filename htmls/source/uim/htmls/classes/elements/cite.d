/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.cite;

import uim.htmls;

@safe:

class DCite : DHtmlElement {
  this() {
    super("cite");
    this.selfClosing(false);
  }
}

auto Cite() {
  return new DCite();
}

auto Cite(string content) {
  auto element = new DCite();
  element.text(content);
  return element;
}

unittest {
  auto cite = Cite();
  assert(cite.toString() == "<cite></cite>");

  auto citeWithContent = Cite("Hello");
  assert(citeWithContent.toString() == "<cite>Hello</cite>");
}
