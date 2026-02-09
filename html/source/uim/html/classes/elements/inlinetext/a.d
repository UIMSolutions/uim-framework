/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.a;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML anchor (link) element
class A : HtmlElement {
  this() {
    super("a");
  }

  // Setting the href attribute
  IHtmlElement href(string url) {
    attribute("href", url);
    return this;
  }

  // Setting the target attribute
  IHtmlElement target(string targetValue) {
    attribute("target", targetValue);
    return this;
  }

  // Setting target="_blank"
  IHtmlElement targetBlank() {
    return target("_blank");
  }

  static IHtmlElement opCall() {
    return new A();
  }

  static IHtmlElement opCall(string url, string text) {
    auto link = new A();
    link.href(url);
    link.text(text);
    return link;
  }
}
///
unittest {
  auto link = A("https://example.com", "Example");
  assert(link.toString() == `<a href="https://example.com">Example</a>`);
}
