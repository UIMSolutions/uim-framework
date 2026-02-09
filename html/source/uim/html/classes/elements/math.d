/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.math;

import uim.html;

mixin(ShowModule!());

@safe:

class Math : HtmlElement {
  this() {
    super("math");
    this.selfClosing(false);
  }

  // Factory methods
  static Math opCall() {
    return new Math();
  }

  // Factory methods
  static Math opCall(string content) {
    auto element = new Math();
    element.content(content);
    return element;
  }

}
///
unittest {
  assert(Math() == "<math></math>");
  assert(Math("Hello") == "<math>Hello</math>");
}
