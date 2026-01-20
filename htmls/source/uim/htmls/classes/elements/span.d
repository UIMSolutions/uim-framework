/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.span;

import uim.htmls;

@safe:

/// HTML span element
class DSpan : DHtmlElement {
  this() {
    super("span");
  }
}

auto Span() {
  return new DSpan();
}

auto Span(string content) {
  auto element = new DSpan();
  element.text(content);
  return element;
}

unittest {
  auto span = Span("Text");
  assert(span.toString() == "<span>Text</span>");
}
