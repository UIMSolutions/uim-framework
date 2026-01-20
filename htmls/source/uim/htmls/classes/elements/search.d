/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.search;

import uim.htmls;

@safe:

class DSearch : DHtmlElement {
  this() {
    super("search");
    this.selfClosing(false);
  }
}

auto Search() {
  return new DSearch();
}

auto Search(string content) {
  auto element = new DSearch();
  element.text(content);
  return element;
}

unittest {
  auto search = Search();
  assert(search.toString() == "<search></search>");

  auto searchWithContent = Search("Hello");
  assert(searchWithContent.toString() == "<search>Hello</search>");
}
