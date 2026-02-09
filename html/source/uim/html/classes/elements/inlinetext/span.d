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
class Span : HtmlElement {
  this() {
    super("span");
  }
}

static Span opCall() {
  return new Span();
}

static Span opCall(string content) {
  auto element = new Span();
  element.content(content);
  return element;
}

unittest {
  // TODO: // TODO: assert(Span() == "<span></span>");
  // TODO: writeln(Span("Text"));
  // TODO: assert(Span("Text") == "<span>Text</span>");
}
