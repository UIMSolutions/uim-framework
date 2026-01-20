/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.article;

import uim.htmls;

@safe:

class DArticle : DHtmlElement {
  this() {
    super("article");
    this.selfClosing(false);
  }
}

auto Article() {
  return new DArticle();
}

auto Article(string content) {
  auto element = new DArticle();
  element.text(content);
  return element;
}

unittest {
  auto article = Article();
  assert(article.toString() == "<article></article>");

  auto articleWithContent = Article("Hello");
  assert(articleWithContent.toString() == "<article>Hello</article>");
}
