/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.p;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <p> HTML element represents a paragraph of text. 
 * It is used to group together related sentences and to create a block of text that is visually separated from other content on the page. 
 * The <p> element can contain any flow content, such as text, images, and other HTML elements, and it is usually displayed with some vertical spacing before and after it by default. 
 * When rendered in a web browser, the <p> element typically displays the text within it as a block-level element, meaning that it takes up the full width of its container and starts on a new line.
 */
class P : HtmlElement {
  this() {
    super("p");
  }

  static P opCall() {
    return new P();
  }

  static P opCall(string content) {
    auto element = new P();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(P() == "<p></p>");
  assert(P("Paragraph text") == "<p>Paragraph text</p>");
}
