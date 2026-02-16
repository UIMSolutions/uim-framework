/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.math;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Math : HtmlElement {
  this() {
    super("math");
    this.selfClosing(false);
  }

  // Factory methods
  static H5Math opCall() {
    return new H5Math();
  }

  // Factory methods
  static H5Math opCall(string content) {
    auto element = new H5Math();
    element.content(content);
    return element;
  }

}
///
unittest {
  assert(H5Math() == "<math></math>");
  assert(H5Math("Hello") == "<math>Hello</math>");
}
