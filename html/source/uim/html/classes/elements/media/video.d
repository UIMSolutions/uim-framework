/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.video;

import uim.html;

mixin(ShowModule!());

@safe:

class Video : HtmlElement {
  this() {
    super("video");
    this.selfClosing(false);
  }

  static Video opCall() {
    return new Video();
  }

  static Video opCall(string content) {
    auto element = new Video();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Video() == "<video></video>");
  assert(Video("Hello") == "<video>Hello</video>");
}
