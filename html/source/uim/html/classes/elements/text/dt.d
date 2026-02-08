/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.lists.dt;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML definition term element
class Dt : HtmlElement {
  this() {
    super("dt");
  }

  static Dt opCall() {
    return new Dt();
  }

  static Dt opCall(string content) {
    auto dt = new Dt();
    dt.text(content);
    return dt;
  }
}
///
unittest {
  assert(Dt() == "<dt></dt>");
  assert(Dt("Term") == "<dt>Term</dt>");
}
