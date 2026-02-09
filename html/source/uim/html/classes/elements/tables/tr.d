/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.tr;

import uim.html;

mixin(ShowModule!());

@safe:

class Tr : HtmlElement {
  this() {
    super("tr");
  }

  static Tr opCall() {
    return new Tr();
  }

  static Tr opCall(string content) {
    auto html = new Tr();
    html.text(content);
    return html;
  }
}
///
unittest {
  assert(Tr() == "<tr></tr>");
  assert(Tr("Row content") == "<tr>Row content</tr>");
}
