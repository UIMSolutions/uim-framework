/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.strong;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <strong> HTML element indicates that its contents have strong importance, seriousness, or urgency. 
 * Browsers typically render the contents in bold type.
 */
class Strong : HtmlElement {
  this() {
    super("strong");
    this.selfClosing(false);
  }

  static Strong opCall() {
    return new Strong();
  }

  static Strong opCall(string content) {
    auto element = new Strong();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Strong() == "<strong></strong>");
  assert(Strong("Hello") == "<strong>Hello</strong>");
}
