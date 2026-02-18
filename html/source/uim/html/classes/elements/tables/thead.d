/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.thead;

import uim.html;

mixin(ShowModule!());

@safe:

/**   
  * Represents the HTML `<thead>` element, which is used to group the header content in an HTML table. The `<thead>` element is typically used in conjunction with the `<tbody>` and `<tfoot>` elements to structure a table into distinct sections: the header, body, and footer.
  * 
  * The content inside a `<thead>` element consists of one or more `<tr>` (table row) elements, which in turn contain `<td>` (table data) or `<th>` (table header) elements that define the individual cells of the table.
  * 
  * Browser support: All major browsers support the `<thead>` element.
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
class H5Thead : HtmlElement {
    mixin H5This!("thead", false);


    mixin(H5Calls!("thead"));
}
///
unittest {
    assert(H5Thead() == "<thead></thead>");
    assert(H5Thead("Hello") == "<thead>Hello</thead>");
    assert(H5Thead(["test"], "Hello") == `<thead class="test">Hello</thead>`);
    assert(H5Thead(["a": "b"], "Hello") == `<thead a="b">Hello</thead>`);
    assert(H5Thead(["test"], ["a": "b"], "Hello") == `<thead class="test" a="b">Hello</thead>`);
}
