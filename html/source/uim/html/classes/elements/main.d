/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.main;

import uim.html;

mixin(ShowModule!());

@safe:

class Main : HtmlElement {
  this() {
    super("main");
    this.selfClosing(false);
  }

  static Main opCall() {
    return new Main();
  }

  static Main opCall(string content) {
    auto element = new Main();
    element.content(content);
    return element;
  }
}
///
unittest {
  auto main = Main();
  assert(main.toString() == "<main></main>");

  auto mainWithContent = Main("Hello");
  assert(mainWithContent.toString() == "<main>Hello</main>");
}
