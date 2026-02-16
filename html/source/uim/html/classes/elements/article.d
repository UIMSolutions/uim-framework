/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.article;

import uim.html;

mixin(ShowModule!());

@safe:

class H5Article : HtmlElement {
  mixin H5This!("article", false);

  static H5Article opCall() {
    return new H5Article();
  }

  static H5Article opCall(string content) {
    auto element = new H5Article();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(H5Article() == "<article></article>");
  assert(H5Article("Hello") == "<article>Hello</article>");
}
