/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.address;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Address : HtmlElement {
  mixin H5This!("address", false);

  // Factory methods
  static H5Address opCall() {
    return new H5Address();
  }

  // Factory methods
  static H5Address opCall(string content) {
    auto element = new H5Address();
    element.content(content);
    return element;
  }

}
///
unittest {
  assert(H5Address() == "<address></address>");
  assert(H5Address("Hello") == "<address>Hello</address>");
}
