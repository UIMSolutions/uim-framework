
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.elements.a;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML anchor (link) element
class A : HtmlElement {
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

auto a() {
  return new AElement();
}

auto a(string url, string text = null) {
  auto element = new AElement();
  element.href(url);
  if (text)
    element.text(text);
  return element;
}

unittest {
  auto link = a("https://example.com", "Example");
  assert(link.toString() == `<a href="https://example.com">Example</a>`);
}
