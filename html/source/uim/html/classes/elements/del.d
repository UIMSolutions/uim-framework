/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.del;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Del : HtmlElement {
 mixin H5This!("del", false);

  // Factory methods
  static H5Del opCall() {
    return new H5Del();
  }

  // Factory methods
  static H5Del opCall(string content) {
    auto element = new H5Del();
    element.content(content);
    return element;
  }

}
///
unittest {
  assert(H5Del() == "<del></del>");
  assert(H5Del("Hello") == "<del>Hello</del>");
}
