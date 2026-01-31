
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.elements.br;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML line break element
class Br : HtmlElement {
  this() {
    super("br");
    this.selfClosing(true);
  }
  static Br opCall() {
    return new Br();
  }
}
///
unittest {
  auto br = Br();
  assert(br.toString() == "<br />");
}
