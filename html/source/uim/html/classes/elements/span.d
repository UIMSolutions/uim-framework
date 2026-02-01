/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.span;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML span element
class Span : HtmlElement {
  this() {
    super("span");
  }
}

auto span() {
  return new Span();
}

auto span(string content) {
  auto element = new Span();
  element.text(content);
  return element;
}

unittest {
  auto span = span("Text");
  assert(span.toString() == "<span>Text</span>");
}
