/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.interactive.details;

import uim.html;

mixin(ShowModule!());

@safe:

class Details : HtmlElement {
  this() {
    super("details");
    this.selfClosing(false);
  }

  // Factory methods
  static Details opCall() {
    return new Details();
  }

  // Factory methods
  static Details opCall(string content) {
    auto html = new Details();
    html.content(content);
    return html;
  }

}
///
unittest {
  assert(Details() == "<details></details>");
  assert(Details("Some content") == "<details>Some content</details>");
}
