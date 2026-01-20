
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.blockquote;

import uim.htmls;

@safe:

/// HTML anchor (link) element
class DBlockquote : DHtmlElement {
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
}

auto Blockquote() {
  return new DBlockquote();
}

auto Blockquote(string url, string text = null) {
  auto element = new DBlockquote();
  element.cite(url);
  return element;
}

unittest {
  auto blockquote = Blockquote("https://example.com", "Example");
  assert(blockquote.toString() == `<blockquote cite="https://example.com">Example</blockquote>`);
}
