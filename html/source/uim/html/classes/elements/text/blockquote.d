/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.blockquote;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <blockquote> HTML element indicates that the enclosed text is an extended quotation. 
 * Usually, this is rendered visually by indentation (see CSS text-indent property). 
 * A URL for the source of the quotation may be given using the cite attribute, while a text reference to the source may be given using the cite element. 
 * The <blockquote> element is typically used for longer quotations that may contain multiple paragraphs, while the <q> element is used for shorter inline quotations.
 */
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
///
unittest {
  assert(Blockquote() == `<blockquote></blockquote>`);
  assert(Blockquote("https://example.com") == `<blockquote cite="https://example.com"></blockquote>`);
}
