/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.pre;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <pre> HTML element represents preformatted text. 
 * It is used to display text in a fixed-width font, and it preserves both spaces and line breaks in the content. 
 * The <pre> element is often used to display code snippets, poetry, or other types of content where the formatting is important. 
 * When rendered in a web browser, the <pre> element typically displays the text within it as a block-level element, meaning that it takes up the full width of its container and starts on a new line.
 */
class Pre : HtmlElement {
  this() {
    super("pre");
  }

  static Pre opCall() {
    return new Pre();
  }

  static Pre opCall(string content) {
    auto pre = new Pre();
    pre.text(content);
    return pre;
  }
}
///
unittest {
  assert(Pre() == "<pre></pre>");
  assert(Pre("Description") == "<pre>Description</pre>");
}
