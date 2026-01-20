
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.forms.button;

import uim.htmls;

@safe:

/// HTML button element
class DButton : DHtmlFormElement {
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

auto Button() {
  return new DButton();
}

auto Button(string text) {
  auto btn = new DButton();
  btn.text(text);
  return btn;
}

auto HtmlButton() {
  return new DButton();
}

auto HtmlButton(string text) {
  auto btn = new DButton();
  btn.text(text);
  return btn;
}

auto ButtonSubmit(string text = "Submit") {
  auto btn = new DButton();
  btn.text(text);
  btn.submit();
  return btn;
}

auto ButtonReset(string text = "Reset") {
  auto btn = new DButton();
  btn.text(text);
  btn.reset();
  return btn;
}

unittest {
  auto btn = Button("Click me");
  assert(btn.toString() == "<button>Click me</button>");
}
