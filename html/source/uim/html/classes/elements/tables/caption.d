/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.caption;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <caption> HTML element specifies the caption (or title) of a table. It must be inserted immediately after the <table> tag.
  * The <caption> element is used to describe the contents of the table, and it is typically displayed above the table by default.
  * However, you can use CSS to change its position and style as needed.
  *
  * Example usage:
  * <table>
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
class H5Caption : HtmlElement {
  mixin H5This!("caption", false);

  mixin(H5AttributeMethods!H5Caption);

  mixin(H5Calls!("caption"));
}
///
unittest {
  assert(H5Caption() == "<caption></caption>");
  assert(H5Caption("Hello") == "<caption>Hello</caption>");
  assert(H5Caption(["test"], "Hello") == `<caption class="test">Hello</caption>`);
  assert(H5Caption(["a": "b"], "Hello") == `<caption a="b">Hello</caption>`);
  assert(H5Caption(["test"], ["a": "b"], "Hello") == `<caption class="test" a="b">Hello</caption>`);
}
