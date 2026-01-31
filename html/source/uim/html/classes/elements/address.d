/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
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
}

auto address() {
  return new Address();
}

auto address(string content) {
  auto element = new Address();
  element.text(content);
  return element;
}

unittest {
  auto address = address();
  assert(address.toString() == "<address></address>");

  auto addressWithContent = address("Hello");
  assert(addressWithContent.toString() == "<address>Hello</address>");
}
