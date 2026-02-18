/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.button;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5ButtonInput class represents an HTML <input> element with the type "button". It is used to create input fields that allow users to trigger actions when clicked, and can include attributes such as name and value to define the button's behavior and appearance.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "button" by default.
  * Example usage:
  * auto buttonInput = H5ButtonInput("button");
  * assert(buttonInput == `<input type="button" name="button">`);
  * assert(buttonInput.type() == "button");
  * assert(buttonInput.name() == "button");
  */
class H5ButtonInput : H5Input {
  mixin H5This!("input", false);

  override bool initialize(Json[string] initData = null) {
    super.initialize(initData);
    
    type("button");
    return true;  
  }

  mixin(H5Calls!("ButtonInput"));
}
///
unittest {
  auto buttonInput = H5ButtonInput("button");
  assert(buttonInput == `<input type="button" name="button">`);
  assert(buttonInput.type() == "button");
  assert(buttonInput.name() == "button");  
}