/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
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

  static Search opCall() {
    return new Search();
  }

  static Search opCall(string content) {
    auto element = new Search();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Search() == "<search></search>");
  assert(Search("Hello") == "<search>Hello</search>");
}
