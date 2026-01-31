
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.forms.button;

import uim.html;

mixin(ShowModule!());

@safe:

/// HTML button element
class Button : DHtmlFormElement {
  this() {
    super("button");
  }

  // #region type
  IHtmlElement type(string typeValue) {
    attribute("type", typeValue);
    return this;
  }

  IHtmlAttribute type() {
    return attribute("type");
  }
  // #endregion type

  IHtmlElement submit() {
    return type("submit");
  }

  IHtmlElement reset() {
    return type("reset");
  }

  IHtmlElement disabled() {
    attribute("disabled", "");
    return this;
  }
}

auto button() {
  return new Button();
}

auto button(string text) {
  auto btn = new Button();
  btn.text(text);
  return btn;
}

auto htmlButton() {
  return new Button();
}

auto htmlButton(string text) {
  auto btn = new Button();
  btn.text(text);
  return btn;
}

auto buttonSubmit(string text = "Submit") {
  auto btn = new Button();
  btn.text(text);
  btn.submit();
  return btn;
}

auto buttonReset(string text = "Reset") {
  auto btn = new Button();
  btn.text(text);
  btn.reset();
  return btn;
}

unittest {
  auto btn = button("Click me");
  assert(btn.toString() == "<button>Click me</button>");
}
