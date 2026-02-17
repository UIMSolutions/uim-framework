module uim.html.classes.elements.tables.tbody;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

import uim.html;

mixin(ShowModule!());

@safe:

/**   
  * Represents the HTML `<tbody>` element, which is used to group the body content in an HTML table. The `<tbody>` element is typically used in conjunction with the `<thead>` and `<tfoot>` elements to structure a table into distinct sections: the header, body, and footer.
  * 
  * The content inside a `<tbody>` element consists of one or more `<tr>` (table row) elements, which in turn contain `<td>` (table data) or `<th>` (table header) elements that define the individual cells of the table.
  * 
  * Browser support: All major browsers support the `<tbody>` element.
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
class H5Tbody : HtmlElement {
  mixin H5This!("tbody", false);

  mixin(H5Calls!("tbody"));
}
///
unittest {
  assert(H5Tbody() == "<tbody></tbody>");
  assert(H5Tbody("Hello") == "<tbody>Hello</tbody>");
  assert(H5Tbody(["test"], "Hello") == `<tbody class="test">Hello</tbody>`);
  assert(H5Tbody(["a": "b"], "Hello") == `<tbody a="b">Hello</tbody>`);
  assert(H5Tbody(["test"], ["a": "b"], "Hello") == `<tbody class="test" a="b">Hello</tbody>`);
}
