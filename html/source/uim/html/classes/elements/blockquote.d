/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.elements.blockquote;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML anchor (link) element
class Blockquote : HtmlElement {
  this() {
    super("blockquote");
  }

  IHtmlElement cite(string url) {
    attribute("cite", url);
    return this;
  }

  IHtmlAttribute cite() {
    return attribute("cite");
  }

  static Blockquote opCall() {
    return new Blockquote();
  }

  static Blockquote opCall(string url, string text = null) {
    auto element = new Blockquote();
    element.cite(url);
    return element;
  }
}
