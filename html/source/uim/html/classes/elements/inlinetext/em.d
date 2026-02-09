/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.em;

import uim.html;

mixin(ShowModule!());

@safe:

class DEm : HtmlElement {
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
  element.content(content);
  return element;
}

unittest {
  assert(Em() == "<em></em>");
  assert(Em("Hello") == "<em>Hello</em>");
}
