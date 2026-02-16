/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.fencedframe;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Fencedframe : HtmlElement {
  mixin H5This!("fencedframe", false);

  static H5Fencedframe opCall() {
    return new H5Fencedframe();
  }

  static H5Fencedframe opCall(string content) {
    auto element = new H5Fencedframe();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(H5Fencedframe() == "<fencedframe></fencedframe>");
  assert(H5Fencedframe("Hello") == "<fencedframe>Hello</fencedframe>");
}
