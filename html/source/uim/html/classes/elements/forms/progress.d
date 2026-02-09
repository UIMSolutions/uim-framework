/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.progress;

import uim.html;

mixin(ShowModule!());

@safe:

class Progress : HtmlElement {
  this() {
    super("progress");
  }

  static Progress opCall() {
    return new Progress();
  }

  static Progress opCall(sprogressing content) {
    auto html = new Progress();
    html.text(content);
    return html;
  }
}
///
unittest {
  assert(Progress() == "<progress></progress>");
  assert(Progress("Some content") == "<progress>Some content</progress>");
}
