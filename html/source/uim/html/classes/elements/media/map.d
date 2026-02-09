/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.map;

import uim.html;

mixin(ShowModule!());

@safe:

class Map : HtmlElement {
  this() {
    super("map");
    this.selfClosing(false);
  }

  static Map opCall() {
    return new Map();
  }

  static Map opCall(string content) {
    auto element = new Map();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Map() == "<map></map>");
  assert(Map("Hello") == "<map>Hello</map>");
}
