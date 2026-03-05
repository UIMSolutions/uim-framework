/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.input;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <input> element.
  * Provides methods to set input attributes like type, name, value, placeholder, and various boolean attributes.
  *
  * The Input class is a versatile representation of the HTML <input> element, allowing you to create various types of input fields by setting the appropriate attributes.
  * It supports common input types such as text, password, email, number, checkbox, radio, file, hidden, and submit, among others.
  * Example usage:
  * auto textInput = H5Input().TextInput("username").placeholder("Enter your username");
  * auto passwordInput = H5Input().PasswordInput("password").placeholder("Enter your password");
  * auto submitButton = H5Input().SubmitInput("Login");
  */
@StringAttribute("type")
@StringAttribute("name")
@StringAttribute("value")
@StringAttribute("placeholder")
class H5Input : HtmlElement {
  mixin(H5This!("input", true));

  mixin(HtmlMethods!H5Input);

  H5Input required(bool isRequired = true) {
    if (isRequired)
      attribute("required", "");
    else
      removeAttribute("required");
    return this;
  }

  H5Input disabled(bool isDisabled = true) {
    if (isDisabled)
      attribute("disabled", "");
    else
      removeAttribute("disabled");
    return this;
  }

  H5Input readonly(bool isReadonly = true) {
    if (isReadonly)
      attribute("readonly", "");
    else
      removeAttribute("readonly");
    return this;
  }

  H5Input checked(bool isChecked = true) {
    if (isChecked)
      attribute("checked", "");
    else
      removeAttribute("checked");
    return this;
  }

  H5Input value(int aValue) {
    attribute("value", to!string(aValue));
    return this;
  }

  H5Input value(long aValue) {
    attribute("value", to!string(aValue));
    return this;
  }

  H5Input value(double aValue) {
    attribute("value", to!string(aValue));
    return this;
  }

  H5Input value(Json aValue) {
    attribute("value", aValue.toString());
    return this;
  }
  
  mixin(H5Calls!("Input"));
}
///
unittest {
  auto input = H5Input().type("text").name("username").value("JohnDoe").placeholder("Enter your username").required();
  assert(input == `<input name="username" placeholder="Enter your username" required type="text" value="JohnDoe" />`);
  assert(input.type() == "text");
  assert(input.name() == "username");
  assert(input.value() == "JohnDoe");
  assert(input.placeholder() == "Enter your username");
  assert(input.attribute("required") !is null);
}







