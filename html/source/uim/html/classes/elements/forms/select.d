/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.forms.select;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <select> HTML element represents a control that provides a menu of options. 
  * The <select> element can be used in forms to gather user input, and it can be styled using CSS to customize its appearance. 
  * The <select> element can contain one or more <option> elements, which represent the available options in the dropdown menu. 
  * The user can select one or more options from the dropdown menu, depending on the presence of the multiple attribute.
  *
  * Example usage:
  * <form>
  *   <label for="country">Choose a country:</label>
  *   <select id="country" name="country">
  *     <option value="usa">United States</option>
  *     <option value="canada">Canada</option>
  *     <option value="mexico">Mexico</option>
  *   </select>
  *   <input type="submit" value="Submit">
  * </form>
 */
class H5Select : H5FormElement {
  mixin H5This!("select", false);

  /// Gets the name attribute of the select element.
  IHtmlAttribute name() {
    return attribute("name");
  }

  /// Sets the name attribute of the select element, which is used to identify the form data after submission.
  H5Select name(string nameValue) {
    attribute("name", nameValue);
    return this;
  }

  /// Sets the multiple attribute of the select element, allowing multiple selections.
  H5Select multiple(bool val = true) {
    if (val) {
      attribute("multiple", "");
    } else {
      removeAttribute("multiple");
    }
    return this;
  }

  /// Sets the required attribute of the select element, making it a required field in a form.
  H5Select required(bool val = true) {
    if (val) {
      attribute("required", "");
    } else {
      removeAttribute("required");
    }
    return this;
  }

  /// Sets the disabled attribute of the select element, disabling it and preventing user interaction.
  H5Select disabled(bool val = true) {
    if (val) {
      attribute("disabled", "");
    } else {
      removeAttribute("disabled");
    }
    return this;
  }

  /// Adds an option to the select element with the specified value and display text.
  H5Select addOption(string value, string text) {
    // addChild(SelectOption(value, text));
    addContent(SelectOption(value, text));
    return this;
  }

  mixin(H5Calls!("Select"));
}

unittest {
  assert(H5Select() == "<select></select>");
  assert(H5Select("country") == "<select name=\"country\"></select>");
  // assert(H5Select().multiple() == "<select multiple></select>");
  // assert(H5Select().required() == "<select required></select>");
  // assert(H5Select().disabled() == "<select disabled></select>");
  // assert(H5Select().addOption("1", "Option 1") == "<select><option value=\"1\">Option 1</option></select>");
}
