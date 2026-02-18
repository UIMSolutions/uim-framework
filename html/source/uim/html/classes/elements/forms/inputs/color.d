/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.color;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5ColorInput class represents an HTML <input> element with the type "color". It is used to create input fields that allow users to select a color, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "color" by default.
  * Example usage:
  * auto colorInput = H5ColorInput("color");
  * assert(colorInput == `<input type="color" name="color">`);
  * assert(colorInput.type() == "color");
  * assert(colorInput.name() == "color");
  */
class H5ColorInput : H5Input {
  mixin H5InputThis!("color");

  mixin(H5Calls!("ColorInput"));
}
///
unittest {
  auto colorInput = H5ColorInput("color");
  assert(colorInput == `<input type="color" name="color">`);
  assert(colorInput.type() == "color");
  assert(colorInput.name() == "color");  
}