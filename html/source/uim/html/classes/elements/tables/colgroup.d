/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.colgroup;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <colgroup> HTML element defines a group of columns within a table. It is used to apply styles or attributes to a group of columns in a table.
  * The <colgroup> element can contain one or more <col> elements, which define the individual columns within the group. The <colgroup> element itself does not have any visual representation, but it can be used to apply styles or attributes to the columns it contains.
  * The <colgroup> element is typically used in conjunction with the <table> element to create structured tables with specific styling or behavior for certain groups of columns.
  *
  * Example usage:
  *
  * <table>
  *   <colgroup>
  *     <col style="background-color: lightgray;">
  *     <col style="background-color: lightblue;">
  *   </colgroup>
  *   <tr>
  *     <td>Column 1</td>
  *     <td>Column 2</td>
  *   </tr>
  * </table>
  *
  * In this example, the first column will have a light gray background, and the second column will have a light blue background, as defined by the styles applied to the <col> elements within the <colgroup>. 
  * Note: The <colgroup> element must be placed within the <table> element, and it should be defined before any <tr> elements that contain the table's data.
  */
class H5Colgroup : HtmlElement {
  mixin(H5Template!("Colgroup", "colgroup", false));
  mixin(AttributeMethods!H5Colgroup);
}
///
unittest {
  assert(H5Colgroup() == `<colgroup></colgroup>`);
  assert(H5Colgroup(["testclass"]) == `<colgroup class="testclass"></colgroup>`);
  assert(H5Colgroup(["a":"b"]) == `<colgroup a="b"></colgroup>`);

  assert(H5Colgroup("Hello") == `<colgroup>Hello</colgroup>`);
  assert(H5Colgroup(["testclass"], "Hello") == `<colgroup class="testclass">Hello</colgroup>`);
  assert(H5Colgroup(["a":"b"], "Hello") == `<colgroup a="b">Hello</colgroup>`);

  assert(H5Colgroup(["testclass"], ["a":"b"], "Hello") == `<colgroup class="testclass" a="b">Hello</colgroup>`);
}
