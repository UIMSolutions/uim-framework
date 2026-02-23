/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.tr;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * Represents the HTML `<tr>` element, which defines a row in an HTML table. The `<tr>` element is used within the `<thead>`, `<tbody>`, and `<tfoot>` elements to group rows of a table's header, body, and footer sections, respectively.
  * 
  * The content inside a `<tr>` element consists of one or more `<td>` (table data) or `<th>` (table header) elements that define the individual cells of the table row.
  * 
  * Browser support: All major browsers support the `<tr>` element.
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
class H5Tr : HtmlElement {
  mixin(H5This!("tr", false));

  mixin(AttributeMethods!H5Tr);

  mixin(H5Calls!("tr"));
}
///
unittest {
  assert(H5Tr() == "<tr></tr>");
  assert(H5Tr("Row content") == "<tr>Row content</tr>");
}
