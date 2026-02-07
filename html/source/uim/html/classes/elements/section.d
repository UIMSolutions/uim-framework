/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.section;

import uim.html;

mixin(ShowModule!());

@safe:

class Section : HtmlElement {
  this() {
    super("section");
    this.selfClosing(false);
  }

  static Section opCall() {
    return new Section();
  }

  static Section opCall(string content) {
    auto element = new Section();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Section() == "<section></section>");
  assert(Section("Hello") == "<section>Hello</section>");
}
