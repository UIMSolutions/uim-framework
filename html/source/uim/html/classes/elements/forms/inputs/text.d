/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.text;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The TextInput class represents an HTML <input> element with the type "text". It is used to create input fields that accept plain text, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "text" by default.
  * Example usage:
  * auto textInput = H5TextInput("username");
  * assert(textInput == `<input type="text" name="username">`);
  * assert(textInput.type() == "text");
  * assert(textInput.name() == "username");
  */
class H5TextInput : H5Input {
  mixin H5InputThis!("text");

  mixin(H5Calls!("TextInput"));
}
///
unittest {
  auto textInput = H5TextInput("username");
  assert(textInput == `<input type="text" name="username">`);
  assert(textInput.type() == "text");
  assert(textInput.name() == "username");  
}