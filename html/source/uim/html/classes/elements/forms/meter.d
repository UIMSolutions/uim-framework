/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.meter;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Meter : HtmlElement {
  mixin H5This!("meter", false);

  static H5Meter opCall() {
    return new H5Meter();
  }

  static H5Meter opCall(string content) {
    auto html = new H5Meter();
    html.text(content);
    return html;
  }
}
///
unittest {
  assert(H5Meter() == "<meter></meter>");
  assert(H5Meter("Some content") == "<meter>Some content</meter>");
}
