
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.a;

import uim.htmls;

@safe:

/// HTML anchor (link) element
class DA : DHtmlElement {
  this() {
    super("a");
  }

  IHtmlElement href(string url) {
    attribute("href", url);
    return this;
  }

  IHtmlElement target(string targetValue) {
    attribute("target", targetValue);
    return this;
  }

  IHtmlElement targetBlank() {
    return target("_blank");
  }
}

auto A() {
  return new DA();
}

auto A(string url, string text = null) {
  auto element = new DA();
  element.href(url);
  if (text)
    element.text(text);
  return element;
}

unittest {
  auto link = A("https://example.com", "Example");
  assert(link.toString() == `<a href="https://example.com">Example</a>`);
}
