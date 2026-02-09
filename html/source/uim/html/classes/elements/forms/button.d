/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.forms.button;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * HTML button element
  * 
  * The <button> element represents a clickable button, which can be used in forms or anywhere in a document that needs simple, standard button functionality.
  * 
  * Example usage:
  * 
  * <button type="submit">Submit</button>
  * <button type="reset">Reset</button>
  * <button disabled>Disabled Button</button>
  *
  * The content of the <button> element can include text and other inline elements, making it more flexible
  * than the <input type="button"> element, which cannot contain content.
  */
class Button : FormElement {
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

  static Button opCall() {
    return new Button();
  }

  static Button opCall(string text) {
    auto btn = new Button();
    btn.text(text);
    return btn;
  }
}
/// 
unittest {
  assert(Button() == "<button></button>");
  assert(Button("Click me") == "<button>Click me</button>");
  assert(Button().submit() == "<button type=\"submit\"></button>");
  assert(Button().reset() == "<button type=\"reset\"></button>");
  assert(Button().disabled() == "<button disabled></button>");
}
