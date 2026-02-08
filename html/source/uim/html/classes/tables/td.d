module uim.html.classes.tables.td;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table cell element
class Td : HtmlElement {
  this() {
    super("td");
  }

  IHtmlElement colspan(string value) {
    attribute("colspan", value);
    return this;
  }

  IHtmlElement rowspan(string value) {
    attribute("rowspan", value);
    return this;
  }

  static Td opCall() {
    return new Td();
  }

  static Td opCall(string content) {
    auto td = new Td();
    td.text(content);
    return td;
  }
}
///
unittest {
  assert(Td() == "<td></td>");
  assert(Td("Cell content") == "<td>Cell content</td>");
}
