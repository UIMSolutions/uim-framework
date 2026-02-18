/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.submit;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The SubmitInput class represents an HTML <input> element with the type "submit". It is used to create a submit button that submits a form when clicked.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "submit" by default.
  * Example usage:
  * auto submitButton = H5SubmitInput("Login");
  * assert(submitButton == `<input type="submit" value="Login">`);
  * assert(submitButton.type() == "submit");
  * assert(submitButton.value() == "Login");
  */
class H5SubmitInput : H5Input {
  mixin H5InputThis!("submit");

  mixin(H5Calls!("SubmitInput"));
}
///
unittest {
  auto submitButton = H5SubmitInput("Login");
  assert(submitButton == `<input type="submit" value="Login">`);
  assert(submitButton.type() == "submit");
  assert(submitButton.value() == "Login");  
}