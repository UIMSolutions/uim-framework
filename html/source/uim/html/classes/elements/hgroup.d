/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.hgroup;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Hgroup : HtmlElement {
  mixin H5This!("hgroup", false);

  static H5Hgroup opCall() {
    return new H5Hgroup();
  }

  static H5Hgroup opCall(string content) {
    auto element = new H5Hgroup();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(H5Hgroup() == "<hgroup></hgroup>");
  assert(H5Hgroup("Hello") == "<hgroup>Hello</hgroup>");
}
