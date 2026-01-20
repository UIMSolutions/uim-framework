/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.forms.output;

import uim.htmls;

mixin(ShowModule!());

@safe:

/// HTML output element
class DOutput : DHtmlFormElement {
  this() {
    super("output");
  }

  // Associates the output element with other elements
  auto forElement(string elementId) {
    return attribute("for", elementId);
  }
}

auto Output() {
  return new DOutput();
}

auto Output(string text) {
  auto lbl = new DOutput();
  lbl.text(text);
  return lbl;
}

auto Output(string forId, string text) {
  auto lbl = new DOutput();
  lbl.forElement(forId).text(text);
  return lbl;
}

unittest {
  auto output = Output("username", "Username:");
  assert(output.toString().indexOf("output") > 0);
}
