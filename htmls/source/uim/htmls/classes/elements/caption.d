/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.caption;

import uim.htmls;

@safe:

class DCaption : DHtmlElement {
  this() {
    super("caption");
    this.selfClosing(false);
  }
}

auto Caption() {
  return new DCaption();
}

auto Caption(string content) {
  auto element = new DCaption();
  element.text(content);
  return element;
}

unittest {
  auto caption = Caption();
  assert(caption.toString() == "<caption></caption>");

  auto captionWithContent = Caption("Hello");
  assert(captionWithContent.toString() == "<caption>Hello</caption>");
}
