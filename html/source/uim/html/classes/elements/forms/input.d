/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.forms.input;

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
class H5Input : HtmlElement {
  mixin H5This!("input", false);

  IInput type(string typeValue) {
    attribute("type", typeValue);
    return this;
  }

  IHtmlAttribute type() {
    return attribute("type");
  }

  IHtmlAttribute name() {
    return attribute("name");
  }

  IHtmlElement name(string nameValue) {
    attribute("name", nameValue);
    return this;
  }

  H5Input value(string valueValue) {
    attribute("value", valueValue);
    return this;
  }

  H5Input placeholder(string text) {
    attribute("placeholder", text);
    return this;
  }

  IHtmlAttribute placeholder() {
    return attribute("placeholder");
  }

  H5Input required() {
    attribute("required", "");
    return this;
  }

  H5Input disabled() {
    attribute("disabled", "");
    return this;
  }

  H5Input readonly() {
    attribute("readonly", "");
    return this;
  }

  H5Input checked() {
    attribute("checked", "");
    return this;
  }

  mixin(H5Calls!("Input"));
}
///
unittest {
  auto input = TextInput("username");
  assert(input.toString().indexOf("type=\"text\"") > 0);
}

static H5Input TextInput(string name = null) {
  auto input = new H5Input();
  input.type("text");
  if (name)
    input.name(name);
  return input;
}

static H5Input PasswordInput(string name = null) {
  auto input = new H5Input();
  input.type("password");
  if (name)
    input.name(name);
  return input;
}

static H5Input EmailInput(string name = null) {
  auto input = new H5Input();
  input.type("email");
  if (name)
    input.name(name);
  return input;
}

static H5Input NumberInput(string name = null) {
  auto input = new H5Input();
  input.type("number");
  if (name)
    input.name(name);
  return input;
}

static H5Input CheckboxInput(string name = null) {
  auto input = new H5Input();
  input.type("checkbox");
  if (name)
    input.name(name);
  return input;
}

static H5Input RadioInput(string name = null) {
  auto input = new H5Input();
  input.type("radio");
  if (name)
    input.name(name);
  return input;
}

static H5Input FileInput(string name = null) {
  auto input = new H5Input();
  input.type("file");
  if (name)
    input.name(name);
  return input;
}

static H5Input HiddenInput(string name = null) {
  auto input = new H5Input();
  input.type("hidden");
  if (name)
    input.name(name);
  return input;
}

static H5Input SubmitInput(string value = "Submit") {
  auto input = new H5Input();
  input.type("submit");
  input.value(value);
  return input;
}
