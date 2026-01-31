/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.forms.output;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  HTML output element

  The output element represents the result of a calculation or user action. 
  It is typically used in forms to display results that are computed based on user input.
*/
class Output : FormElement {
  this() {
    super("output");
  }

  // Associates the output element with other elements
  auto forElement(string elementId) {
    return attribute("for", elementId);
  }

  static Output opCall() {
    return new Output();
  }

  static Output opCall(string text) {
    auto lbl = new Output();
    lbl.text(text);
    return lbl;
  }

  static Output opCall(string forId, string text) {
    auto lbl = new Output();
    lbl.forElement(forId).text(text);
    return lbl;
  }
}
///
unittest {
  auto output = Output("username", "Username:");
  assert(output == "<output for=\"username\">Username:</output>");

}
