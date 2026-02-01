/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.forms.input;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML input element
class Input : FormElement, IInput {
  this() {
    super("input");
    this.selfClosing(true);
  }

  this(string tag) {
    super(tag);
    this.selfClosing(true);
  }

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

  IHtmlElement value(string valueValue) {
    attribute("value", valueValue);
    return this;
  }

  IHtmlElement placeholder(string text) {
    attribute("placeholder", text);
    return this;
  }

  IHtmlElement required() {
    attribute("required", "");
    return this;
  }

  IHtmlElement disabled() {
    attribute("disabled", "");
    return this;
  }

  IHtmlElement readonly() {
    attribute("readonly", "");
    return this;
  }

  IHtmlElement checked() {
    attribute("checked", "");
    return this;
  }

  static Input opCall() {
    return new Input();
  }

  static Input opCall(string tag) {
    return new Input(tag);
  }

}
///
unittest {
  auto input = TextInput("username");
  assert(input.toString().indexOf("type=\"text\"") > 0);
}

static Input TextInput(string name = null) {
  auto input = new Input();
  input.type("text");
  if (name)
    input.name(name);
  return input;
}

static Input PasswordInput(string name = null) {
  auto input = new Input();
  input.type("password");
  if (name)
    input.name(name);
  return input;
}

static Input EmailInput(string name = null) {
  auto input = new Input();
  input.type("email");
  if (name)
    input.name(name);
  return input;
}

static Input NumberInput(string name = null) {
  auto input = new Input();
  input.type("number");
  if (name)
    input.name(name);
  return input;
}

static Input CheckboxInput(string name = null) {
  auto input = new Input();
  input.type("checkbox");
  if (name)
    input.name(name);
  return input;
}

static Input RadioInput(string name = null) {
  auto input = new Input();
  input.type("radio");
  if (name)
    input.name(name);
  return input;
}

static Input FileInput(string name = null) {
  auto input = new Input();
  input.type("file");
  if (name)
    input.name(name);
  return input;
}

static Input HiddenInput(string name = null) {
  auto input = new Input();
  input.type("hidden");
  if (name)
    input.name(name);
  return input;
}

static Input SubmitInput(string value = "Submit") {
  auto input = new Input();
  input.type("submit");
  input.value(value);
  return input;
}
