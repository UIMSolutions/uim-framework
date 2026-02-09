/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.forms.select;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML select element
class Select : FormElement {
  this() {
    super("select");
  }

  /// Gets the name attribute of the select element.
  IHtmlAttribute name() {
    return attribute("name");
  }

  /// Sets the name attribute of the select element, which is used to identify the form data after submission.
  IHtmlElement name(string nameValue) {
    attribute("name", nameValue);
    return this;
  }

  /// Sets the multiple attribute of the select element, allowing multiple selections.
  IHtmlElement multiple() {
    attribute("multiple", "");
    return this;
  }

  /// Sets the required attribute of the select element, making it a required field in a form.
  IHtmlElement required() {
    attribute("required", "");
    return this;
  }

  /// Sets the disabled attribute of the select element, disabling it and preventing user interaction.
  IHtmlElement disabled() {
    attribute("disabled", "");
    return this;
  }

  /// Adds an option to the select element with the specified value and display text.
  IHtmlElement addOption(string value, string text) {
    addChild(SelectOption(value, text));
    return this;
  }

  static Select opCall() {
    return new Select();
  }

  static Select opCall(string name) {
    auto html = new Select();
    html.name(name);
    return html;
  }
}

unittest {
  assert(Select() == "<select></select>");
  assert(Select("country") == "<select name=\"country\"></select>");
  assert(Select().multiple() == "<select multiple></select>");
  assert(Select().required() == "<select required></select>");
  assert(Select().disabled() == "<select disabled></select>");
  assert(Select().addOption("1", "Option 1") == "<select><option value=\"1\">Option 1</option></select>");
}
