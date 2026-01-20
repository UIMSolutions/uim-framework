/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.lists.dt;

import uim.htmls;

@safe:

/// HTML definition term element
class DDt : DHtmlElement {
  this() {
    super("dt");
  }
}

auto Dt() {
  return new DDt();
}

auto Dt(string content) {
  auto dt = new DDt();
  dt.text(content);
  return dt;
}

unittest {
  auto dt = Dt("Term");
  assert(dt.toString() == "<dt>Term</dt>");
}
