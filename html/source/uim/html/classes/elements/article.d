/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.article;

import uim.html;

mixin(ShowModule!());

@safe:

class Article : HtmlElement {
  this() {
    super("article");
    this.selfClosing(false);
  }

  static Article opCall() {
    return new Article();
  }

  static Article opCall(string content) {
    auto element = new Article();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Article() == "<article></article>");
  assert(Article("Hello") == "<article>Hello</article>");
}
