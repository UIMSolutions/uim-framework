/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.reset;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5ResetInput class represents an HTML <input> element with the type "reset". It is used to create input fields that accept reset values, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "reset" by default.
  * Example usage:
  * auto resetInput = H5ResetInput("reset");
  * assert(resetInput == `<input type="reset" name="reset">`);
  * assert(resetInput.type() == "reset");
  * assert(resetInput.name() == "reset");
  */
class H5ResetInput : H5Input {
  mixin H5InputThis!("reset");

  mixin(H5Calls!("ResetInput"));
}
///
unittest {
  auto resetInput = H5ResetInput("reset");
  assert(resetInput == `<input type="reset">`);
  assert(resetInput.type() == "reset");
}