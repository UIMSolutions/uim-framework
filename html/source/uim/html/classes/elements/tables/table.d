/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.table;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML table element
class Table : HtmlElement {
  this() {
    super("table");
  }

  ///  Gets or sets the border width of a table. This attribute is only applicable to "table" elements.
  IHtmlElement border(string borderValue) {
    attribute("border", borderValue);
    return this;
  }

  ///   Gets or sets the amount of space between the borders of adjacent cells in a table. This attribute is only applicable to "table" elements.
  IHtmlElement cellspacing(string value) {
    attribute("cellspacing", value);
    return this;
  }

  /// Gets or sets the amount of space between the borders of adjacent cells in a table. This attribute is only applicable to "table" elements.
  IHtmlElement cellpadding(string value) {
    attribute("cellpadding", value);
    return this;
  }

  static Table opCall() {
    return new Table();
  }
}
///
unittest {
  mixin(ShowTest!"Testing Table Class");

  assert(Table() == "<table></table>");
}
