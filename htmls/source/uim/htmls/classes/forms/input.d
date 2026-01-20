/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.forms.input;

import uim.htmls;

mixin(ShowModule!());

@safe:

/// HTML input element
class DInput : DHtmlFormElement, IInput {
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

auto Input() {
  return new DInput();
}

auto InputText(string name = null) {
  auto input = new DInput();
  input.type("text");
  if (name)
    input.name(name);
  return input;
}

auto InputPassword(string name = null) {
  auto input = new DInput();
  input.type("password");
  if (name)
    input.name(name);
  return input;
}

auto InputEmail(string name = null) {
  auto input = new DInput();
  input.type("email");
  if (name)
    input.name(name);
  return input;
}

auto InputNumber(string name = null) {
  auto input = new DInput();
  input.type("number");
  if (name)
    input.name(name);
  return input;
}

auto InputCheckbox(string name = null) {
  auto input = new DInput();
  input.type("checkbox");
  if (name)
    input.name(name);
  return input;
}

auto InputRadio(string name = null) {
  auto input = new DInput();
  input.type("radio");
  if (name)
    input.name(name);
  return input;
}

auto InputFile(string name = null) {
  auto input = new DInput();
  input.type("file");
  if (name)
    input.name(name);
  return input;
}

auto InputHidden(string name = null) {
  auto input = new DInput();
  input.type("hidden");
  if (name)
    input.name(name);
  return input;
}

auto InputSubmit(string value = "Submit") {
  auto input = new DInput();
  input.type("submit");
  input.value(value);
  return input;
}

unittest {
  auto input = InputText("username");
  assert(input.toString().indexOf("type=\"text\"") > 0);
}
