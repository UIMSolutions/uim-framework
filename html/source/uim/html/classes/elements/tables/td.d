/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.td;

import uim.html;

mixin(ShowModule!());

@safe:

/**   
  * Represents the HTML `<td>` element, which defines a standard data cell in an HTML table. The `<td>` element is used within a `<tr>` (table row) element to specify the content of a cell in the body of a table.
  * 
  * The content inside a `<td>` element can include text, images, links, or other HTML elements. The appearance of the cell can be customized using CSS properties such as `border`, `padding`, and `background-color`.
  * 
  * Browser support: All major browsers support the `<td>` element.
  *
  * Examples:
  * ```html
  * <table>
  *   <tr>
  *     <td>Cell 1</td>
  *     <td>Cell 2</td>
  *   </tr>
  * </table>
  * ```
  */
class H5Td : HtmlElement {
 mixin H5This!("td", false);

  H5Td colspan(string value) {
    attribute("colspan", value);
    return this;
  }

  H5Td rowspan(string value) {
    attribute("rowspan", value);
    return this;
  }

  mixin(H5Calls!("td"));
}
///
unittest {
  assert(H5Td() == "<td></td>");
  assert(H5Td("Hello") == "<td>Hello</td>");
  assert(H5Td(["test"], "Hello") == `<td class="test">Hello</td>`);
  assert(H5Td(["a": "b"], "Hello") == `<td a="b">Hello</td>`);
  assert(H5Td(["test"], ["a": "b"], "Hello") == `<td class="test" a="b">Hello</td>`);
}
