/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.tel;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5TelInput class represents an HTML <input> element with the type "tel". It is used to create input fields that accept telephone number values, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "tel" by default.
  * Example usage:
  * auto telInput = H5TelInput("phone");
  * assert(telInput == `<input type="tel" name="phone">`);
  * assert(telInput.type() == "tel");
  * assert(telInput.name() == "phone");
  */
class H5TelInput : H5Input {
  mixin H5InputThis!("tel");

  mixin(H5Calls!("TelInput"));
}
///
unittest {
  auto telInput = H5TelInput("phone");
  assert(telInput == `<input type="tel" />`);
  assert(telInput.type() == "tel");
}