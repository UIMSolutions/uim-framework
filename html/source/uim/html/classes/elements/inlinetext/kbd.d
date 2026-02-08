/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.kbd;

import uim.html;

mixin(ShowModule!());

@safe:

class Kbd : HtmlElement {
  this() {
    super("kbd");
    this.selfClosing(false);
  }

  static Kbd opCall() {
    return new Kbd();
  }

  static Kbd opCall(string content) {
    auto element = new Kbd();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Kbd() == "<kbd></kbd>");
  assert(Kbd("Hello") == "<kbd>Hello</kbd>");
}
