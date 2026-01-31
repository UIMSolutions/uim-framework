/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
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
}

auto article() {
  return new Article();
}

auto article(string content) {
  auto element = new Article();
  element.text(content);
  return element;
}

unittest {
  auto article = article();
  assert(article.toString() == "<article></article>");

  auto articleWithContent = article("Hello");
  assert(articleWithContent.toString() == "<article>Hello</article>");
}
