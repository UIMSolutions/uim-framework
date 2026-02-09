/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.sup;

import uim.html;

mixin(ShowModule!());

@safe:

// The <sup> HTML element defines superscript text. Superscripts are typically used for footnotes, like this: "This is some text.<sup>1</sup>".
class Sup : HtmlElement {
  this() {
    super("sup");
    this.selfClosing(false);
  }

  static Sup opCall() {
    return new Sup();
  }

  static Sup opCall(string content) {
    auto element = new Sup();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Sup() == "<sup></sup>");
  assert(Sup("Hello") == "<sup>Hello</sup>");
}
