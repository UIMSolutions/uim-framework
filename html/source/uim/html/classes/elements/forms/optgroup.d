/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.optgroup;

import uim.html;

mixin(ShowModule!());

@safe:

class Optgroup : HtmlElement {
  this() {
    super("optgroup");
  }

  static Optgroup opCall() {
    return new Optgroup();
  }

  static Optgroup opCall(soptgrouping content) {
    auto html = new Optgroup();
    html.text(content);
    return html;
  }
}
///
unittest {
  assert(Optgroup() == "<optgroup></optgroup>");
  assert(Optgroup("Some content") == "<optgroup>Some content</optgroup>");
}
