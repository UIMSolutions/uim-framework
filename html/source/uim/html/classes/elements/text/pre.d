/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.pre;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML definition description element
class Pre : HtmlElement {
  this() {
    super("pre");
  }

  static Pre opCall() {
    return new Pre();
  }

  static Pre opCall(string content) {
    auto pre = new Pre();
    pre.text(content);
    return pre;
  }
}
///
unittest {
  assert(Pre() == "<pre></pre>");
  assert(Pre("Description") == "<pre>Description</pre>");
}
