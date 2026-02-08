/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.figcaption;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML definition description element
class Figcaption : HtmlElement {
  this() {
    super("figcaption");
  }

  static Figcaption opCall() {
    return new Figcaption();
  }

  static Figcaption opCall(string content) {
    auto figcaption = new Figcaption();
    figcaption.text(content);
    return figcaption;
  }
}
///
unittest {
  assert(Figcaption() == "<figcaption></figcaption>");
  assert(Figcaption("Description") == "<figcaption>Description</figcaption>");
}
