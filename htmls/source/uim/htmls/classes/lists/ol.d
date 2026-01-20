/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.lists.ol;

import uim.htmls;

@safe:

/// HTML ordered list element
class DOl : DHtmlElement {
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

auto Ol() {
  return new DOl();
}

unittest {
  auto ol = Ol();
  assert(ol.toString() == "<ol></ol>");
}
