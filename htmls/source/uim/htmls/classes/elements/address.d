/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.address;

import uim.htmls;

@safe:

class DAddress : DHtmlElement {
  this() {
    super("address");
    this.selfClosing(false);
  }
}

auto Address() {
  return new DAddress();
}

auto Address(string content) {
  auto element = new DAddress();
  element.text(content);
  return element;
}

unittest {
  auto address = Address();
  assert(address.toString() == "<address></address>");

  auto addressWithContent = Address("Hello");
  assert(addressWithContent.toString() == "<address>Hello</address>");
}
