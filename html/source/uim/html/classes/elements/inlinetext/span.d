/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.span;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML span element
class H5Span : HtmlElement {
  this() {
    super("span");
  }
}

static H5Span opCall() {
  return new H5Span();
}

static H5Span opCall(string content) {
  auto element = new H5Span();
  element.content(content);
  return element;
}

unittest {
  // TODO: // TODO: assert(H5Span() == "<span></span>");
  // TODO: writeln(H5Span("Text"));
  // TODO: assert(H5Span("Text") == "<span>Text</span>");
}
