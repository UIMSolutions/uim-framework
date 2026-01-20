/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.forms.label;

import uim.htmls;

mixin(ShowModule!());

@safe:

/// HTML label element
class DLabel : DHtmlFormElement {
  this() {
    super("label");
  }

  auto forElement(string elementId) {
    return attribute("for", elementId);
  }
}

auto Label() {
  return new DLabel();
}

auto Label(string text) {
  auto lbl = new DLabel();
  lbl.text(text);
  return lbl;
}

auto Label(string forId, string text) {
  auto lbl = new DLabel();
  lbl.forElement(forId).text(text);
  return lbl;
}

unittest {
  auto label = Label("username", "Username:");
  assert(label.toString().indexOf("label") > 0);
}
