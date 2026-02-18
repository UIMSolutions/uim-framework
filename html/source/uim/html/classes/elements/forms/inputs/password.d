/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.password;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The PasswordInput class represents an HTML <input> element with the type "password". It is used to create input fields that accept passwords, and typically masks the input characters for security.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "password" by default.
  * Example usage:
  * auto passwordInput = H5PasswordInput("password");
  * assert(passwordInput == `<input type="password" name="password">`);
  * assert(passwordInput.type() == "password");
  * assert(passwordInput.name() == "password"); 
  */
class H5PasswordInput : H5Input {
  mixin H5InputThis!("password");

  mixin(H5Calls!("PasswordInput"));
}
///
unittest {
  auto passwordInput = H5PasswordInput("password");
  assert(passwordInput == `<input type="password" name="password">`);
  assert(passwordInput.type() == "password");
  assert(passwordInput.name() == "password");  
}