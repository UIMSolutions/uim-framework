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
@StringAttribute("colspan")  // The number of columns a cell should span. This attribute is only applicable to "td" and "th" elements.
@StringAttribute("rowspan")  // The number of rows a cell should span. This attribute is only applicable to "td" and "th" elements.
class H5Col : HtmlElement {
  mixin(HtmlTemplate!(H5Col, "Col", "col", true));
  mixin(HtmlMethods!H5Col);

  /// Sets the number of columns a cell should span. This attribute is only applicable to "td" and "th" elements.
  H5Col colspan(size_t value) {
    attribute("colspan", to!string(value));
    return this;
  }

  H5Col rowspan(size_t value) {
    attribute("rowspan", to!string(value));
    return this;
  }
}
///
unittest {
  assert(H5Col() == `<col />`);
  assert(H5Col(["testclass"]) == `<col class="testclass" />`);
  assert(H5Col(["a": "b"]) == `<col a="b" />`);
  assert(H5Col(["testclass"], ["a": "b"]) == `<col class="testclass" a="b" />`);

  assert(H5Col().colspan(2) == `<col colspan="2" />`);
  assert(H5Col().rowspan(3) == `<col rowspan="3" />`);
  assert(H5Col().colspan(2).rowspan(3) == `<col colspan="2" rowspan="3" />`);

  assert(H5Col().colspan("2") == `<col colspan="2" />`);
  assert(H5Col().rowspan("3") == `<col rowspan="3" />`);
  assert(H5Col().colspan("2").rowspan("3") == `<col colspan="2" rowspan="3" />`);
}
