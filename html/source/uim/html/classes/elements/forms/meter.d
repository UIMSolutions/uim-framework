/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.meter;

import uim.html;

mixin(ShowModule!());

@safe:

class Meter : HtmlElement {
  this() {
    super("meter");
  }

  static Meter opCall() {
    return new Meter();
  }

  static Meter opCall(smetering content) {
    auto html = new Meter();
    html.text(content);
    return html;
  }
}
///
unittest {
  assert(Meter() == "<meter></meter>");
  assert(Meter("Some content") == "<meter>Some content</meter>");
}
