/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.code;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <code> HTML element is used to define a fragment of computer code. 
 * By default, it is displayed in the browser's default monospace font, and it preserves whitespace and line breaks. 
 * The <code> element can be used to display code snippets, programming language keywords, or any other text that represents code.
 */
class Code : HtmlElement {
  this() {
    super("code");
    this.selfClosing(false);
  }

  static Code opCall() {
    return new Code();
  }

  static Code opCall(string content) {
    auto element = new Code();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Code() == "<code></code>");
  assert(Code("Hello") == "<code>Hello</code>");
}
