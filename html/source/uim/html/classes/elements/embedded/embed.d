/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.embed;

import uim.html;

mixin(ShowModule!());

@safe:

class Embed : HtmlElement {
  this() {
    super("embed");
    this.selfClosing(false);
  }

  static Embed opCall() {
    return new Embed();
  }

  static Embed opCall(string content) {
    auto element = new Embed();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Embed() == "<embed></embed>");
  assert(Embed("Hello") == "<embed>Hello</embed>");
}
