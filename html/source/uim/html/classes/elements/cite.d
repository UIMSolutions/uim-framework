/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.cite;

import uim.html;

mixin(ShowModule!());

@safe:

class Cite : HtmlElement {
  this() {
    super("cite");
    this.selfClosing(false);
  }

  static Cite opCall() {
    return new Cite();
  }

  static Cite opCall(string content) {
    auto element = new Cite();
    element.text(content);
    return element;
  }
}
///
unittest {
  auto cite = Cite();
  assert(cite.toString() == "<cite></cite>");

  auto citeWithContent = Cite("Hello");
  assert(citeWithContent == "<cite>Hello</cite>");
}
