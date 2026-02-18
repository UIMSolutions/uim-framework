/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.tables.col;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <col> HTML element defines a column within a table and is used for styling purposes. 
  * It is typically used within a <colgroup> element to group columns together and apply styles to them. 
  * The <col> element does not contain any content and is self-closing, meaning it does not require a closing tag. 
  * It can be styled using CSS to specify the width, background color, or other visual properties of the column it represents.
  *
  * Example usage:
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
  */
class H5Col : HtmlElement {
  mixin H5This!("col", true);

  /// Sets the number of columns a cell should span. This attribute is only applicable to "td" and "th" elements.
  H5Col colspan(string value) {
    attribute("colspan", value);
    return this;
  }

  H5Col rowspan(string value) {
    attribute("rowspan", value);
    return this;
  }

  mixin(H5Calls!("col"));
}

unittest {
  assert(H5Col() == "<col />");
  assert(H5Col().colspan("2") == `<col colspan="2" />`);
  assert(H5Col().rowspan("3") == `<col rowspan="3" />`);
  assert(H5Col().colspan("2").rowspan("3") == `<col colspan="2" rowspan="3" />`);
}
