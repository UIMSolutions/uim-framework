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
  mixin(H5This!("data", false));

  /// Sets the value attribute of the data element.
  H5Data value(double val) {
    attribute("value", val.to!string);
    return this;
  }

  mixin(H5Calls!("Data"));
}
///
unittest {
  assert(H5Data() == "<data></data>");
  assert(H5Data("Hello") == "<data>Hello</data>");
  assert(H5Data().value(42) == `<data value="42"></data>`);
}
