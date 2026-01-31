/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.elements.search;

import uim.html;

mixin(ShowModule!());

@safe:

class Search : HtmlElement {
  this() {
    super("search");
    this.selfClosing(false);
  }
}

auto search() {
  return new Search();
}

auto search(string content) {
  auto element = new Search();
  element.text(content);
  return element;
}

unittest {
  auto search = search();
  assert(search.toString() == "<search></search>");

  auto searchWithContent = search("Hello");
  assert(searchWithContent.toString() == "<search>Hello</search>");
}
