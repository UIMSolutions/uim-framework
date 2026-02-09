/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.bdi;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <bdi> HTML element represents a span of text that is isolated from its surrounding text in terms of bidirectional text formatting. 
 * It allows for the correct display of text that may have a different directionality than the surrounding text, such as when embedding a right-to-left language within a left-to-right context, or vice versa. 
 * The <bdi> element does not affect the directionality of the text it contains, but it prevents the surrounding text from affecting the directionality of the contained text.
 */
class Bdi : HtmlElement {
  this() {
    super("bdi");
    this.selfClosing(false);
  }

  static Bdi opCall() {
    return new Bdi();
  }

  static Bdi opCall(string content) {
    auto element = new Bdi();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Bdi() == "<bdi></bdi>");
  assert(Bdi("Hello") == "<bdi>Hello</bdi>");
}
