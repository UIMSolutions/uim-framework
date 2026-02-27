/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.tfoot;

import uim.html;

mixin(ShowModule!());

@safe:

/**   
  * Represents the HTML `<tfoot>` element, which is used to group the footer content in an HTML table. The `<tfoot>` element is typically used in conjunction with the `<thead>` and `<tbody>` elements to structure a table into distinct sections: the header, body, and footer.
  * 
  * The content inside a `<tfoot>` element consists of one or more `<tr>` (table row) elements, which in turn contain `<td>` (table data) or `<th>` (table header) elements that define the individual cells of the table.
  * 
  * Browser support: All major browsers support the `<tfoot>` element.
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
  *   <tfoot>
  *     <tr><td>Footer</td></tr>
  *   </tfoot>
  * </table>
  * ```
  */
class H5Tfoot : HtmlElement {
  mixin(H5Template!("Tfoot", "tfoot", false));
  mixin(HtmlMethods!H5Tfoot);
}
///
unittest {
  assert(H5Tfoot() == `<tfoot></tfoot>`);
  assert(H5Tfoot(["testclass"]) == `<tfoot class="testclass"></tfoot>`);
  assert(H5Tfoot(["a":"b"]) == `<tfoot a="b"></tfoot>`);
  assert(H5Tfoot(["testclass"], ["a":"b"]) == `<tfoot class="testclass" a="b"></tfoot>`);

  assert(H5Tfoot("Hello") == `<tfoot>Hello</tfoot>`);
  assert(H5Tfoot(["testclass"], "Hello") == `<tfoot class="testclass">Hello</tfoot>`);
  assert(H5Tfoot(["a":"b"], "Hello") == `<tfoot a="b">Hello</tfoot>`);

  assert(H5Tfoot(["testclass"], ["a":"b"], "Hello") == `<tfoot class="testclass" a="b">Hello</tfoot>`);
}
