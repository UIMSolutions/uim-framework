/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.lists.ol;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML ordered list element
class Ol : HtmlElement {
  this() {
    super("ol");
  }

  IHtmlElement type(string listType) {
    attribute("type", listType);
    return this;
  }

  IHtmlAttribute type() {
    return attribute("type");
  }

  IHtmlElement start(string startValue) {
    attribute("start", startValue);
    return this;
  }

  IHtmlAttribute start() {
    return attribute("start");
  }
}

auto ol() {
  return new Ol();
}

unittest {
  auto ol = ol();
  assert(ol.toString() == "<ol></ol>");
}
