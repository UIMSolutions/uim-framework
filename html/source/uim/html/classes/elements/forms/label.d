/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.forms.label;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <label> element, which is used to define a label for an <input> element.
  * The 'for' attribute of the <label> element should match the 'id' of the corresponding <input> element.
  * This allows users to click on the label to focus the associated input field, improving accessibility and usability.
* 
* Example usage:
* auto usernameLabel = H5Label("username", "Username:");
* auto usernameInput = H5Input.TextInput("username");
* The above code creates a label for an input field with the id "username" and the text "Username:". When rendered, clicking on the "Username:" label will focus the input field with the id "username".
* Note: The <label> element can also be used without the 'for' attribute by nesting the <input> element inside the <label>. However, using the 'for' attribute is generally recommended for better accessibility and separation of concerns.
  */
class H5Label : H5FormElement {
  mixin H5This!("label", false);

  auto forElement(string elementId) {
    return attribute("for", elementId);
  }

  mixin(H5Calls!("Label"));
}
///
unittest {
  assert(H5Label() == "<label></label>");
  assert(H5Label("Username:") == "<label>Username:</label>");
  assert(H5Label().forElement("username") == "<label for=\"username\"></label>");
  assert(H5Label("Username:").forElement("username") == "<label for=\"username\">Username:</label>");
}
