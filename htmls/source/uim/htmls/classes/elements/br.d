
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.br;

import uim.htmls;

@safe:

/// HTML line break element
class DBr : DHtmlElement {
  this() {
    super("br");
    this.selfClosing(true);
  }
}

auto Br() {
  return new DBr();
}

unittest {
  auto br = Br();
  assert(br.toString() == "<br />");
}
