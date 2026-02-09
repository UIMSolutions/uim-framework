/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.picture;

import uim.html;

mixin(ShowModule!());

@safe:

class Picture : HtmlElement {
  this() {
    super("picture");
    this.selfClosing(false);
  }

  static Picture opCall() {
    return new Picture();
  }

  static Picture opCall(string content) {
    auto element = new Picture();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Picture() == "<picture></picture>");
  assert(Picture("Hello") == "<picture>Hello</picture>");
}
