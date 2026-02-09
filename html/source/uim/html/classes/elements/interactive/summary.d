/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.interactive.summary;

import uim.html;

mixin(ShowModule!());

@safe:

class Summary : HtmlElement {
  this() {
    super("summary");
    this.selfClosing(false);
  }

  // Factory methods
  static Summary opCall() {
    return new Summary();
  }

  // Factory methods
  static Summary opCall(string content) {
    auto html = new Summary();
    html.content(content);
    return html;
  }

}
///
unittest {
  assert(Summary() == "<summary></summary>");
  assert(Summary("Some content") == "<summary>Some content</summary>");
}
