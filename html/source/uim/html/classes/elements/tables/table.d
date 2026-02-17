/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.table;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <table> HTML element represents tabular data, which is data presented in a grid of rows and columns. 
  * It is used to organize and display information in a structured format. 
  * The <table> element can contain various child elements such as <caption>, <colgroup>, <thead>, <tbody>, <tfoot>, <tr>, <th>, and <td> to define the table's structure and content.
  *
  * Example usage:
  * <table border="1" cellspacing="0" cellpadding="5">
  *   <caption>Monthly Sales Report</caption>
  *   <tr>
  *     <th>Month</th>
  *     <th>Sales</th>
  *   </tr>
  *   <tr>
  *     <td>January</td>
  *     <td>$10,000</td>
  *   </tr>
  *   <tr>
  *     <td>February</td>
  *     <td>$12,000</td>
  *   </tr>
  * </table>
  */
class H5Table : HtmlElement {
  mixin H5This!("table", false);

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

  mixin(H5Calls!("table"));
}
///
unittest {
  mixin(ShowTest!"Testing Table Class");

  assert(H5Table() == "<table></table>");
}
