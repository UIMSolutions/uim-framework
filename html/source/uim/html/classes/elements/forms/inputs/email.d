/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.email;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The EmailInput class represents an HTML <input> element with the type "email". It is used to create input fields that accept email addresses, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "email" by default.
  * Example usage:
  * auto emailInput = H5EmailInput("email");
  * assert(emailInput == `<input type="email" name="email">`);
  * assert(emailInput.type() == "email");
  * assert(emailInput.name() == "email"); 
  */
class H5EmailInput : H5Input {
  mixin H5This!("input", false);

  override bool initialize(Json[string] initData = null) {
    super.initialize(initData);

    type("email");
    return true;
  }

  mixin(H5Calls!("EmailInput"));
}
///
unittest {
  auto emailInput = H5EmailInput("email");
  assert(emailInput == `<input type="email" name="email">`);
  assert(emailInput.type() == "email");
  assert(emailInput.name() == "email");  
}