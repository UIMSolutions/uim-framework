/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.audio;

import uim.html;

mixin(ShowModule!());

@safe:

class Audio : HtmlElement {
  this() {
    super("audio");
    this.selfClosing(false);
  }

  static Audio opCall() {
    return new Audio();
  }

  static Audio opCall(string content) {
    auto element = new Audio();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Audio() == "<audio></audio>");
  assert(Audio("Hello") == "<audio>Hello</audio>");
}
