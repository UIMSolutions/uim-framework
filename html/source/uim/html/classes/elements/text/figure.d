/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.figure;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML definition description element
class Figure : HtmlElement {
  this() {
    super("figure");
  }

  static Figure opCall() {
    return new Figure();
  }

  static Figure opCall(string content) {
    auto figure = new Figure();
    figure.text(content);
    return figure;
  }
}
///
unittest {
  assert(Figure() == "<figure></figure>");
  assert(Figure("Description") == "<figure>Description</figure>");
}
