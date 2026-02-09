/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.hgroup;

import uim.html;

mixin(ShowModule!());

@safe:

class Hgroup : HtmlElement {
  this() {
    super("hgroup");
    this.selfClosing(false);
  }

  static Hgroup opCall() {
    return new Hgroup();
  }

  static Hgroup opCall(string content) {
    auto element = new Hgroup();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Hgroup() == "<hgroup></hgroup>");
  assert(Hgroup("Hello") == "<hgroup>Hello</hgroup>");
}
