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
}

auto input() {
  return new Input();
}

auto textInput(string name = null) {
  auto input = new Input();
  input.type("text");
  if (name)
    input.name(name);
  return input;
}

auto passwordInput(string name = null) {
  auto input = new Input();
  input.type("password");
  if (name)
    input.name(name);
  return input;
}

auto inputEmail(string name = null) {
  auto input = new Input();
  input.type("email");
  if (name)
    input.name(name);
  return input;
}

auto inputNumber(string name = null) {
  auto input = new Input();
  input.type("number");
  if (name)
    input.name(name);
  return input;
}

auto checkboxInput(string name = null) {
  auto input = new Input();
  input.type("checkbox");
  if (name)
    input.name(name);
  return input;
}

auto inputRadio(string name = null) {
  auto input = new Input();
  input.type("radio");
  if (name)
    input.name(name);
  return input;
}

auto inputFile(string name = null) {
  auto input = new Input();
  input.type("file");
  if (name)
    input.name(name);
  return input;
}

auto inputHidden(string name = null) {
  auto input = new Input();
  input.type("hidden");
  if (name)
    input.name(name);
  return input;
}

auto inputSubmit(string value = "Submit") {
  auto input = new Input();
  input.type("submit");
  input.value(value);
  return input;
}

unittest {
  auto input = textInput("username");
  assert(input.toString().indexOf("type=\"text\"") > 0);
}
