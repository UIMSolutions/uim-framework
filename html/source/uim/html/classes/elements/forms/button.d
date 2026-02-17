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
class H5Button : H5FormElement {
  this() {
    super("button");
  }

  // #region type
  H5Button type(string typeValue) {
    attribute("type", typeValue);
    return this;
  }

  H5Button type() {
    attribute("type");
    return this;
  }
  // #endregion type

  H5Button submit() {
    type("submit");
    return this;
  }

  H5Button reset() {
    type("reset");
    return this;
  }

  H5Button disabled() {
    attribute("disabled", "");
    return this;
  }

  mixin(H5Calls!("button"));
}
/// 
unittest {
  assert(H5Button() == "<button></button>");
  assert(H5Button("Click me") == "<button>Click me</button>");
// TODO:  assert(H5Button().submit() == "<button type=\"submit\"></button>");
// TODO:  assert(H5Button().reset() == "<button type=\"reset\"></button>");
// TODO:  assert(H5Button().disabled() == "<button disabled></button>");
}
