/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.option;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <option> element.
  * Provides methods to set option attributes like value, selected, and disabled.
  * Example usage:
  * auto option = H5Option("Option 1").value("1").selected();
  */
class H5Option : HtmlElement {
  mixin(H5This!("option", false));

  H5Option value(string valueValue) {
    attribute("value", valueValue);
    return this;
  }

  IHtmlAttribute value() {
    return attribute("value");
  }

  H5Option label(string labelValue) {
    attribute("label", labelValue);
    return this;
  }

  IHtmlAttribute label() {
    return attribute("label");
  }

  H5Option selected(bool isSelected = true) {
    if (isSelected) {
      attribute("selected", "");
    } else {
      removeAttribute("selected");
    }
    return this;
  }

  H5Option disabled(bool isDisabled = true) {
    if (isDisabled) {
      attribute("disabled", "");
    } else {
      removeAttribute("disabled");
    }
    return this;
  }

  mixin(H5Calls!("Option"));
}
///
unittest {
  mixin(ShowTest!"Testing Option Class");

  assert(H5Option() == `<option></option>`);
  assert(H5Option("Option 1") == `<option>Option 1</option>`);
  assert(H5Option().value("1") == `<option value="1"></option>`);
  assert(H5Option().selected() == `<option selected></option>`);
  assert(H5Option().disabled() == `<option disabled></option>`);
}
