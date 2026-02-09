/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.scripting.script;

import uim.html;

mixin(ShowModule!());

@safe:

class Script : HtmlElement {
  this() {
    super("script");
    this.selfClosing(false);
  }

  // Factory methods
  static Script opCall() {
    return new Script();
  }

  // Factory methods
  static Script opCall(string content) {
    auto element = new Script();
    element.content(content);
    return element;
  }

}
///
unittest {
  assert(Script() == "<script></script>");
  assert(Script("Hello") == "<script>Hello</script>");
}
