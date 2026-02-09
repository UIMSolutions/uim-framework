/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.var;

import uim.html;

mixin(ShowModule!());

@safe:

// The <var> HTML element represents a variable in a mathematical expression or a programming context.
class Var : HtmlElement {
  this() {
    super("var");
    this.selfClosing(false);
  }

  static Var opCall() {
    return new Var();
  }

  static Var opCall(string content) {
    auto element = new Var();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Var() == "<var></var>");
  assert(Var("Hello") == "<var>Hello</var>");
}
