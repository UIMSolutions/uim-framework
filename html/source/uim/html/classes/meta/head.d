/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.meta.head;

import uim.html;

@safe:

class DHead : DHtmlElement {
  this() {
    super("head");
    this.selfClosing(false);
  }
}

auto Head() {
  return new DHead();
}

auto Head(string content) {
  auto element = new DHead();
  element.text(content);
  return element;
}
///
unittest {
  auto head = Head("This is the head content");
  assert(head.toString() == `<head>This is the head content</head>`);
}