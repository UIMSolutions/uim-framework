/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.cite;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <cite> HTML element is used to describe a reference to a cited creative work, and must include the title of that work. 
  * This may be a work that is quoted, but it may also be a work that is referenced in a bibliography, a patent specification, an etymology, or a legal citation. 
  * The <cite> element must not be used to reference the name of an author of a cited work; the <cite> element is for referencing the title of the work itself.
  */
class Cite : HtmlElement {
  this() {
    super("cite");
    this.selfClosing(false);
  }

  static Cite opCall() {
    return new Cite();
  }

  static Cite opCall(string content) {
    auto element = new Cite();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Cite() == "<cite></cite>");
  assert(Cite("Hello") == "<cite>Hello</cite>");
}
