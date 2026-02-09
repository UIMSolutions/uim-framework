/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.col;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table cell element
class Col : HtmlElement {
  this() {
    super("col");
  }

  /// Sets the number of columns a cell should span. This attribute is only applicable to "td" and "th" elements.
  IHtmlElement colspan(string value) {
    attribute("colspan", value);
    return this;
  }

  IHtmlElement rowspan(string value) {
    attribute("rowspan", value);
    return this;
  }

  static Col opCall() {
    return new Col();
  }

  static Col opCall(string content) {
    auto col = new Col();
    col.text(content);
    return col;
  }
}

unittest {
  assert(Col("Cell content") == "<col>Cell content</col>");
  assert(Col() == "<col></col>");
}
