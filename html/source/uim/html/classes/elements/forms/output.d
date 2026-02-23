/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.output;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  HTML output element

  The output element represents the result of a calculation or user action. 
  It is typically used in forms to display results that are computed based on user input.
*/
class H5Output : HtmlElement {
  mixin(H5This!("output", false));

  /// Associates the output element with other elements
  H5Output forElement(string elementId) {
    attribute("for", elementId);
    return this;
  }

  IHtmlAttribute forElement() {
    return attribute("for");
  }

  mixin(H5Calls!("Output"));
}
///
unittest {
  assert(H5Output() == `<output></output>`);
  assert(H5Output("Username:") == `<output>Username:</output>`);
  assert(H5Output().forElement("input1") == `<output for="input1"></output>`);
}
