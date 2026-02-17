module uim.html.classes.elements.tables.th;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

import uim.html;

mixin(ShowModule!());

@safe:

/**  
  * Represents the HTML `<th>` element, which is used to define a header cell in an HTML table. The `<th>` element is typically used within a `<tr>` (table row) element and can be found in the header section of a table, often within a `<thead>` element, but it can also be used in the body or footer sections of a table.
  * 
  * The content inside a `<th>` element is usually displayed in bold and centered by default, distinguishing it from regular data cells defined by the `<td>` element. The `<th>` element can also have attributes such as `colspan`, `rowspan`, and `scope` to specify how the header cell should span across multiple columns or rows and to indicate the scope of the header.
  * 
  * Browser support: All major browsers support the `<th>` element.
  *
  * Examples:
  * ```html
  * <table>
  *   <thead>
  *     <tr><th>Header</th></tr>
  *   </thead>
  *   <tbody>
  *     <tr><td>Data</td></tr>
  *   </tbody>
  * </table>
  * ```
  */
class H5Th : HtmlElement {
  this() {
    super("th");
  }

  H5Th colspan(string value) {
    attribute("colspan", value);
    return this;
  }

  H5Th rowspan(string value) {
    attribute("rowspan", value);
    return this;
  }

  H5Th scope_(string value) {
    attribute("scope", value);
    return this;
  }

  static H5Th opCall() {
    return new H5Th();
  }

  static H5Th opCall(string content) {
    auto th = new H5Th();
    th.text(content);
    return th;
  }
}

unittest {
  assert(H5Th() == "<th></th>");
  assert(H5Th("Header") == "<th>Header</th>");
}
