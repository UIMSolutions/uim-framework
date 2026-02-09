/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.meta.head;

import uim.html;

mixin(ShowModule!());

@safe:

class Head : HtmlElement {
  this() {
    super("head");
    this.selfClosing(false);
  }

  static Head opCall() {
    return new Head();
  }

  static Head opCall(string content) {
    auto element = new Head();
    element.text(content);
    return element;
  }
}
///
unittest {
  auto head = Head("This is the head content");
  assert(head.toString() == `<head>This is the head content</head>`);
}
