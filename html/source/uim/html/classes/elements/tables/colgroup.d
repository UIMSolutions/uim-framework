/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.colgroup;

import uim.html;

mixin(ShowModule!());

@safe:

class Colgroup : HtmlElement {
  this() {
    super("colgroup");
  }

  static Colgroup opCall() {
    return new Colgroup();
  }

  static Colgroup opCall(string content) {
    auto html = new Colgroup();
    html.text(content);
    return html;
  }
}
///
unittest {
  assert(Colgroup() == "<colgroup></colgroup>");
  assert(Colgroup("Something") == "<colgroup>Something</colgroup>");
}
