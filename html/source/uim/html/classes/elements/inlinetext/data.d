/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.data;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <data> HTML element links a given content with a machine-readable translation. 
 * If the content is time- or date-related, the datetime attribute must be present and contain a valid date string. 
 * If the content is a number, the value attribute must be present and contain a valid floating point number.
 */
class H5Data : HtmlElement {
  mixin(HtmlTemplate!(H5Data, "Data", "data", false));

  /// Sets the value attribute of the data element.
  H5Data value(double val) {
    attribute("value", val.to!string);
    return this;
  }

  H5Data value(string val) {
    attribute("value", val);
    return this;
  }
}
///
unittest {
  assert(H5Data() == "<data></data>");
  assert(H5Data(["testClass"]) == `<data class="testClass"></data>`);
  assert(H5Data(["a":"b"]) == `<data a="b"></data>`);
  assert(H5Data(["testClass"], ["a":"b"]) == `<data class="testClass" a="b"></data>`);

  assert(H5Data("Hello") == "<data>Hello</data>");
  assert(H5Data(["testClass"], "Hello") == `<data class="testClass">Hello</data>`);
  assert(H5Data(["a":"b"], "Hello") == `<data a="b">Hello</data>`);
  assert(H5Data(["testClass"], ["a":"b"], "Hello") == `<data class="testClass" a="b">Hello</data>`);

  assert(H5Data().value(42) == `<data value="42"></data>`);
  assert(H5Data().value("42") == `<data value="42"></data>`);
}
