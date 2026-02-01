/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.aside;

import uim.html;

mixin(ShowModule!());

@safe:

class Aside : HtmlElement {
  this() {
    super("aside");
    this.selfClosing(false);
  }

  static Aside opCall() {
    return new Aside();
  }

  static Aside opCall(string content) {
    auto element = new Aside();
    element.text(content);
    return element;
  }
}
///
unittest {
  auto aside = Aside();
  assert(aside.toString() == "<aside></aside>");

  auto asideWithContent = Aside("Hello");
  assert(asideWithContent.toString() == "<aside>Hello</aside>");
}
