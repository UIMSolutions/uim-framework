/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.q;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <q> HTML element indicates that the enclosed text is a short inline quotation. 
 * Most modern browsers implement this by surrounding the text in quotation marks. 
 * This element is intended for short quotations that do not require paragraph breaks. 
 * For longer quotations, the <blockquote> element should be used instead.
 */
class Q : HtmlElement {
  this() {
    super("q");
    this.selfClosing(false);
  }

  static Q opCall() {
    return new Q();
  }

  static Q opCall(string content) {
    auto element = new Q();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Q() == "<q></q>");
  assert(Q("Hello") == "<q>Hello</q>");
}
