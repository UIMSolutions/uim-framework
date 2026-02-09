/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.samp;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <samp> HTML element is used to enclose inline text which represents sample (or quoted) output from a computer program. 
 * By default, it is displayed in the browser's default monospace font, and it preserves whitespace and line breaks. 
 * The <samp> element can be used to display sample output from a command-line interface, a programming language, or any other type of computer-generated output.
 */
class Samp : HtmlElement {
  this() {
    super("samp");
    this.selfClosing(false);
  }

  static Samp opCall() {
    return new Samp();
  }

  static Samp opCall(string content) {
    auto element = new Samp();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Samp() == "<samp></samp>");
  assert(Samp("Hello") == "<samp>Hello</samp>");
}
