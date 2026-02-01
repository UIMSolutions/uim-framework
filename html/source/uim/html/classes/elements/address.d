/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.address;

import uim.html;

mixin(ShowModule!());

@safe:

class Address : HtmlElement {
  this() {
    super("address");
    this.selfClosing(false);
  }

  static Address opCall() {
    return new Address();
  }

  static Address opCall(string content) {
    auto element = new Address();
    element.content(content);
    return element;
  }

}
///
unittest {
  auto address = Address();
  assert(address == "<address></address>");

  auto addressWithContent = Address("Hello");
  assert(addressWithContent == "<address>Hello</address>");
}
