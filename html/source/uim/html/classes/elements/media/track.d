/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.track;

import uim.html;

mixin(ShowModule!());

@safe:

class Track : HtmlElement {
  this() {
    super("track");
    this.selfClosing(false);
  }

  static Track opCall() {
    return new Track();
  }

  static Track opCall(string content) {
    auto element = new Track();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Track() == "<track></track>");
  assert(Track("Hello") == "<track>Hello</track>");
}
