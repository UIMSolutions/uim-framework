/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.forms.label;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML label element
class Label : FormElement {
  this() {
    super("label");
  }

  auto forElement(string elementId) {
    return attribute("for", elementId);
  }

  static Label opCall() {
  return new Label();
}

  static Label opCall(string text) {
    auto lbl = new Label();
  lbl.text(text);
  return lbl;
}

  static Label opCall(string forId, string text) {
    auto lbl = new Label();
    lbl.forElement(forId).text(text);
    return lbl;
  }
}
///
unittest {
  auto label = Label("username", "Username:");
  assert(label.toString().indexOf("label") > 0);
}
