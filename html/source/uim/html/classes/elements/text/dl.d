/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.lists.dl;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML definition list element
class Dl : HtmlElement {
  this() {
    super("dl");
  }

  static Dl opCall() {
    return new Dl();
  }
}

auto dl() {
  return new Dl();
}

unittest {
  assert(Dl() == "<dl></dl>");
}
